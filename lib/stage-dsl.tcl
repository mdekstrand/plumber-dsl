package provide plumber::dsl::stage 0.1;
package require huddle;

namespace eval plumber::dsl::stage {
    variable name
    variable stage
    variable deps
    variable outs

    namespace export cmd wdir dep out root_relpath

    proc _append {key obj} {
        variable stage
        if {$key in [huddle keys $stage]} {
            set list [huddle get $stage $key]
            huddle append list $obj
        } else {
            set list [huddle list $obj]
        }
        huddle set stage $key $list
    }

    proc _root_path {path} {
        variable stage
        set wdir ""
        if {"wdir" in [huddle keys $stage]} {
            set wdir [huddle get_stripped $stage wdir]
        }
        set path [file join $::plumber::stage_prefix $wdir $path]
        return [::plumber::rel_path $path]
    }

    # Get a relative path to the root
    proc root_relpath {} {
        variable stage
        set path [list]
        set wdir ""
        if {"wdir" in [huddle keys $stage]} {
            set wdir [huddle get_stripped $stage wdir]
        }
        set parts [list]
        foreach p [file split $::plumber::stage_prefix] {
            lappend path ".."
        }
        foreach p [file split $wdir] {
            if {$p eq ".." && [lindex $path 0] eq ".."} {
                lshift path
            } else {
                error "cannot resolve path $::plumber::stage_prefix$wdir"
            }
        }
        return [file join $path]
    }

    proc cmd {args} {
        variable stage
        set cmd [concat {*}$args]
        huddle set stage cmd [huddle string $cmd]
    }

    proc wdir {dir} {
        variable stage
        huddle set stage wdir $dir
    }

    proc dep {args} {
        variable name
        variable stage
        variable deps
        foreach arg $args {
            _append deps [huddle string $arg]
            lappend deps [_root_path $arg]
        }
    }

    proc out {args} {
        variable name
        variable stage
        variable outs
        set cache 1
        set mode outs
        foreach arg $args {
            switch -- $arg {
                -nocache {
                    set cache 0
                }
                -metric {
                    set mode metrics
                }
                default {
                    if {$cache} {
                        set out [huddle string $arg]
                    } else {
                        set cobj [huddle create cache [huddle string false]]
                        set out [huddle create $arg $cobj]
                    }
                    _append $mode $out
                    lappend outs [_root_path $arg]
                }
            }
        }
    }
}
