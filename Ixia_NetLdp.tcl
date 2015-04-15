
# Copyright (c) Ixia technologies 2010-2011, Inc.

# Release Version 1.1
#===============================================================================
# Change made
# Version 1.0 
#       1. Create
# Version 1.1.2.3
#		1. Add LSP class

class LdpSession {
    inherit RouterEmulationObject
    	
    constructor { port } {
		global errNumber
		
		set tag "body LdpSession::ctor [info script]"
Deputs "----- TAG: $tag -----"

		set portObj [ GetObject $port ]
		if { [ catch {
			set hPort   [ $portObj cget -handle ]
		} ] } {
			error "$errNumber(1) Port Object in DhcpHost ctor"
		}
		
# -- Enable ldp routers 
		ixNet setM $hPort/protocols/ldp \
				-enabled True 
		ixNet commit
		
Deputs Step20
# -- add ldp routers 
		set ldp [ ixNet add $hPort/protocols/ldp router ]
Deputs "ldp:$ldp"
		ixNet setA $ldp -enabled True
		ixNet commit
		set handle [ ixNet remapIds $ldp ]
		
# -- add ldp interface
		set protocol_interface [ ixNet add $hPort interface ]
		ixNet setA $protocol_interface -enabled True
		ixNet commit
		set protocol_interface [ixNet remapIds $protocol_interface]

		set interface [ ixNet add $handle interface ]
		ixNet setA $interface -enabled True
		ixNet commit
		set interface [ ixNet remapIds $interface ]
		ixNet setA $interface -protocolInterface $protocol_interface
		ixNet commit		
	}
	
	method establish_lsp { args } {}
	method teardown_lsp { args } {}
	method flapping_lsp { args } {}
    method config { args } {}
	method get_status {} {}
	method get_stats {} {}
}

body LdpSession::config { args } {

    global errorInfo
    global errNumber
    set tag "body LdpSession::config [info script]"
Deputs "----- TAG: $tag -----"
	
#param collection
Deputs "Args:$args "
	
    foreach { key value } $args {
        set key [string tolower $key]
        switch -exact -- $key {
            -router_id {
				set router_id $value
			}
			-egress_label {	
# -- unsupported yet
				set egress_label $value
			}
			-hello_interval {
# -- unsupported yet
				set hello_interval $value
			}
			-bfd {
# -- unsupported yet
				set bfd $value
			}
			-enable_graceful_restart {
				set enable_graceful_restart $value
			}
			-hello_type  {
# -- unsupported yet
				set hello_type  $value
			}
			-label_min {
# -- unsupported yet
				set label_min $value
			}
			-keep_alive_interval  {
# -- unsupported yet
				set keep_alive_interval  $value
			}
			-reconnect_time {
				set reconnect_time  $value
			}
			-recovery_time {
				set recovery_time  $value
			}
			-transport_tlv_mode {
				set transport_tlv_mode  $value
			}
			-lsp_type {
				set lsp_type  $value
			}
			-label_advertise_mode {
				set label_advertise_mode  $value
			}
			-ipv4_addr {
				set ipv4_addr $value
			}
			-ipv4_prefix_len {
				set ipv4_prefix_len $value
			}
			-ipv4_gw -
			-dut_ip {
				set ipv4_gw $value
			}
			-lsp_type {
# -- unsupported yet
				set lsp_type $value
			}
			-label_advertise_mode {
				set label_advertise_mode $value
			}
            default {
                error "$errNumber(3) key:$key value:$value"
            }
		}
    }

	ixNet setM $handle -enabled True
	if { [ info exists router_id ] } {
		ixNet setA $handle -routerId $router_id
		ixNet commit
	}
	if { [ info exists enable_graceful_restart ] } {
		ixNet setA $handle -enableGracefulRestart $router_id
		ixNet commit
	}
	if { [ info exists ipv4_addr ] } {
		ixNet setA $protocol_interface/ipv4 -ip  $ipv4_addr
		ixNet commit
	}
	if { [ info exists ipv4_prefix_len ] } {
		ixNet setA $protocol_interface/ipv4 -maskWidth  $ipv4_prefix_len
		ixNet commit
	}
	if { [ info exists ipv4_gw ] } {
		ixNet setA $protocol_interface/ipv4 -gateway  $ipv4_gw
		ixNet commit
	}
	
	if { [ info exists reconnect_time ] } {
		ixNet setA $handle -reconnectTime  $reconnect_time
		ixNet commit
	}
	if { [ info exists recovery_time ] } {
		ixNet setA $handle -recoveryTime  $recovery_time
		ixNet commit
	}
	if { [ info exists label_advertise_mode ] } {
		set label_advertise_mode [ string tolower $label_advertise_mode ]
		switch $label_advertise_mode {
			du {
				set label_advertise_mode unsolicited
			}
			dod {
				set label_advertise_mode onDemand
			}
		}
		ixNet setA $interface -advertisingMode  $label_advertise_mode
		ixNet commit
	}
	
	if { [ info exists transport_tlv_mode ] } {
		set transport_tlv_mode [ string toupper $transport_tlv_mode ]
		switch $transport_tlv_mode {
			TRANSPORT_TLV_MODE_NONE {
				ixNet setA $handle -useTransportAddress False
			}
			TRANSPORT_TLV_MODE_TESTER_IP {
				ixNet setA $handle -useTransportAddress True
				ixNet setA $handle -transportAddress $protocol_interface
			}
			TRANSPORT_TLV_MODE_ROUTER_ID {
				ixNet setA $handle -useTransportAddress True
				set routerId [ ixNet getA $handle -routerId ]
				routerIdInt [ ixNet add $hPort interface ]
				ixNet setA $routerIdInt/ipv4 -ip $routerId
				ixNet commit
				set routerIdInt [ ixNet remapIds $routerIdInt ]
				ixNEt setA $handle -transportAddress $routerIdInt
			}
		}
		ixNet commit
	}
	
    return [GetStandardReturnHeader]	
	
}

body LdpSession::establish_lsp { args } {
    global errorInfo
    global errNumber
    set tag "body LdpSession::establish_lsp [info script]"
Deputs "----- TAG: $tag -----"
	
#param collection
Deputs "Args:$args "
	
    foreach { key value } $args {
        set key [string tolower $key]
        switch -exact -- $key {
			-lsp {
				set lsp $value
			}
            default {
                error "$errNumber(3) key:$key value:$value"
            }
		}
    }
	
	if { [ $lsp isa LdpLsp ] } {
		$lsp establish_lsp
	} else {
		return [ GetErrorReturnHeader "Bad LSP object... $lsp" ]
	}
	
	return [GetStandardReturnHeader]	

}

body LdpSession::teardown_lsp { args } {
    global errorInfo
    global errNumber
    set tag "body LdpSession::teardown_lsp [info script]"
Deputs "----- TAG: $tag -----"
	
#param collection
Deputs "Args:$args "
	
    foreach { key value } $args {
        set key [string tolower $key]
        switch -exact -- $key {
			-lsp {
				set lsp $value
			}
            default {
                error "$errNumber(3) key:$key value:$value"
            }
		}
    }
	
	if { [ $lsp isa LdpLsp ] } {
		$lsp teardown_lsp
	} else {
		return [ GetErrorReturnHeader "Bad LSP object... $lsp" ]
	}
	
	return [GetStandardReturnHeader]	

}

body LdpSession::flapping_lsp { args } {
    global errorInfo
    global errNumber
    set tag "body LdpSession::flapping_lsp [info script]"
Deputs "----- TAG: $tag -----"
	
#param collection
Deputs "Args:$args "
	
    foreach { key value } $args {
        set key [string tolower $key]
        switch -exact -- $key {
			-lsp {
				set lsp $value
			}
			-flap_times -
			-flap_interval {
			}
            default {
                error "$errNumber(3) key:$key value:$value"
            }
		}
    }
	
	if { [ $lsp isa LdpLsp ] } {
		eval $lsp flapping_lsp $args
	} else {
		return [ GetErrorReturnHeader "Bad LSP object... $lsp" ]
	}
	
	return [GetStandardReturnHeader]	

}

class LdpLsp {
	inherit NetObject
	
	public variable type

	method config { args } {}
	method establish_lsp {} {}
	method teardown_lsp {} {}
	method flapping_lsp { args } {}
	
}

body LdpLsp::establish_lsp {} {
	set tag "body LdpLsp::establish_lsp [info script]"
Deputs "----- TAG: $tag -----"
	ixNet setA $handle -enabled True
	ixNet commit
}

body LdpLsp::teardown_lsp {} {
	set tag "body LdpLsp::teardown_lsp [info script]"
Deputs "----- TAG: $tag -----"
	ixNet setA $handle -enabled False
	ixNet commit
}

body LdpLsp::flapping_lsp { args } {
    global errorInfo
    global errNumber
    set tag "body LdpLsp::flapping_lsp [info script]"
Deputs "----- TAG: $tag -----"
	
#param collection
Deputs "Args:$args "
    foreach { key value } $args {
        set key [string tolower $key]
        switch -exact -- $key {
			-flap_times {
				set flap_times $value
			}
			-flap_interval {
				set flap_interval $value
			}
            default {
                error "$errNumber(3) key:$key value:$value"
            }
		}
    }
	
	for { set index 0 } { $index < $flap_times } { incr index } {
		teardown_lsp
		after [ expr $flap_interval * 1000 ]
		establish_lsp
		after [ expr $flap_interval * 1000 ]
	}
	return [GetStandardReturnHeader]	
}

class Ipv4PrefixLsp {

	inherit LdpLsp
	
	constructor { ldp } {
		global errNumber
		
		set tag "body Ipv4PrefixLsp::ctor [info script]"
Deputs "----- TAG: $tag -----"
		
		set range [ ixNet add $ldp advFecRange ]
		ixNet setA $range -enabled True
		ixNet commit
		set handle [ ixNet remapIds $range ]
	}
	
	method config { args } {}
}

body Ipv4PrefixLsp::config { args } {

    global errorInfo
    global errNumber
    set tag "body Ipv4PrefixLsp::config [info script]"
Deputs "----- TAG: $tag -----"
	
#param collection
Deputs "Args:$args "
	
    foreach { key value } $args {
        set key [string tolower $key]
        switch -exact -- $key {
			-route_block {
				set route_block $value
			}
			-fec_type {
				set fec_type $value
			}
			-assinged_label {
				set assinged_label $value
			}
            default {
                error "$errNumber(3) key:$key value:$value"
            }
		}
    }
	
	if { [ info exists route_block ] } {
		if { [ $route_block isa RouteBlock ] } {
			set num [ $route_block cget -num ]
			set start [ $route_block cget -start ]
			set step [ $route_block cget -step ]
			set prefix_len [ $route_block cget -prefix_len ]
		} else {
			return [ GetErrorReturnHeader "Bad RouteBlock obj... $route_block" ]			
		}
	} else {
		return [ GetErrorReturnHeader "Missing madatory parameter... -route_block" ]
	}
	
	if { [ info exists fec_type ] } {
		set fec_type [ string toupper $fec_type ] 
		switch $fec_type {
			LDP_FEC_TYPE_PREFIX {
				ixNet setA $handle -maskWidth $prefix_len
			}
			LDP_FEC_TYPE_HOST_ADDR {
				ixNet setA $handle -maskWidth 32
			}
		}
		ixNet commit
	}
	
	if { [ info exists num ]  } {
		ixNet setA $handle -numberOfNetworks $num
		ixNet commit
	}
	
	if { [ info exists start ] } {
		ixNet setA $handle -firstNetwork $start
		ixNet commit
	}
	
	if { [ info exists assinged_label ] } {
		ixNet setA $handle -labelValueStart $assinged_label
		ixNet commit
	}

	return [GetStandardReturnHeader]	

}

class VcLsp {

	inherit LdpLsp
	public variable vcRange
	
	constructor { ldp } {
		global errNumber
		
		set tag "body VcLsp::ctor [info script]"
Deputs "----- TAG: $tag -----"
		
		set range [ ixNet add $ldp l2Interface ]
		ixNet setA $range -enabled True
		ixNet commit
		set handle [ ixNet remapIds $range ]
		
		set range [ ixNet add $handle l2VcRange ]
		ixNet setA $range -enabled True
		ixNet commit
		set vcRange [ ixNet remapIds $range ]
	}
	method config { args } {}
}

body VcLsp::config { args } {

    global errorInfo
    global errNumber
    set tag "body VcLsp::config [info script]"
Deputs "----- TAG: $tag -----"
	
#param collection
Deputs "Args:$args "
	
    foreach { key value } $args {
        set key [string tolower $key]
        switch -exact -- $key {
			-encap {
				set encap $value
			}
			-group_id {
				set group_id $value
			}
			-if_mtu {
				set if_mtu $value
			}
			-mac_start {
				set mac_start $value
			}
			-mac_step  {
# -- unsupported yet
			set mac_step  $value
			}
			-mac_num  {
# -- unsupported yet
				set mac_num  $value
			}
			-vc_id_start {
				set vc_id_start $value
			}
			-vc_id_step   {
				set vc_id_step   $value
			}
			-vc_id_count   {
				set vc_id_count   $value
			}
			-requested_vlan_id_start  {
				set requested_vlan_id_start  $value
			}
			-requested_vlan_id_step    {
				set requested_vlan_id_step    $value
			}
			-requested_vlan_id_count    {
				set requested_vlan_id_count   $value
			}
			-assinged_label     {
				set assinged_label   $value
			}
            default {
                error "$errNumber(3) key:$key value:$value"
            }
		}
    }
	
	if { [ info exists encap ] } {
		set encap [ string toupper $encap ]
		switch $encap {
			LDP_LSP_ENCAP_FRAME_RELAY_DLCI {
				set ixencap frameRelay
			}
			LDP_LSP_ENCAP_ATM_AAL5_VCC {
				set ixencap atmaal5
			}
			LDP_LSP_ENCAP_ATM_TRANSPARENT_CELL {
				set ixencap atmxCell
			}
			LDP_LSP_ENCAP_ETHERNET_VLAN {
				set ixencap vlan
			}
			LDP_LSP_ENCAP_ETHERNET {
				set ixencap ethernet
			}
			LDP_LSP_ENCAP_HDLC {
				set ixencap hdlc
			}
			LDP_LSP_ENCAP_PPPoE {
				set ixencap ppp
			}
			LDP_LSP_ENCAP_CEM {
				set ixencap cem
			}
			LDP_LSP_ENCAP_ATM_VCC {
				set ixencap atmvcc
			}
			LDP_LSP_ENCAP_ATM_VPC {
				set ixencap atmvpc
			}
			LDP_LSP_ENCAP_ETHERNET_VPLS {
				set ixencap ethernet
			}
		}
		ixNet setA $handle -type $ixencap
		ixNet commit
		if { $encap == "LDP_LSP_ENCAP_ETHERNET_VPLS" } {
			ixNet setA $vcRange -fecType generalizedIdFecVpls
			ixNet commit
		}
	}

	if { [ info exists group_id ] } {
		ixNet setA $handle -groupId $group_id
		ixNet commit
	}
	
	if { [ info exists if_mtu ] } {
		ixNet setA $vcRange -mtu $if_mtu
		ixNet commit
	}
	
	if { [ info exists vc_id_start ] } {
		ixNet setA $vcRange -vcId $vc_id_start
		ixNet commit
	}
	
	if { [ info exists vc_id_step ] } {
		ixNet setA $vcRange -vcIdStep $vc_id_step
		ixNet commit
	}
	
	if { [ info exists vc_id_count ] } {
		ixNet setA $vcRange -count $vc_id_count
		ixNet commit
	}
	
	if { [ info exists mac_start ] } {
		ixNet setM $vcRange/l2MacVlanRange \
			-startMac $mac_start \
			-enabled True
		ixNet commit
	}
	
	if { [ info exists requested_vlan_id_start ] } {
		ixNet setA $vcRange/l2MacVlanRange -firstVlanId $requested_vlan_id_start
		ixNet commit
	}
	
	if { [ info exists requested_vlan_id_count ] } {
		ixNet setA $vcRange/l2MacVlanRange -vlanCount $requested_vlan_id_count
		ixNet commit
	}
	
	if { [ info exists assinged_label ] } {
		ixNet setA $vcRange -labelStart $assinged_label
		ixNet commit
	}
	
	return [GetStandardReturnHeader]	
}



