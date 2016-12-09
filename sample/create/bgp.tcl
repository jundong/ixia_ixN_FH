#lappend auto_path [file dirname [file dirname [file dirname [info script]]]]

lappend auto_path {C:\Ixia\Workspace\ixia_ixN_FH}
package req IxiaFH
Login
#IxDebugOn
IxDebugOff
#Port @tester_to_dta1 NULL NULL ::ixNet::OBJ-/vport:1
#Port @tester_to_dta2 NULL NULL ::ixNet::OBJ-/vport:2

#::IxiaFH::port_create -name i1_d1_1 -port_location "//172.16.174.134/1/1" -port_type EthernetFiber 
#::IxiaFH::port_create -name i1_d2_1 -port_location "//172.16.174.134/2/1" -port_type EthernetFiber 
::IxiaFH::port_create -name port1 
::IxiaFH::port_create -name port2 

#::IxiaFH::port_modify -port i1_d1_1 -media copper -speed 1g 
#::IxiaFH::port_modify -port i1_d2_1 -media copper -speed 1g 

::IxiaFH::device_create -name device1 -port port1 -obj_type device -args_value { -src_mac 00:10:94:00:00:01 }
::IxiaFH::device_create -name device2 -port port2 -obj_type device -args_value { -src_mac 00:10:94:00:00:02 }

::IxiaFH::device_create -name device1.bgp1 -port i1_d1_1 -obj_type device.bgp
::IxiaFH::device_config -name i1p1_ka.bgp1 -port i1_d1_1 -obj_type device.bgp -args_value { -hello_interval 12 -dead_interval 29 -isis_authentication simple}

puts "=================="