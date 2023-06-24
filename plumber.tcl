#!/usr/bin/env tclsh
package provide plumber 0.1;
package require logging;
package require huddle;
package require yaml;

package require plumber::dsl
package require plumber::dsl::stage

proc render_pipeline {file} {
    set dir [file dirname $file]
    set dvc [file join $dir dvc.yaml]
    msg -info "rendering $dvc"

    # save stages
    set saved $::plumber::dsl::stages
    set ::plumber::dsl::stages [huddle create]

    # run pipeline
    msg -debug "running $file"
    namespace eval ::plumber::dsl source $file

    # render
    msg -debug "rendering pipeline YAML"
    set pipe [huddle create stages $::plumber::dsl::stages]
    set yaml [yaml::huddle2yaml $pipe 2 80]

    # save
    msg -debug "saving $dvc"
    set fp [open $dvc w]
    puts $fp $yaml
    close $fp

    # restore stages
    set ::plumber::dsl::stages $saved
}
