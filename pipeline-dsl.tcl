package provide plumber::dsl 0.1;
package require huddle;

namespace eval plumber::dsl {
    variable stages ""

    proc stage {name args} {
        variable stages
        while {![lempty $args]} {
            set arg [lshift args]
            switch -- $arg {
                -items {
                    set items [lshift args]
                }
                -* {
                    error "stage: invalid flag $arg"
                }
                default {
                    if {![info exists body]} {
                        set body $arg
                    } else {
                        error "stage: too many arguments"
                    }
                }
            }
        }

        if {![info exists body]} {
            error "stage: no body provided"
        }

        set ::plumber::dsl::stage::name $name
        set ::plumber::dsl::stage::stage [huddle create]
        msg -debug "configuring stage $name"
        namespace eval ::plumber::dsl::stage $body
        set stage $::plumber::dsl::stage::stage
        if {[info exists items]} {
            set stage [huddle create \
                foreach [huddle compile list $items] \
                do $stage
            ]
        }
        huddle set stages $name $stage
        msg -trace "stage: $::plumber::dsl::stage::stage"
    }
}
