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

::IxiaFH::traffic_create -name i1p1_s -port i1_d1_1 \
                -srcbinding i1p1_ka \
                -dstbinding i1p2_demk \
                -framesize_fix 1000 \
                -load_mode fixed \
                -load_unit fps \
                -load 1000 
                #-dstipv6 3000::20 \
                #-dstipv6_count 10 \
                #-dstipv6_type increment  \
                #-srcipv6 3000::2 \
                #-srcipv6_count 10 \
                #-srcipv6_type increment

::IxiaFH::traffic_create -name i1p2_bijv \
                -port i1_d2_1 \
                -srcbinding i1p2_demk \
                -dstbinding i1p1_ka \
                -framesize_fix 1000 \
                -load_mode fixed \
                -load_unit fps \
                -load 1000
                #-srcipv6 3000::20 \
                #-srcipv6_count 10 \
                #-dstipv6 3000::2 \
                #-dstipv6_count 10 \
                #-dstipv6_type increment  \
                #-srcipv6_type increment

::IxiaFH::traffic_start -streamblock {i1p1_s i1p2_bijv} -arp 1
::IxiaFH::traffic_stop 
set ::result_var [::IxiaFH::results_get -counter S:*.* ]

