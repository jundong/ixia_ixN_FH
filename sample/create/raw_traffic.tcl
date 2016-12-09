#lappend auto_path [file dirname [file dirname [file dirname [info script]]]]

lappend auto_path {C:\Ixia\Workspace\ixia_ixN_FH}
package req IxiaFH
Login
#IxDebugOn
IxDebugOff
#::IxiaFH::port_create -name port1 
#::IxiaFH::port_create -name port2 

::IxiaFH::port_create -name port1 -port_location "//172.16.174.134/1/1"
::IxiaFH::port_create -name port2 -port_location "//172.16.174.134/2/1"

#::IxiaFH::port_modify -port port1 -media copper -speed 1g 
#::IxiaFH::port_modify -port port2 -media copper -speed 1g 

::IxiaFH::traffic_create -name streamblock1 -port port1 -rxport port2 -srcip 4.4.4.4 -dstip 8.8.8.8 -cvlanid 100

::IxiaFH::traffic_start -streamblock streamblock1
::IxiaFH::traffic_stop 
set ::result_var [::IxiaFH::results_get -counter S:*.* ]
set ::result_var [::IxiaFH::results_get -counter S:*.* ]
