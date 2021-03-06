#lappend auto_path [file dirname [file dirname [file dirname [info script]]]]

lappend auto_path {C:\Ixia\Workspace\ixia_ixN_FH}
package req IxiaFH
Login
#IxDebugOn
IxDebugOn
::IxiaFH::port_create -name i1_d1_1 
::IxiaFH::port_create -name i1_d2_1 

#::IxiaFH::port_create -name i1_d1_1 -port_location "//172.16.174.133/1/1" -port_type EthernetFiber 
#::IxiaFH::port_create -name i1_d2_1 -port_location "//172.16.174.133/2/1" -port_type EthernetFiber 

#::IxiaFH::port_modify -port i1_d1_1 -media copper -speed 1g 
#::IxiaFH::port_modify -port i1_d2_1 -media copper -speed 1g 

#::IxiaFH::device_create -name i1p1_ka -port i1_d1_1 -obj_type device -args_value { -src_mac 00:10:94:00:00:01 }
::IxiaFH::device_create -name i1p1_ka -port i1_d1_1 -obj_type device -args_value { -ipv4_gateway 1.1.1.10 -ipv4_address 1.1.1.1 }
::IxiaFH::device_create -name i1p2_demk -port i1_d2_1 -obj_type device -args_value { -src_mac 00:10:94:00:00:02 }
::IxiaFH::device_create -name i1p1_ka.ospfv2 -port i1_d1_1 -obj_type device.ospfv3 -args_value { -instance_id 100 -area_id 0.0.0.1 -network_type p2p }

::IxiaFH::traffic_create -name i1p1_s -port i1_d1_1 \
                -srcbinding i1p1_ka \
                -dstbinding i1p2_demk \
                -framesize_fix 1000 \
                -load_mode fixed \
                -load_unit fps \
                -load 1000 
::IxiaFH::traffic_create -name i1p2_bijv \
                -port i1_d2_1 \
                -srcbinding i1p2_demk \
                -dstbinding i1p1_ka \
                -framesize_fix 1000 \
                -load_mode fixed \
                -load_unit fps \
                -load 1000 

::IxiaFH::traffic_start -streamblock i1p1_s
::IxiaFH::traffic_stop 
set ::result_var [::IxiaFH::results_get -counter S:*.* ]
set ::result_var [::IxiaFH::results_get -counter S:*.* ]
