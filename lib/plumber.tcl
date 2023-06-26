#!/usr/bin/env tclsh
package provide plumber 0.1;
package require logging;
package require huddle;
package require yaml;

package require plumber::dsl
package require plumber::dsl::stage

namespace eval plumber {
    variable pipeline_root [file normalize .]
    variable stage_names [list]
    variable stage_deps
    variable stage_outs
    variable stage_prefix ""

    array set stage_deps {}
    array set stage_outs {}

    namespace export render_pipeline list_stages stage_deps stage_outs
}

proc plumber::with_saved_state {body} {
    set mem_prefix $::plumber::stage_prefix
    set mem_stages $::plumber::dsl::stages

    uplevel $body

    set ::plumber::stage_prefix $mem_prefix
    set ::plumber::dsl::stages $mem_stages
}

# Render the pipeline in "file"
proc plumber::render_pipeline {file {prefix ""}} {
    set dir [file dirname $file]
    set dvc [file join $dir dvc.yaml]
    msg -info "rendering $dvc"

    with_saved_state {
        set ::plumber::dsl::stages [huddle create]
        append ::plumber::stage_prefix $prefix

        # run pipeline
        msg -debug "running $file"
        namespace eval ::plumber::dsl source $file

        # render
        msg -debug "rendering pipeline YAML"
        set pipe [huddle create stages $::plumber::dsl::stages]
        set yaml [yaml::huddle2yaml $pipe 2 300]

        # save
        msg -debug "saving $dvc"
        set fp [open $dvc w]
        puts $fp $yaml
        close $fp
    }
}

proc plumber::list_stages {} {
    variable stage_names
    return $stage_names
}

proc plumber::stage_deps {name} {
    variable stage_deps
    return $stage_deps($name)
}

proc plumber::stage_outs {name} {
    variable stage_outs
    return $stage_outs($name)
}

proc plumber::rel_path {path} {
    variable pipeline_root
    set path [file normalize $path]
    if {[string match $pipeline_root/* $path]} {
        return [string range $path [expr {[string length $pipeline_root] + 1}] end]
    }
}

proc plumber::log_stage {name deps outs} {
    variable stage_prefix
    variable stage_names
    variable stage_outs
    variable stage_deps

    set name "$stage_prefix$name"
    msg -debug "remembering $name with" [llength $deps] "deps and" [llength $outs] "outs"
    lappend stage_names $name
    set stage_outs($name) $outs
    set stage_deps($name) $deps
    foreach dep $deps {
        msg -trace "dep: $dep"
    }
    foreach out $outs {
        msg -trace "out: $out"
    }
}
