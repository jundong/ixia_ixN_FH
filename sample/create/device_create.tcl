#lappend auto_path [file dirname [file dirname [file dirname [info script]]]]
lappend auto_path {C:\Ixia\Workspace\ixia_ixN_FH}
package req IxiaFH
Login
IxDebugOn
#IxDebugOff
#Port @tester_to_dta1 NULL NULL ::ixNet::OBJ-/vport:1
#Port @tester_to_dta2 NULL NULL ::ixNet::OBJ-/vport:2

#::IxiaFH::port_create -name i1_d1_1 -port_location "//172.16.174.134/1/1" -port_type EthernetFiber 
#::IxiaFH::port_create -name i1_d2_1 -port_location "//172.16.174.134/2/1" -port_type EthernetFiber 
::IxiaFH::port_create -name port1 
::IxiaFH::port_create -name port2 

#::IxiaFH::port_modify -port i1_d1_1 -media copper -speed 1g 
#::IxiaFH::port_modify -port i1_d2_1 -media copper -speed 1g 

::IxiaFH::device_create -name device1 -port port1 -obj_type device -args_value { -ipv4_address 192.85.1.3 -ipv4_gateway 192.85.1.4 }
::IxiaFH::device_config -name device1 -port port1 -obj_type device -args_value { -ipv6_address 2000::1000 -ipv6_gateway 2000::1 }

::IxiaFH::device_create -name device2 -port port2 -obj_type device -args_value { -ipv4_address 192.85.1.4 -ipv4_gateway 192.85.1.3 }
::IxiaFH::device_config -name device2 -port port2 -obj_type device -args_value { -ipv6_address 2000::1 -ipv6_gateway 2000::1000 }

::IxiaFH::device_create -name device1.igmp1 -port port1 -obj_type device.igmp -args_value { -version igmpv2 }
::IxiaFH::device_create -name device1.igmp1.igmpgroup1 -port port1 -obj_type device.igmp.igmp_group -args_value { -version igmpv2 -group_ip_step 2 -group_start_ip 225.0.0.100 }

::IxiaFH::device_create -name device2.igmp2 -port port2 -obj_type device.igmp -args_value { -version igmpv2 }
::IxiaFH::device_create -name device2.igmp2.igmpgroup2 -port port2 -obj_type device.igmp.igmp_group -args_value { -version igmpv2 -group_ip_step 5 -group_start_ip 225.0.0.200 }

::IxiaFH::device_create -name device1.mld1 -port port1 -obj_type device.mld -args_value { -version mldv2 }
::IxiaFH::device_create -name device1.mld1.mldgroup1 -port port1 -obj_type device.mld.mld_group -args_value { -group_ip_step 2 -group_start_ip ff1e::1 }
::IxiaFH::device_config -name device1.mld1.mldgroup1 -port port1 -obj_type device.mld.mld_group -args_value { -group_ip_step 2 -group_start_ip ff1e::1 }

::IxiaFH::device_create -name device2.mld2 -port port2 -obj_type device.mld -args_value { -version mldv2 }
::IxiaFH::device_create -name device2.mld2.mldgroup2 -port port2 -obj_type device.mld.mld_group -args_value { -group_ip_step 5 -group_start_ip ff1e::100 }

puts "=================="