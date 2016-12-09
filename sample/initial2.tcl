
# ========================================================================================
#调试记录：
#创建一个端口，location为已占用端口，没有报错，且返回值为1？
#device_create device：
#  加cvlan和svlan参数没有生效？
#device_config device：
#  修改cvlan和svlan，该对象的ip地址啥的变成了默认值？
#device_config ospfv2:
#  必须带上password，要不就报错；且fiberhome的密码，在界面上显示的是fiberhom
#  md5的配置报错
#device_create isis:
#  level_type没有设置成功；且device_config修改也无效;
#  希望支持isis1.lsp1.isisrouteblock1三级的配置；
#  isis的创建，默认都使能了wide_metric，使用device_config修改为N也没有生效。
#  L2时，修改的hello_interval和hello_interval，结果显示修改的是L1的；
#  md5认证配置有误，需讨论。
#traffic_create 建立两个device的绑定流，报错；
#traffic_create 建立端口到端口的裸流，cvlan为100，报错；
#device_stop报错
# ========================================================================================



set ::LOG_LEVEL info
set res pass

set dir [file dirname [info script]]
if {[string equal $dir "."]} {set dir [pwd]}

#自动找到参数文件
set global_dir [join "[lreplace [split $dir /] end-1 end]" /]
source $global_dir/global.tcl
set parameter_dir [join [lreplace [split $dir /] end end parameter_file] /] 
source $parameter_dir/parameter.tcl

#自动找到烽火库文件
set FHLib_PATH [join "[lreplace [split $dir /] end-1 end] alllib/fhlib" /]
puts *****************************$FHLib_PATH
lappend auto_path $FHLib_PATH
package require fhlib 

puts >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

if {[catch {

puts "调烽火的库LoadLib加载指定的仪表库"
fhlib::loadlib -type $::type



puts "1.加载仪表自动化软件包"
package require $libname
puts 11111111111111
::${libname}::Logto -level debug -msg "1.加载仪表自动化软件包"
	
puts "2.加载仪表库函数"
${libname}::instrument_info_load -version $version
::${libname}::Logto -msg "2.加载仪表库函数"

port_create  -name port1  -port_location //172.18.2.9/1/15 -port_type EthernetFiber 
port_modify  -port port1  -media fiber  -speed 1g 
port_create  -name port2  -port_location //172.18.2.9/1/16 -port_type EthernetFiber 
port_modify  -port port2  -media fiber  -speed 1g 

# port_create -name port3 -port_location "//172.18.2.9/1/15"
# port_create {-name port1 -port_location "//172.18.2.9/1/15"} {-name port2 -port_location "//172.18.2.9/1/16"}
# ::${libname}::port_create {-name port1} {-name port2}
# set port1 "//172.18.2.9/1/15"
# set port2 "//172.18.2.9/1/16"
# port_create "-name port1 -port_location $port1" "-name port2 -port_location $port2"  


# port_create {-name port1 -port_location //192.168.200.222/1/13} {-name port2 -port_location //192.168.200.222/1/14}
# port_config -port {port1 {-media fiber -speed 1g} port2 {-media fiber -speed 1g}}

::${libname}::device_create -name device1 -obj_type device -port port1 -args_value {-ipv4_address 12.12.12.1 -ipv4_mask 24 -ipv4_gateway 12.12.12.2} 
::${libname}::device_create -name device2 -obj_type device -port port2 -args_value {-ipv4_address 12.12.12.2 -ipv4_mask 24 -ipv4_gateway 12.12.12.1} 

::${libname}::device_create -name device3 -obj_type device -port port1 -args_value {-ipv4_address 13.13.13.1 -ipv4_mask 24 -ipv4_gateway 13.13.13.2}
::${libname}::device_create -name device4 -obj_type device -port port2 -args_value {-ipv4_address 13.13.13.2 -ipv4_mask 24 -ipv4_gateway 13.13.13.1}

::${libname}::device_create -name device5 -obj_type device -port port1 -args_value {-ipv4_address 14.14.14.1 -ipv4_mask 24 -ipv4_gateway 14.14.14.2}
::${libname}::device_create -name device6 -obj_type device -port port2 -args_value {-ipv4_address 14.14.14.2 -ipv4_mask 24 -ipv4_gateway 14.14.14.1}

::${libname}::device_create -name router7 -obj_type device -port port1 -args_value {-ipv4_address 15.15.15.1 -ipv4_mask 24 -ipv4_gateway 15.15.15.2}
::${libname}::device_create -name router8 -obj_type device -port port2 -args_value {-ipv4_address 15.15.15.2 -ipv4_mask 24 -ipv4_gateway 15.15.15.1}

::${libname}::device_create -name device3.ospf1 -obj_type device.ospfv2 
::${libname}::device_config -name ospf1 -obj_type ospfv2 -args_value {-network_type p2p}
::${libname}::device_create -name device3.ospf1.lsa1 -obj_type device.ospfv2.netsummarylsa -args_value {-start_ip 1.0.0.1 -ip_count 100}
::${libname}::device_create -name device4.ospf2 -obj_type device.ospfv2 -args_value {-network_type p2p}
::${libname}::device_create -name device4.ospf2.lsa2 -obj_type device.ospfv2.netsummarylsa -args_value {-start_ip 2.0.0.1 -ip_count 100}
::${libname}::device_create -name device4.ospf2.lsa3 -obj_type device.ospfv2.externalsa -args_value {-start_ip 3.0.0.1 -ip_count 100}

::${libname}::device_create -name device5.isis1 -obj_type device.isis -args_value {-network_type p2p} 
::${libname}::device_create -name device5.isis1.lsp1 -obj_type device.isis.isis_lsp -args_value {-sys_id 0000.0001.0001}  
::${libname}::device_create -name device5.isis1.lsp1.isisrouteblock1 -obj_type device.isis.isis_lsp.isis_ipv4route -args_value {-start_ip 4.0.0.1 -route_count 100}
::${libname}::device_create -name device5.isis1.lsp1.isisrouteblock2 -obj_type device.isis.isis_lsp.isis_ipv4route -args_value {-start_ip 5.0.0.1 -route_count 100 -route_type external}
::${libname}::device_create -name device6.isis2 -obj_type device.isis -args_value {-network_type p2p}
::${libname}::device_create -name device6.isis2.lsp2 -obj_type device.isis.isis_lsp -args_value {-sys_id 0000.0001.0002}  
::${libname}::device_create -name device6.isis2.lsp2.isisrouteblock3 -obj_type device.isis.isis_lsp.isis_ipv4route -args_value {-start_ip 6.0.0.1 -route_count 100}
::${libname}::device_create -name device6.isis2.lsp2.isisrouteblock4 -obj_type device.isis.isis_lsp.isis_ipv4route -args_value {-start_ip 7.0.0.1 -route_count 100}

::${libname}::device_create -name router7.bgp1 -obj_type device.bgp -args_value {-as_num 100 -dut_as 100 -dut_ip 15.15.15.2}
::${libname}::device_create -name router7.bgp1.bgprouteblock1 -obj_type device.bgp.bgp_ipv4route -args_value {-start_ip 8.0.0.1 -route_count 100}
::${libname}::device_create -name router8.bgp2 -obj_type device.bgp -args_value {-as_num 100 -dut_as 100 -dut_ip 15.15.15.1}
::${libname}::device_create -name router8.bgp2.bgprouteblock2 -obj_type device.bgp.bgp_ipv4route -args_value {-start_ip 9.0.0.1 -route_count 100}



::${libname}::traffic_create -name streamblock3 -port port1 -rxport port2 -srcip 4.4.4.4 -dstip 8.8.8.8 -cvlanid 100
::${libname}::traffic_create -name port1_port2_1 -port port1 -srcbinding device1 -dstbinding device2
::${libname}::traffic_create -name port2_port1_1 -port port2 -srcbinding device2 -dstbinding device1

::${libname}::traffic_create -name port1_port2_2 -port port1 -srcbinding device3 -dstbinding ospf2
::${libname}::traffic_create -name port2_port1_2 -port port1 -srcbinding ospf2 -dstbinding device3
::${libname}::traffic_create -name port1_port2_3 -port port1 -srcbinding lsa1 -dstbinding lsa2
::${libname}::traffic_create -name port2_port1_3 -port port1 -srcbinding lsa2 -dstbinding lsa1

::${libname}::traffic_create -name port1_port2_4 -port port1 -srcbinding isis1 -dstbinding device6
::${libname}::traffic_create -name port2_port1_4 -port port1 -srcbinding device6 -dstbinding isis1
::${libname}::traffic_create -name port1_port2_5 -port port1 -srcbinding isisrouteblock2 -dstbinding isisrouteblock3
::${libname}::traffic_create -name port2_port1_5 -port port1 -srcbinding isisrouteblock3 -dstbinding isisrouteblock2

::${libname}::traffic_create -name port1_port2_6 -port port1 -srcbinding router7 -dstbinding bgp2
::${libname}::traffic_create -name port2_port1_6 -port port1 -srcbinding bgp2 -dstbinding router7
::${libname}::traffic_create -name port1_port2_7 -port port1 -srcbinding bgprouteblock1 -dstbinding bgprouteblock3
::${libname}::traffic_create -name port2_port1_7 -port port1 -srcbinding bgprouteblock3 -dstbinding bgprouteblock1

# ::${libname}::device_create -port port1 -name device11 -obj_type device -args_value "-router_id 192.0.0.1 -src_mac 00:00:01:00:00:01 -ipv6_address 2001::10 -ipv6_gateway 2001::20 -ipv6_link_local_address fe80::123:456:789:abc"
# ::${libname}::device_create -port port2 -name device12 -obj_type device -args_value "-router_id 192.0.0.2 -src_mac 00:00:01:00:00:02 -ipv6_address 2001::20 -ipv6_gateway 2001::10"
# ::${libname}::device_create -name device11.Ospfv3Router1 -obj_type device.ospfv3 -args_value {-area_id 0.0.0.1 -instance_id 10 -network_type p2p -router_pri 3 -option 13}
# ::${libname}::device_create -name device12.Ospfv3Router2 -obj_type device.ospfv3 -args_value {-area_id 0.0.0.1 -instance_id 10 -network_type p2p -router_pri 2 -option 13}
# ::${libname}::device_create -name Ospfv3Router1.Ospfv3Route11 -obj_type ospfv3.interarea_prefixlsa -args_value "-start_address 2020::1 -route_count 100 -metric_lsa 10"
# ::${libname}::device_create -name Ospfv3Router2.Ospfv3Route21 -obj_type ospfv3.ospfv3_externalsa -args_value "-start_address 2030::1 -route_count 100 -metric_lsa 100"



# ::${libname}::device_create -port port1 -name device21 -obj_type device -args_value "-router_id 192.0.0.3 -src_mac 00:00:01:00:01:01 -ipv6_address 2002::10 -ipv6_gateway 2002::20 -ipv6_link_local_address fe80::123:456:789:abc"
# ::${libname}::device_create -port port2 -name device22 -obj_type device -args_value "-router_id 192.0.0.4 -src_mac 00:00:01:00:01:02 -ipv6_address 2002::20 -ipv6_gateway 2002::10"
# ::${libname}::device_create -name device21.isisv6_1 -obj_type device.isis -args_value {-network_type p2p} 
# ::${libname}::device_create -name device21.isisv6_1.isisv6_lsp1 -obj_type device.isis.isis_lsp -args_value {-sys_id 0000.0001.0001}  
# ::${libname}::device_create -name device21.isisv6_1.isisv6_lsp1.isisv6routeblock1 -obj_type device.isis.isis_lsp.isis_ipv6route -args_value {-start_ip 2040::1 -route_count 100}
# ::${libname}::device_create -name device21.isisv6_1.isisv6_lsp1.isisv6routeblock2 -obj_type device.isis.isis_lsp.isis_ipv6route -args_value {-start_ip 2050::1 -route_count 100 -route_type external}
# ::${libname}::device_create -name device22.isisv6_2 -obj_type device.isis -args_value {-network_type p2p}
# ::${libname}::device_create -name device22.isisv6_2.isisv6_lsp2 -obj_type device.isis.isis_lsp -args_value {-sys_id 0000.0001.0002}  
# ::${libname}::device_create -name device22.isisv6_2.isisv6_lsp2.isisv6routeblock3 -obj_type device.isis.isis_lsp.isis_ipv6route -args_value {-start_ip 2060::1 -route_count 100}
# ::${libname}::device_create -name device22.isisv6_2.isisv6_lsp2.isisv6routeblock4 -obj_type device.isis.isis_lsp.isis_ipv6route -args_value {-start_ip 2070::1 -route_count 100}



# ::${libname}::device_create -port port1 -name device31 -obj_type device -args_value "-router_id 192.0.0.5 -src_mac 00:00:01:00:02:01 -ipv6_address 2003::10 -ipv6_gateway 2003::20 -ipv6_link_local_address fe80::123:456:789:abc"
# ::${libname}::device_create -port port2 -name device32 -obj_type device -args_value "-router_id 192.0.0.6 -src_mac 00:00:01:00:02:02 -ipv6_address 2003::20 -ipv6_gateway 2003::10"
# ::${libname}::device_create -name device31.bgp4plus1 -obj_type device.bgp -args_value {-as_num 100 -dut_as 100 -dut_ip 2003::20}
# ::${libname}::device_create -name device31.bgp4plus1.bgpv6routeblock1 -obj_type device.bgp.bgp_ipv6route -args_value {-start_ip 2080::1 -route_count 100}
# ::${libname}::device_create -name device32.bgp4plus2 -obj_type device.bgp -args_value {-as_num 100 -dut_as 100 -dut_ip 2003::10}
# ::${libname}::device_create -name device32.bgp4plus2.bgpv6routeblock2 -obj_type device.bgp.bgp_ipv6route -args_value {-start_ip 2090::1 -route_count 100}




# ######################################################
# 创建ipv4 device的相关调试

# ::${libname}::device_create -name router9 -obj_type device -port port1 -args_value {-ipv4_address 16.16.16.1 -ipv4_mask 24 -cvlan_id 100 -ipv4_gateway 16.16.16.2 }
# ::${libname}::device_create -name router10 -obj_type device -port port2 -args_value {-ipv4_address 16.16.16.2  -ipv4_mask 24 -ipv4_gateway 16.16.16.1  -cvlan_id 100}

# ::${libname}::device_create -name router11 -obj_type device -port port1 -args_value {-ipv4_address 17.17.17.1 -ipv4_mask 28 -svlan_id 100 -ipv4_gateway 17.17.17.2 }
# ::${libname}::device_create -name router12 -obj_type device -port port2 -args_value {-ipv4_address 17.17.17.2  -ipv4_mask 28 -ipv4_gateway 17.17.17.1 -svlan_id 100 -cvlan_id 101}
# ::${libname}::device_config -name router11 -obj_type device -args_value {-ipv4_address 12.12.12.1 -ipv4_mask 24 -ipv4_gateway 12.12.12.2 -svlan_id 200} 
# ::${libname}::device_config -name router11 -obj_type device -args_value {-svlan_id 200} 

# ##################################################

# ######################################################
# 创建ipv6 device的相关调试

# ::${libname}::device_config -name device1 -obj_type device -args_value {-ipv6_address 2003::20 -ipv6_mask 64 -ipv6_gateway 2003::1} 
# ::${libname}::device_config -name device2 -obj_type device -args_value {-ipv6_address 2003::1 -ipv6_mask 64 -ipv6_gateway 2003::20}
# ::${libname}::device_create -name device3 -obj_type device -port port1 -args_value {-ipv6_address 2004::20 -ipv6_mask 64 -ipv6_gateway 2004::1} 
# ::${libname}::device_create -name device4 -obj_type device -port port2 -args_value {-ipv6_address 2004::1 -ipv6_mask 64 -ipv6_gateway 2004::20}
# # ::${libname}::device_create -name device5 -obj_type device -port port1 -args_value {-ipv6_address 2004::20 -ipv6_mask 64 -ipv6_gateway 2004::1 -cvlan_id 100} 
# # ::${libname}::device_create -name device6 -obj_type device -port port2 -args_value {-ipv6_address 2004::1 -ipv6_mask 64 -ipv6_gateway 2004::20 -cvlan_id 100}

# ##################################################

# ######################################################
# 创建ospfv3的相关调试

# ::${libname}::device_create -name device3.ospf1 -obj_type device.ospfv3
# ::${libname}::device_config -name ospf1 -obj_type ospfv3 -args_value {-network_type p2p}  ;#设置无效
# ::${libname}::device_config -name ospf1 -obj_type ospfv3 -args_value {-if_cost 10 -hello_interval 40}     
# ::${libname}::device_create -name device3.ospf1.lsa1 -obj_type device.ospfv3.interarea_prefixlsa  -args_value {-start_ip 2000::1 -ip_count 100}
# ::${libname}::device_create -name device3.ospf1.lsa2 -obj_type device.ospfv3.externalsa  -args_value {-start_ip 2002::1 -ip_count 100}

# ##################################################

# ######################################################
# 创建ospfv2的相关调试

# ::${libname}::device_config -name ospf1 -obj_type ospfv2 -args_value {-if_cost 10 -hello_interval 40}
# ::${libname}::device_config -name ospf1 -obj_type ospfv2 -args_value {-authentication simple -password fiberhome}
# #
# ::${libname}::device_config -name ospf1 -obj_type ospfv2 -args_value {-authentication md5 -md5_keyid 1}
# #md5的配置报错

# ##################################################

# ######################################################
# 创建Isis ipv4的相关调试

# # ::${libname}::device_config -name isis1 -obj_type isis -args_value {-level_type L1} 
# #level_type没有设置成功；且device_config修改也无效
# ::${libname}::device_config -name isis1 -obj_type isis -args_value {-metric_type N}
# ::${libname}::device_config -name isis2 -obj_type isis -args_value {-metric_type N}
# #isis的创建，默认都使能了wide_metric，使用device_config修改为N也没有生效。
# ::${libname}::device_config -name isis1 -obj_type isis -args_value {-sys_id 0000.0000.0001 -area_id1 49.0000}
# ::${libname}::device_config -name isis1 -obj_type isis -args_value {-hello_interval 20 -hello_interval 60 -max_lspsize 1518 -lsp_refresh 600}
# #L2时，修改的hello_interval和hello_interval时L1的；
# ::${libname}::device_config -name isis1 -obj_type isis -args_value {-isis_authentication md5 -isis_password fiber -isis_md5_keyid 1}

# ##################################################



# ######################################################
# 创建bgp ipv4的相关调试

# ::${libname}::device_config -name bgp1 -obj_type bgp -args_value {-as_num 100 -dut_as 200}
# ::${libname}::device_config -name bgp1 -obj_type bgp -args_value {-authentication md5 -password fiberhome}

# ##################################################





# # ::${libname}::device_start -device {device3}  ;#预期效果，使能device3上的ospf协议，启动ospf。但是该命令下发后，没有进行相关项的使能，且启动协议连接的是start protocol。
# # ::${libname}::device_stop -device {device3} ;#预期效果，去使能device3上的ospf协议，停止ospf。

# # device_start -device {device3 device5}  ;#预期效果，使能device3上的ospf协议，device5上的isis协议，启动ospf、isis。
# # device_stop -device {device3 device5} ;#预期效果，去使能device3上的ospf协议，device5上的isis协议，停止ospf、isis。

# # device_start -device {device*}  ;#预期效果，使能匹配device字眼的所有device，启动协议。
# # device_stop -device {device*} ;#预期效果，去使能匹配device字眼的所有device，停止协议。

# # device_start  ;#预期效果，启动所有协议，下发后有报错
# # device_stop  ;#预期效果，停止所有协议，下发后有报错

# ::${libname}::file_save -name test1 -file_path D:/	

if {$res == "pass"} {
		::${libname}::Logto -msg "\nTest Result: correct"
	} else {
		::${libname}::Logto -msg $ErrorInfo1
		::${libname}::Logto -msg "\nTest Result: wrong"
           }

} err]} {
    ::${libname}::Logto -msg "Error Info: $err"
	::${libname}::Logto -msg "\nTest Result: wrong"
} 

