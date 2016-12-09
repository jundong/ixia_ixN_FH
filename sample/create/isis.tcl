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
::IxiaFH::port_create -name i1_d1_1 
::IxiaFH::port_create -name i1_d2_1 

#::IxiaFH::port_modify -port i1_d1_1 -media copper -speed 1g 
#::IxiaFH::port_modify -port i1_d2_1 -media copper -speed 1g 

::IxiaFH::device_create -name i1p1_ka -port i1_d1_1 -obj_type device -args_value { -src_mac 00:10:94:00:00:01 }
::IxiaFH::device_create -name i1p2_demk -port i1_d2_1 -obj_type device -args_value { -src_mac 00:10:94:00:00:02 }

::IxiaFH::device_create -name i1p1_ka.isis1 -port i1_d1_1 -obj_type device.isis
::IxiaFH::device_create -name i1p1_ka.isis1.lsp1 -port i1_d1_1 -obj_type device.isis.isis_lsp -args_value { -level_type L12}
::IxiaFH::device_create -name i1p1_ka.isis1.lsp1.ipv4route1 -port i1_d1_1 -obj_type device.isis.isis_lsp.isis_ipv4route -args_value { -route_count 100}
::IxiaFH::device_config -name i1p1_ka.isis1 -port i1_d1_1 -obj_type device.isis -args_value { -hello_interval 12 -dead_interval 29 -isis_authentication simple}
::IxiaFH::device_start -device {i1p1_ka}

# IPv6 part
::IxiaFH::device_create -name i1p1_ka.isis6-1 -port i1_d1_1 -obj_type device.isis
::IxiaFH::device_create -name i1p1_ka.isis6-1.lsp6-1 -port i1_d1_1 -obj_type device.isis.isis_lsp -args_value { -level_type L12}
::IxiaFH::device_create -name i1p1_ka.isis6-1.lsp6-1.ipv6route1 -port i1_d1_1 -obj_type device.isis.isis_lsp.isis_ipv6route -args_value { -route_count 100}

::IxiaFH::device_create -name i1p2_demk.isis2 -port i1_d2_1 -obj_type device.isis -args_value { -level_type L12 }
::IxiaFH::device_create -name i1p2_demk.isis2.lsp2 -port i1_d1_1 -obj_type device.isis.isis_lsp -args_value { -level_type L12}
::IxiaFH::device_create -name i1p2_demk.isis2.lsp2.ipv4route2 -port i1_d1_1 -obj_type device.isis.isis_lsp.isis_ipv4route -args_value { -route_count 100}
::IxiaFH::device_config -name i1p2_demk.isis2 -port i1_d1_1 -obj_type device.isis -args_value { -hello_interval 12 -dead_interval 29}

::IxiaFH::traffic_create -name raw_1_1 -port i1_d1_1 -rxport i1_d2_1 -srcip 1.1.1.1 -dstip 2.2.2.2 -cvlanid 100

::IxiaFH::traffic_create -name port1_port2_1 -port i1_d1_1 -srcbinding i1p1_ka -dstbinding i1p2_demk
::IxiaFH::traffic_create -name port1_port2_isis1 -port i1_d1_1 -srcbinding isis1 -dstbinding isis2


puts "=================="