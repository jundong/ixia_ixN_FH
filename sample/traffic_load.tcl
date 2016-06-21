#lappend auto_path [file dirname [file dirname [file dirname [info script]]]]

lappend auto_path {C:\Ixia\Workspace\ixia_ixN_FH}
package req IxiaFH
set configfile {C:\Ixia\Workspace\ixia_ixN_FH\sample\configs\traffic.ixncfg}
source {C:\Ixia\Workspace\ixia_ixN_FH\sample\streams\stream_analyze_global.tcl}
#Login
IxDebugOn
#IxDebugOff
::IxiaFH::instrument_config_init -configfile $configfile
#set B29_30_A73_76_A79_82 //10.210.100.12/5/1
#set B25_26_A65_A68 //10.210.100.12/5/2
#set B27_28_A48_A51_A54_57 //10.210.100.12/5/9
#set RNC_8_13 //10.210.100.12/5/10
set ::IxiaFH::i1_d1_1 //172.16.174.133/1/1
set ::IxiaFH::i1_d2_1 //172.16.174.133/2/1

#::IxiaFH::port_reserve -port "$B29_30_A73_76_A79_82  $B25_26_A65_A68 $B27_28_A48_A51_A54_57  $RNC_8_13"  -offline 0
::IxiaFH::port_reserve -port "$::IxiaFH::i1_d1_1  $::IxiaFH::i1_d2_1"  -offline 0
::IxiaFH::device_start
after [expr 10 * 1000]
#::IxiaFH::traffic_start -streamblock i1p1_s -arp 1
::IxiaFH::traffic_start -arp 1

array set ::result_var [::IxiaFH::results_get -counter S:*.* ]
array set ::result_var [::IxiaFH::results_get -counter S:*.* ]