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

::IxiaFH::device_create -name i1p1_ka -port i1_d1_1 -obj_type device -args_value { -ipv6_address 2000::2 -ipv6_gateway 2000::20 -src_mac 00:10:94:00:00:01 }
::IxiaFH::device_create -name i1p2_demk -port i1_d2_1 -obj_type device -args_value { -ipv6_address 2000::20 -ipv6_gateway 2000::2 -src_mac 00:10:94:00:00:02 }

::IxiaFH::device_create -name i1p1_ka.ospfv1 -port i1_d1_1 -obj_type device.ospfv3 -args_value { -instance_id 100 }
::IxiaFH::device_create -name i1p2_demk.ospfv2 -port i1_d2_1 -obj_type device.ospfv3 -args_value { -instance_id 110 }

::IxiaFH::device_create -name i1p1_ka.ospfv1.externalsa1 -port i1_d1_1 -obj_type device.ospfv3.externalsa -args_value { -active true -start_address 8000::2 -route_count 88 -prefix_len 88 -metric_lsa 88 }
::IxiaFH::device_create -name i1p2_demk.ospfv2.externalsa2 -port i1_d2_1 -obj_type device.ospfv3.externalsa -args_value { -active true -start_address 9000::2 -route_count 99 -prefix_len 99 -metric_lsa 99 }

::IxiaFH::device_create -name i1p1_ka.ospfv1.interarea_prefixlsa1 -port i1_d1_1 -obj_type device.ospfv3.interarea_prefixlsa -args_value { -active true -start_address 7000::2 -route_count 11 -prefix_len 11 -metric_lsa 11 }
::IxiaFH::device_create -name i1p2_demk.ospfv2.interarea_prefixlsa2 -port i1_d2_1 -obj_type device.ospfv3.interarea_prefixlsa -args_value { -active true -start_address 6.2.2.2 -route_count 22 -prefix_len 22 -metric_lsa 22 }

::IxiaFH::device_config -name i1p1_ka.ospfv1 -port i1_d1_1 -obj_type device.ospfv3 -args_value { -router_id 100.100.100.100 }
::IxiaFH::device_config -name i1p2_demk.ospfv2 -port i1_d2_1 -obj_type device.ospfv3 -args_value { -router_id 110.100.100.100 }

::IxiaFH::device_config -name i1p1_ka.ospfv1.externalsa1 -port i1_d1_1 -obj_type device.ospfv3.externalsa -args_value { -active true -start_address 5000::2 -route_count 88 -prefix_len 8 -metric_lsa 88 }
::IxiaFH::device_config -name i1p2_demk.ospfv2.externalsa2 -port i1_d2_1 -obj_type device.ospfv3.externalsa -args_value { -active true -start_address 4000::2 -route_count 99 -prefix_len 99 -metric_lsa 99 }

::IxiaFH::device_config -name i1p1_ka.ospfv1.interarea_prefixlsa1 -port i1_d1_1 -obj_type device.ospfv3.interarea_prefixlsa -args_value { -active true -start_address 4400::2 -route_count 11 -prefix_len 11 -metric_lsa 11 }
::IxiaFH::device_config -name i1p2_demk.ospfv2.interarea_prefixlsa2 -port i1_d2_1 -obj_type device.ospfv3.interarea_prefixlsa -args_value { -active true -start_address 5500::2 -route_count 22 -prefix_len 22 -metric_lsa 22 }

#::IxiaFH::traffic_create -name i1p1_s -port i1_d1_1 \
#                -srcbinding i1p1_ka \
#                -dstbinding i1p2_demk \
#                -framesize_fix 1000 \
#                -load_mode fixed \
#                -load_unit fps \
#                -load 1000 
#
#::IxiaFH::traffic_create -name i1p2_bijv \
#                -port i1_d2_1 \
#                -srcbinding i1p2_demk \
#                -dstbinding i1p1_ka \
#                -framesize_fix 1000 \
#                -load_mode fixed \
#                -load_unit fps \
#                -load 1000 

#::IxiaFH::traffic_start -streamblock {i1p1_s i1p2_bijv} -arp 1
#::IxiaFH::traffic_stop 
#set ::result_var [::IxiaFH::results_get -counter S:*.* ]

