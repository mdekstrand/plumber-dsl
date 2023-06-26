#!/usr/bin/env tclsh
set root [file dirname [info script]]
set auto_path [list $root {*}$auto_path]

package require plumber
package require getopt
namespace import plumber::render_pipeline

getopt arg $argv {
    -v - --verbose {
        # increase logging verbosity
        logging::configure -verbose
    }
    -q - --quiet {
        # suppress informational messages
        logging::configure -quiet
    }
}

render_pipeline pipeline.tcl
