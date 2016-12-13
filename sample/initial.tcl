
# ========================================================================================
#���Լ�¼��
#����һ���˿ڣ�locationΪ��ռ�ö˿ڣ�û�б����ҷ���ֵΪ1��
#device_create device��
#  ��cvlan��svlan����û����Ч��
#device_config device��
#  �޸�cvlan��svlan���ö����ip��ַɶ�ı����Ĭ��ֵ��
#device_config ospfv2:
#  �������password��Ҫ���ͱ�����fiberhome�����룬�ڽ�������ʾ����fiberhom
#  md5�����ñ���
#device_create isis:
#  level_typeû�����óɹ�����device_config�޸�Ҳ��Ч;
#  ϣ��֧��isis1.lsp1.isisrouteblock1���������ã�
#  isis�Ĵ�����Ĭ�϶�ʹ����wide_metric��ʹ��device_config�޸�ΪNҲû����Ч��
#  L2ʱ���޸ĵ�hello_interval��hello_interval�������ʾ�޸ĵ���L1�ģ�
#  md5��֤�������������ۡ�
#traffic_create ��������device�İ���������
#traffic_create �����˿ڵ��˿ڵ�������cvlanΪ100������
#device_stop����
# ========================================================================================

set ::LOG_LEVEL info
lappend auto_path {C:\Ixia\Workspace\ixia_ixN_FH}
package req IxiaFH
Login
IxDebugOn
#::IxiaFH::port_create -name port1 
#::IxiaFH::port_create -name port2 
::IxiaFH::port_create  -name port1  -port_location //172.16.174.134/1/1 -port_type EthernetFiber 
#::IxiaFH::port_modify  -port port1  -media fiber  -speed 1g 
::IxiaFH::port_create  -name port2  -port_location //172.16.174.134/2/1 -port_type EthernetFiber 
#::IxiaFH::port_modify  -port port2  -media fiber  -speed 1g 

::IxiaFH::device_create -name device1 -obj_type device -port port1 -args_value {-ipv4_address 12.12.12.1 -ipv4_mask 24 -ipv4_gateway 12.12.12.2} 
::IxiaFH::device_create -name device2 -obj_type device -port port2 -args_value {-ipv4_address 12.12.12.2 -ipv4_mask 24 -ipv4_gateway 12.12.12.1} 

::IxiaFH::device_create -name device3 -obj_type device -port port1 -args_value {-ipv4_address 13.13.13.1 -ipv4_mask 24 -ipv4_gateway 13.13.13.2}
::IxiaFH::device_create -name device4 -obj_type device -port port2 -args_value {-ipv4_address 13.13.13.2 -ipv4_mask 24 -ipv4_gateway 13.13.13.1}

#::IxiaFH::device_create -name device5 -obj_type device -port port1 -args_value {-ipv4_address 14.14.14.1 -ipv4_mask 24 -ipv4_gateway 14.14.14.2}
#::IxiaFH::device_create -name device6 -obj_type device -port port2 -args_value {-ipv4_address 14.14.14.2 -ipv4_mask 24 -ipv4_gateway 14.14.14.1}
#
#::IxiaFH::device_create -name router7 -obj_type device -port port1 -args_value {-ipv4_address 15.15.15.1 -ipv4_mask 24 -ipv4_gateway 15.15.15.2}
#::IxiaFH::device_create -name router8 -obj_type device -port port2 -args_value {-ipv4_address 15.15.15.2 -ipv4_mask 24 -ipv4_gateway 15.15.15.1}
#
#
#::IxiaFH::device_create -name device3.ospf1 -obj_type device.ospfv2 
#::IxiaFH::device_config -name ospf1 -obj_type ospfv2 -args_value {-network_type p2p}
#::IxiaFH::device_create -name device3.ospf1.lsa1 -obj_type device.ospfv2.netsummarylsa -args_value {-start_ip 1.0.0.1 -ip_count 100}
#::IxiaFH::device_create -name device4.ospf2 -obj_type device.ospfv2 -args_value {-network_type p2p}
#::IxiaFH::device_create -name device4.ospf2.lsa2 -obj_type device.ospfv2.netsummarylsa -args_value {-start_ip 2.0.0.1 -ip_count 100}
#::IxiaFH::device_create -name device4.ospf2.lsa3 -obj_type device.ospfv2.externalsa -args_value {-start_ip 3.0.0.1 -ip_count 100}
#
#
#::IxiaFH::device_create -name device5.isis1 -obj_type device.isis -args_value {-network_type p2p}
##device_start -device {device5}
##device_stop -device {device5}
##device_start -device {device3 device5}
#::IxiaFH::device_create -name device5.isis1.lsp1 -obj_type device.isis.isis_lsp -args_value {-sys_id 0000.0001.0001}  
#::IxiaFH::device_create -name device5.isis1.lsp1.isisrouteblock1 -obj_type device.isis.isis_lsp.isis_ipv4route -args_value {-start_ip 4.0.0.1 -route_count 100}
#::IxiaFH::device_create -name device5.isis1.lsp1.isisrouteblock2 -obj_type device.isis.isis_lsp.isis_ipv4route -args_value {-start_ip 5.0.0.1 -route_count 100 -route_type external}
#::IxiaFH::device_create -name device6.isis2 -obj_type device.isis -args_value {-network_type p2p}
#::IxiaFH::device_create -name device6.isis2.lsp2 -obj_type device.isis.isis_lsp -args_value {-sys_id 0000.0001.0002}  
#::IxiaFH::device_create -name device6.isis2.lsp2.isisrouteblock3 -obj_type device.isis.isis_lsp.isis_ipv4route -args_value {-start_ip 6.0.0.1 -route_count 100}
#::IxiaFH::device_create -name device6.isis2.lsp2.isisrouteblock4 -obj_type device.isis.isis_lsp.isis_ipv4route -args_value {-start_ip 7.0.0.1 -route_count 100}
#
#
#::IxiaFH::device_create -name router7.bgp1 -obj_type device.bgp -args_value {-as_num 100 -dut_as 100 -dut_ip 15.15.15.2}
#::IxiaFH::device_config -name router7.bgp1 -obj_type device.bgp -args_value {-keep_time 100 -dut_as 100 -dut_ip 15.15.15.2}
#::IxiaFH::device_create -name router7.bgp1.bgprouteblock1 -obj_type device.bgp.bgp_ipv4route -args_value {-start_ip 8.0.0.1 -route_count 100}
#::IxiaFH::device_create -name router8.bgp2 -obj_type device.bgp -args_value {-as_num 100 -dut_as 100 -dut_ip 15.15.15.1}
#::IxiaFH::device_create -name router8.bgp2.bgprouteblock2 -obj_type device.bgp.bgp_ipv4route -args_value {-start_ip 9.0.0.1 -route_count 100}

#::IxiaFH::device_start -device {device3}
#::IxiaFH::device_start

#::IxiaFH::device_stop -device {device3}
#::IxiaFH::device_stop

::IxiaFH::traffic_create -name streamblock1 -port port1 -rxport port2 -srcip 4.4.4.4 -dstip 8.8.8.8 -cvlanid 100
::IxiaFH::traffic_create -name streamblock2 -port port1 -rxport port2 -cvlanid 100
::IxiaFH::traffic_config -name streamblock2 -framesize_fix 1280
#catch { ::IxiaFH::traffic_start -streamblock {streamblock1 streamblock2} }
::IxiaFH::traffic_start -arp 1
#catch { ::IxiaFH::traffic_start }
::IxiaFH::traffic_create -name streamblock4 -port port1 -rxport {port2 port3}
# ::IxiaFH::traffic_create -name port1_port2_1 -port port1 -srcbinding device1 -dstbinding device2
# ::IxiaFH::traffic_create -name port2_port1_1 -port port2 -srcbinding device2 -dstbinding device1
# ::IxiaFH::traffic_create -name port1_port2_2 -port port1 -srcbinding device3 -dstbinding ospf2
# ::IxiaFH::traffic_config -name port1_port2_2 -port port1 -srcbinding device3 -dstbinding ospf2
# ::IxiaFH::traffic_create -name port2_port1_2 -port port2 -srcbinding ospf2 -dstbinding device3
# ::IxiaFH::traffic_create -name port1_port2_3 -port port1 -srcbinding lsa1 -dstbinding lsa2
# ::IxiaFH::traffic_create -name port2_port1_3 -port port2 -srcbinding lsa2 -dstbinding lsa1

# ::IxiaFH::traffic_create -name port1_port2_4 -port port1 -srcbinding isis1 -dstbinding device6
# ::IxiaFH::traffic_create -name port2_port1_4 -port port2 -srcbinding device6 -dstbinding isis1
# ::IxiaFH::traffic_create -name port1_port2_5 -port port1 -srcbinding isisrouteblock2 -dstbinding isisrouteblock3
# ::IxiaFH::traffic_create -name port2_port1_5 -port port2 -srcbinding isisrouteblock3 -dstbinding isisrouteblock2

# ::IxiaFH::traffic_create -name port1_port2_6 -port port1 -srcbinding router7 -dstbinding bgp2
# ::IxiaFH::traffic_create -name port2_port1_6 -port port2 -srcbinding bgp2 -dstbinding router7
# ::IxiaFH::traffic_create -name port1_port2_7 -port port1 -srcbinding bgprouteblock1 -dstbinding bgprouteblock2
# ::IxiaFH::traffic_config -name port1_port2_7 -srcbinding bgprouteblock1 -dstbinding bgprouteblock2
# ::IxiaFH::traffic_create -name port2_port1_7 -port port2 -srcbinding bgprouteblock2 -dstbinding bgprouteblock1
# ::IxiaFH::traffic_config -name port2_port1_7 -srcbinding bgprouteblock2 -dstbinding bgprouteblock1
# ::IxiaFH::traffic_create -name port2_port1_7_1 -port port2 -srcbinding bgprouteblock2 -dstbinding bgprouteblock1



::IxiaFH::device_create -port port1 -name device11 -obj_type device -args_value "-router_id 192.0.0.1 -src_mac 00:00:01:00:00:01 -ipv6_address 2001::10 -ipv6_gateway 2001::20 -ipv6_link_local_address fe80::123:456:789:abc"
# ::IxiaFH::device_create -port port2 -name device12 -obj_type device -args_value "-router_id 192.0.0.2 -src_mac 00:00:01:00:00:02 -ipv6_address 2001::20 -ipv6_gateway 2001::10"
::IxiaFH::device_create -name device11.Ospfv3Router1 -obj_type device.ospfv3 
::IxiaFH::device_config -name device11.Ospfv3Router1 -obj_type device.ospfv3 -args_value {-area_id 0.0.0.1 -instance_id 100 -network_type p2p -router_pri 3 -option 13}
# ::IxiaFH::device_create -name device12.Ospfv3Router2 -obj_type device.ospfv3 -args_value {-area_id 0.0.0.1 -instance_id 10 -network_type p2p -router_pri 2 -option 13}
::IxiaFH::device_create -name device11.Ospfv3Router1.Ospfv3Route11 -obj_type device.ospfv3.interarea_prefixlsa -args_value "-start_address 2020::1 -route_count 100 -metric_lsa 10"
# ::IxiaFH::device_create -name device12.Ospfv3Router2.Ospfv3Route22 -obj_type device.ospfv3.externalsa -args_value "-start_address 2030::1 -route_count 100 -metric_lsa 100"
::IxiaFH::device_config -name Ospfv3Route11 -obj_type interarea_prefixlsa -args_value "-start_address 2033::1" 
# ::IxiaFH::device_config -name Ospfv3Router1 -obj_type ospfv3 -args_value "-option 10"
 
# ::IxiaFH::device_create -port port1 -name device21 -obj_type device -args_value "-router_id 192.0.0.3 -src_mac 00:00:01:00:01:01 -ipv6_address 2002::10 -ipv6_gateway 2002::20"
# ::IxiaFH::device_create -port port2 -name device22 -obj_type device -args_value "-router_id 192.0.0.4 -src_mac 00:00:01:00:01:02 -ipv6_address 2002::20 -ipv6_gateway 2002::10"
# ::IxiaFH::device_create -name device21.isisv6_1 -obj_type device.isis -args_value {-network_type p2p} 
# ::IxiaFH::device_create -name device21.isisv6_1.isisv6_lsp1 -obj_type device.isis.isis_lsp -args_value {-sys_id 0000.0001.0001}  
# ::IxiaFH::device_create -name device21.isisv6_1.isisv6_lsp1.isisv6routeblock1 -obj_type device.isis.isis_lsp.isis_ipv6route -args_value {-start_ip 2040::1 -route_count 100}
# ::IxiaFH::device_create -name device21.isisv6_1.isisv6_lsp1.isisv6routeblock2 -obj_type device.isis.isis_lsp.isis_ipv6route -args_value {-start_ip 2050::1 -route_count 100 -route_type external}
# ::IxiaFH::device_create -name device22.isisv6_2 -obj_type device.isis -args_value {-network_type p2p -metric_type N}
# ::IxiaFH::device_create -name device22.isisv6_2.isisv6_lsp2 -obj_type device.isis.isis_lsp -args_value {-sys_id 0000.0001.0002}  
# ::IxiaFH::device_create -name device22.isisv6_2.isisv6_lsp2.isisv6routeblock3 -obj_type device.isis.isis_lsp.isis_ipv6route -args_value {-start_ip 2060::1 -route_count 100}
# ::IxiaFH::device_create -name device22.isisv6_2.isisv6_lsp2.isisv6routeblock4 -obj_type device.isis.isis_lsp.isis_ipv6route -args_value {-start_ip 2070::1 -route_count 100}


# ::IxiaFH::device_create -port port1 -name device31 -obj_type device -args_value "-router_id 192.0.0.5 -src_mac 00:00:01:00:02:01 -ipv6_address 2003::10 -ipv6_gateway 2003::20"
# ::IxiaFH::device_create -port port2 -name device32 -obj_type device -args_value "-router_id 192.0.0.6 -src_mac 00:00:01:00:02:02 -ipv6_address 2003::20 -ipv6_gateway 2003::10"
# ::IxiaFH::device_create -name device31.bgp4plus1 -obj_type device.bgp -args_value "-as_num 100 -dut_as 100 -dut_ip 2003::20"
# ::IxiaFH::device_create -name device31.bgp4plus1.bgpv6routeblock1 -obj_type device.bgp.bgp_ipv6route -args_value {-start_ip 2080::1 -route_count 100}
# ::IxiaFH::device_create -name device32.bgp4plus2 -obj_type device.bgp -args_value {-as_num 100 -dut_as 100 -dut_ip 2003::10}
# ::IxiaFH::device_create -name device32.bgp4plus2.bgpv6routeblock2 -obj_type device.bgp.bgp_ipv6route -args_value {-start_ip 2090::1 -route_count 100}

# ::IxiaFH::traffic_create -name port1_port2_6 -port port1 -srcbinding device11 -dstbinding Ospfv3Route21 -load_unit fps -load 1000
# ::IxiaFH::traffic_create -name port2_port1_6 -port port1 -srcbinding Ospfv3Router1 -dstbinding Ospfv3Route21 -load_unit fps -load 1000
# ::IxiaFH::traffic_create -name port1_port2_7 -port port1 -srcbinding isisv6routeblock1 -dstbinding {isisv6routeblock3 isisv6routeblock4} -load_unit fps -load 1000
# ::IxiaFH::traffic_create -name port2_port1_7 -port port1 -srcbinding isisv6_1 -dstbinding isisv6routeblock4

# stcqclib::traffic_create -port port1 -name raw1 -rxport port2 \
						 # -srcmac 00:00:00:00:00:01 -dstmac 00:00:00:00:00:02 -srcmac_count 10 \
						 # -svlanid 101 -cvlanid 201  -svlanid_count 10 -svlanid_step 2 \
						 # -srcip 10.0.0.1 -dstip 10.0.0.2 \
						 # -srcipv6 2002::01 -srcipv6_count 10 -dstipv6 2002::100 -ipv6_gateway 2002::01 \
						 # -udpsrcport 2000 -udpdstport 2001 \
						 # -framelength_mode increment -framesize_crement {1 128 256} -load_mode fixed -load 10
						 
						 
# ######################################################
# ����ipv4 device����ص���

# ::IxiaFH::device_create -name router9 -obj_type device -port port1 -args_value {-ipv4_address 16.16.16.1 -ipv4_mask 24 -cvlan_id 100 -ipv4_gateway 16.16.16.2 }
# ::IxiaFH::device_create -name router10 -obj_type device -port port2 -args_value {-ipv4_address 16.16.16.2  -ipv4_mask 24 -ipv4_gateway 16.16.16.1  -cvlan_id 100}

# ::IxiaFH::device_create -name router11 -obj_type device -port port1 -args_value {-ipv4_address 17.17.17.1 -ipv4_mask 28 -svlan_id 100 -ipv4_gateway 17.17.17.2 }
# ::IxiaFH::device_create -name router12 -obj_type device -port port2 -args_value {-ipv4_address 17.17.17.2  -ipv4_mask 28 -ipv4_gateway 17.17.17.1 -svlan_id 100 -cvlan_id 101}
# ::IxiaFH::device_config -name router11 -obj_type device -args_value {-ipv4_address 12.12.12.1 -ipv4_mask 24 -ipv4_gateway 12.12.12.2 -svlan_id 200} 
# ::IxiaFH::device_config -name device1 -obj_type device -args_value {-cvlan_id 200} 

# ##################################################

# ######################################################
# ����ipv6 device����ص���

# ::IxiaFH::device_config -name device1 -obj_type device -args_value {-ipv6_address 2003::20 -ipv6_mask 64 -ipv6_gateway 2003::1} 
# ::IxiaFH::device_config -name device2 -obj_type device -args_value {-ipv6_address 2003::1 -ipv6_mask 64 -ipv6_gateway 2003::20}
# ::IxiaFH::device_create -name device3 -obj_type device -port port1 -args_value {-ipv6_address 2004::20 -ipv6_mask 64 -ipv6_gateway 2004::1} 
# ::IxiaFH::device_create -name device4 -obj_type device -port port2 -args_value {-ipv6_address 2004::1 -ipv6_mask 64 -ipv6_gateway 2004::20}
# # ::IxiaFH::device_create -name device5 -obj_type device -port port1 -args_value {-ipv6_address 2004::20 -ipv6_mask 64 -ipv6_gateway 2004::1 -cvlan_id 100} 
# # ::IxiaFH::device_create -name device6 -obj_type device -port port2 -args_value {-ipv6_address 2004::1 -ipv6_mask 64 -ipv6_gateway 2004::20 -cvlan_id 100}

# ##################################################

# ######################################################
# ����ospfv3����ص���

# ::IxiaFH::device_create -name device3.ospf1 -obj_type device.ospfv3
# ::IxiaFH::device_config -name ospf1 -obj_type ospfv3 -args_value {-network_type broadcast}  ;#������Ч
# ::IxiaFH::device_config -name ospf1 -obj_type ospfv3 -args_value {-if_cost 10 -hello_interval 40}     
# ::IxiaFH::device_create -name device3.ospf1.lsa1 -obj_type device.ospfv3.interarea_prefixlsa  -args_value {-start_ip 2000::1 -ip_count 100}
# ::IxiaFH::device_create -name device3.ospf1.lsa2 -obj_type device.ospfv3.externalsa  -args_value {-start_ip 2002::1 -ip_count 100}

# ##################################################

# ######################################################
# ����ospfv2����ص���

# ::IxiaFH::device_config -name ospf1 -obj_type ospfv2 -args_value {-if_cost 10 -hello_interval 40}
# ::IxiaFH::device_config -name ospf1 -obj_type ospfv2 -args_value {-authentication simple -password fiberhome}
# #
# ::IxiaFH::device_config -name ospf1 -obj_type ospfv2 -args_value {-authentication md5 -md5_keyid 1 -password fiberhom}
# #md5�����ñ���

# ##################################################

# ######################################################
# ����Isis ipv4����ص���

# # ::IxiaFH::device_config -name isis1 -obj_type isis -args_value {-level_type L1} 
# #level_typeû�����óɹ�����device_config�޸�Ҳ��Ч
# ::IxiaFH::device_config -name isis1 -obj_type isis -args_value {-metric_type N}
# ::IxiaFH::device_config -name isis2 -obj_type isis -args_value {-metric_type N}
# #isis�Ĵ�����Ĭ�϶�ʹ����wide_metric��ʹ��device_config�޸�ΪNҲû����Ч��
::IxiaFH::device_config -name isis1 -obj_type isis -args_value {-sys_id 0000.0000.0001 -area_id1 49.0001}
# ::IxiaFH::device_config -name isis1 -obj_type isis -args_value {-hello_interval 20 -holding_time 60 -max_lspsize 1518 -lsp_refresh 600}
# #L2ʱ���޸ĵ�hello_interval��hello_intervalʱL1�ģ�
# ::IxiaFH::device_config -name isis1 -obj_type isis -args_value {-isis_authentication md5 -isis_password fiber -isis_md5_keyid 1}

# ##################################################



# ######################################################
# ����bgp ipv4����ص���

# ::IxiaFH::device_config -name bgp1 -obj_type bgp -args_value {-as_num 100 -dut_as 200}
# ::IxiaFH::device_config -name bgp1 -obj_type bgp -args_value {-authentication md5 -password fiberhome}

# ##################################################





# # ::IxiaFH::device_start -device {device3}  ;#Ԥ��Ч����ʹ��device3�ϵ�ospfЭ�飬����ospf�����Ǹ������·���û�н���������ʹ�ܣ�������Э�����ӵ���start protocol��
# # ::IxiaFH::device_stop -device {device3} ;#Ԥ��Ч����ȥʹ��device3�ϵ�ospfЭ�飬ֹͣospf��

# # device_start -device {device3 device5}  ;#Ԥ��Ч����ʹ��device3�ϵ�ospfЭ�飬device5�ϵ�isisЭ�飬����ospf��isis��
# # device_stop -device {device3 device5} ;#Ԥ��Ч����ȥʹ��device3�ϵ�ospfЭ�飬device5�ϵ�isisЭ�飬ֹͣospf��isis��

# # device_start -device {device*}  ;#Ԥ��Ч����ʹ��ƥ��device���۵�����device������Э�顣
# # device_stop -device {device*} ;#Ԥ��Ч����ȥʹ��ƥ��device���۵�����device��ֹͣЭ�顣

# # ::IxiaFH::device_start  ;#Ԥ��Ч������������Э�飬�·����б���
# # device_stop  ;#Ԥ��Ч����ֹͣ����Э�飬�·����б���

# ::IxiaFH::file_save -name test1 -file_path D:/	

if {$res == "pass"} {
		::IxiaFH::Logto -msg "\nTest Result: correct"
     } else {
		::IxiaFH::Logto -msg $ErrorInfo1
		::IxiaFH::Logto -msg "\nTest Result: wrong"
     }
} err]} {
    ::IxiaFH::Logto -msg "Error Info: $err"
	::IxiaFH::Logto -msg "\nTest Result: wrong"
} 

