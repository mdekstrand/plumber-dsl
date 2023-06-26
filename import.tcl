#!/usr/bin/env tclsh
set root [file dirname [info script]]
set auto_path [list $root {*}$auto_path]

package require getopt
package require logging
package require huddle
package require yaml

set output stdout

getopt arg $argv {
    -v - --verbose {
        # increase logging verbosity
        logging::configure -verbose
    }
    -q - --quiet {
        # suppress informational messages
        logging::configure -quiet
    }

    -o: - --output=FILE {
        # write output to FILE
        set out_file $arg
    }

    arglist {
        # FILE
        if {[llength $arg] != 1} {
            msg -error "must specify exactly one file"
            exit 2
        }
        set file $arg
    }
}

msg -info "reading $file"
set pipeline [yaml::yaml2huddle -file $file]
set stage_defs [huddle get $pipeline stages]
set stage_names [huddle keys $stage_defs]
msg -info "found [llength $stage_names] stages"

if {[info exists out_file]} {
    msg -info "writing to $out_file"
    set output [open $out_file w]
}

foreach name $stage_names {
    set stage [huddle get $stage_defs $name]
    if {"do" in [huddle keys $stage]} {
        msg -warn "stage $name: foreach not supported"
        continue
    }

    puts $output "stage $name {"
    foreach k [huddle keys $stage] {
        switch -- $k {
            cmd -
            wdir {
                puts $output "    $k [huddle get_stripped $stage $k]"
            }
            deps -
            outs {
                set cmd [string range $k 0 end-1]
                foreach file [huddle get_stripped $stage $k] {
                    puts $output "    $cmd $file"
                }
            }
            metrics {
                foreach file [huddle get_stripped $stage metrics] {
                    puts $output "    $cmd -metric $file"
                }
            }
            default {
                msg -warn "unknownstage key $k"
            }
        }
    }
    puts $output "}"
}
