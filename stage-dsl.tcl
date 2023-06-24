package provide plumber::dsl::stage 0.1;
package require huddle;

namespace eval plumber::dsl::stage {
    variable name
    variable stage

    namespace export cmd dep out

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

    proc cmd {args} {
        variable stage
        set cmd [concat {*}$args]
        huddle set stage cmd [huddle string $cmd]
    }

    proc dep {args} {
        variable name
        variable stage
        foreach arg $args {
            _append deps [huddle string $arg]
        }
    }

    proc out {args} {
        variable name
        variable stage
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
                }
            }
        }
    }
}
