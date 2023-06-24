# Tcl package index file, version 1.1
# This file is generated by the "pkg_mkIndex" command
# and sourced either when an application starts up or
# by a "package unknown" script.  It invokes the
# "package ifneeded" command to set up package-related
# information so that packages will be loaded automatically
# in response to "package require" commands.  When this
# script is sourced, the variable $dir must contain the
# full path name of this file's directory.

package ifneeded ansifmt 0.1 [list source [file join $dir common/lib/ansifmt.tcl]]
package ifneeded formats 0.1 [list source [file join $dir common/lib/formats.tcl]]
package ifneeded fsextra 0.1 [list source [file join $dir common/lib/fsextra.tcl]]
package ifneeded getopt 2008.12.07 [list source [file join $dir common/lib/getopt.tcl]]
package ifneeded kvlookup 0.1 [list source [file join $dir common/lib/kvlookup.tcl]]
package ifneeded logging 0.1 [list source [file join $dir common/lib/logging.tcl]]
package ifneeded meuri 0.1 [list source [file join $dir common/lib/meuri.tcl]]
package ifneeded missing 1.1 [list source [file join $dir common/lib/missing.tcl]]
package ifneeded mkyaml 0.1 [list source [file join $dir common/lib/mkyaml.tcl]]
package ifneeded oscmd 0.1 [list source [file join $dir common/lib/oscmd.tcl]]
package ifneeded platinfo 0.1 [list source [file join $dir common/lib/platinfo.tcl]]
package ifneeded plumber 0.1 [list source [file join $dir plumber.tcl]]
package ifneeded plumber::dsl 0.1 [list source [file join $dir pipeline-dsl.tcl]]
package ifneeded plumber::dsl::stage 0.1 [list source [file join $dir stage-dsl.tcl]]
package ifneeded runner 0.1 [list source [file join $dir common/lib/runner.tcl]]
package ifneeded sds 1.0 [list source [file join $dir common/lib/sds.tcl]]
package ifneeded setops 0.1 [list source [file join $dir common/lib/setops.tcl]]
package ifneeded tagline 0.1 [list source [file join $dir common/lib/tagline.tcl]]
