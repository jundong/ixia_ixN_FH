#!/bin/sh
# -*- tcl -*-
# The next line is executed by /bin/sh, but not tcl \
exec tclsh "$0" ${1+"$@"}

package require IxTclNetwork
ixNet connect localhost -version 6.70 -port 8009

set root [ixNet getRoot]
set traffic [ixNet getL $root traffic]
set items [ixNet getL $traffic trafficItem]
set item1 [lindex $items 0]
set item2 [lindex $items 1]
set conf [ixNet getL $item1 configElement]
set high [ixNet getL $item1 highLevelStream]
set high1 [lindex $high 0]
set high2 [lindex $high 1]
set tracking [ixNet getL $item1 tracking]
