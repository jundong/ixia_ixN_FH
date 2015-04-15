
# Copyright (c) Ixia technologies 2010-2011, Inc.

# Release Version 1.1
#===============================================================================
# Change made
# Version 1.0 
#       1. Create

class IsisSession {
    inherit RouterEmulationObject
		
    constructor { port { pHandle null } } {}
    method reborn {} {}
    method config { args } {}
    method get_fh_stats {} {}
	method advertise_route { args } {}
	method withdraw_route { args } {}

	public variable mac_addr
}

body IsisSession::reborn {} {
    set tag "body IsisSession::reborn [info script]"
    Deputs "----- TAG: $tag -----"
	#-- add isis protocol
Deputs "hPort:$hPort"
	set handle [ ixNet add $hPort/protocols/isis router ]
	ixNet setA $handle -name $this
	ixNet commit
	set handle [ ixNet remapIds $handle ]
Deputs "handle:$handle"

	#-- add router interface
	set intList [ ixNet getL $hPort interface ]
	if { [ llength $intList ] } {
		set interface [ lindex $intList 0 ]
	} else {
		set interface [ ixNet add $hPort interface ]
		ixNet setA $interface -enabled True
		ixNet commit
		set interface [ ixNet remapIds $interface ]
	Deputs "port interface:$interface"
	}
	ixNet setA $hPort/protocols/isis -enabled True
	ixNet setA $handle -enabled True
	ixNet commit
	#-- add vlan
	set vlan [ ixNet add $interface vlan ]
	ixNet commit
	
	#-- port/protocols/isis/router/interface
	set rb_interface  [ ixNet add $handle interface ]
	ixNet setM $rb_interface \
	    -interfaceId $interface \
	    -enableConnectedToDut True \
	    -enabled True
	ixNet commit
	set rb_interface [ ixNet remapIds $rb_interface ]
Deputs "rb_interface:$rb_interface"    
}

body IsisSession::constructor { port { pHandle null } } {
    set tag "body IsisSession::constructor [info script]"
    Deputs "----- TAG: $tag -----"
	
    global errNumber
    
    #-- enable protocol
    set portObj [ GetObject $port ]
Deputs "port:$portObj"
    if { [ catch {
	    set hPort   [ $portObj cget -handle ]
Deputs "port handle: $hPort"
    } ] } {
	    error "$errNumber(1) Port Object in IsisSession ctor"
    }
Deputs "initial port..."
    if { $pHandle != "null" } {
        set handle $pHandle
        set rb_interface  [ ixNet getL $handle interface ]
    } else {
	    reborn
    }
Deputs "Step10"
}

body IsisSession::config { args } {
    set tag "body IsisSession::config [info script]"
Deputs "----- TAG: $tag -----"
	
	set sys_id "64:01:00:01:00:00"
# in case the handle was removed
    if { $handle == "" } {
	    reborn
    }
	
    Deputs "Args:$args "
    foreach { key value } $args {
		set key [string tolower $key]
		switch -exact -- $key {
			-sys_id - 
			-system_id {
				set sys_id $value
			}
			-network_type {
				set value [string tolower $value]
					switch $value {
					p2p {
						set value pointToPoint
					}
					p2mp {
						set value pointToMultipoint
					}
					default {
						set value broadcast
					}
				}
				set network_type $value
			}
            -discard_lsp {
            	set discard_lsp $value
            }
            -interface_metric -
            -metric {
            	set metric $value
            }
            -hello_interval {
            	set hello_interval $value  	    	
            }
            -dead_interval {
            	set dead_interval $value  	    	
            }
            -vlan_id {
            	set vlan_id $value
            }
			-level_type {
            	set level_type $value
            }
            -lsp_refreshtime {
            	set lsp_refreshtime $value
            }
            -lsp_lifetime {
            	set lsp_lifetime $value
            }
			-mac_addr {
                set value [ MacTrans $value ]
                if { [ IsMacAddress $value ] } {
                    set mac_addr $value
                } else {
Deputs "wrong mac addr: $value"
                    error "$errNumber(1) key:$key value:$value"
                }
				
			}
		}
    }
	
    if { [ info exists sys_id ] } {
		while { [ ixNet getF $hPort/protocols/isis router -systemId "[ split $sys_id : ]"  ] != "" } {
Deputs "sys_id: $sys_id"		
			set sys_id [ IncrMacAddr $sys_id "00:00:00:00:00:01" ]
		}
Deputs "sys_id: $sys_id"		
	    ixNet setA $handle -systemId $sys_id
    }
    if { [ info exists network_type ] } {
	    ixNet setA $rb_interface -networkType $network_type
    }
    if { [ info exists discard_lsp ] } {
    	ixNet setA $handle -enableDiscardLearnedLsps $discard_lsp
    }
	if { [ info exists level_type ] } {
    	ixNet setA $rb_interface -level $level_type
    }
	
    if { [ info exists metric ] } {
	    ixNet setA $rb_interface -metric $metric
    }
    if { [ info exists hello_interval ] } {
	    ixNet setA $rb_interface -level1HelloTime $hello_interval
    }
    if { [ info exists dead_interval ] } {
	    ixNet setA $rb_interface -level1DeadTime $dead_interval
    }
    if { [ info exists vlan_id ] } {
	    set vlan [ixNet getL $interface vlan]
	    ixNet setA $vlan -vlanId $vlan_id
    }
    if { [ info exists lsp_refreshtime ] } {
    	ixNet setA $handle -lspRefreshRate $lsp_refreshtime
    }
    if { [ info exists lsp_lifetime ] } {
    	ixNet setA $handle -lspLifeTime $lsp_lifetime
    } 
	if { [ info exists mac_addr ] } {
Deputs "interface:$interface mac_addr:$mac_addr"
		ixNet setA $interface/ethernet -macAddress $mac_addr
	}
    ixNet commit
}

#{Stat Name} {Port Name} {L2 Sess. Configured} {L2 Sess. Up} {L2 Init State Count} {L2 Full State Count} 
#{L2 Neighbors} {L2 Session Flap Count} {L2 DB Size} {L2 Hellos Rx} {L2 PTP Hellos Rx} {L2 LSP Rx} {L2 CSNP Rx} 
#{L2 PSNP Rx} {L2 Hellos Tx} {L2 PTP Hellos Tx} {L2 LSP Tx} {L2 CSNP Tx} {L2 PSNP Tx} {L1 Sess. Configured} 
#{L1 Sess. Up} {L1 Init State Count} {L1 Full State Count} {L1 Neighbors} {L1 Session Flap Count} {L1 DB Size}
# {L1 Hellos Rx} {L1 PTP Hellos Rx} {L1 LSP Rx} {L1 CSNP Rx} {L1 PSNP Rx} {L1 Hellos Tx} {L1 PTP Hellos Tx} {L1 LSP Tx} 
#{L1 CSNP Tx} {L1 PSNP Tx} {M-GROUP CSNPs Tx} {M-GROUP CSNPs Rx} {M-GROUP PSNPs Tx} {M-GROUP PSNPs Rx} {M-GROUP LSP Tx} 
#{M-GROUP LSP Rx} {Unicast MAC Group Record Tx} {Unicast MAC Group Record Rx} {Multicast MAC Group Record Tx} 
#{Multicast MAC Group Record Rx} {Multicast IPv4 Group Record Tx} {Multicast IPv4 Group Record Rx} {Multicast IPv6 Group Record Tx} 
#{Multicast IPv6 Group Record Rx} {RBChannel Frames Tx} {RBChannel Frames Rx} {RBChannel Echo Request Tx} {RBChannel Echo Request Rx} 
#{RBChannel Echo Reply Tx} {RBChannel Echo Reply Rx} {RBChannel Error Tx} {RBChannel Error Rx} {RBChannel ErrNotif Tx} {RBChannel ErrNotif Rx} 
#{RBridges Learned} {Unicast MAC Ranges Learned} {MAC Group Records Learned}
# {IPv4 Group Records Learned} {IPv6 Group Records Learned} {Rate Control Blocked Sending LSP/MGROUP}

body IsisSession::get_fh_stats {} {

    set tag "body IsisSession::get_fh_stats [info script]"
Deputs "----- TAG: $tag -----"


    set root [ixNet getRoot]
	set view {::ixNet::OBJ-/statistics/view:"ISIS Aggregated Statistics"}
    # set view  [ ixNet getF $root/statistics view -caption "Port Statistics" ]
Deputs "view:$view"
    set captionList             [ ixNet getA $view/page -columnCaptions ]
Deputs "caption list:$captionList"
	set port_name				[ lsearch -exact $captionList {Stat Name} ]
    set session_conf            [ lsearch -exact $captionList {Sess. Configured} ]
    set session_succ            [ lsearch -exact $captionList {Sess. Up} ]
    
    #set AdjacencyLevel          [ lsearch -exact $captionList {Sess. Up} ]
    set RxL1LspCount            [ lsearch -exact $captionList {L1 LSP Rx} ]
    set RxL2LspCount            [ lsearch -exact $captionList {L2 LSP Rx} ]
    set RxL1CsnpCount           [ lsearch -exact $captionList {L1 CSNP Rx} ]
    set RxL1LanHelloCount       [ lsearch -exact $captionList {L1 Hellos Rx} ]
    set RxL2CsnpCount           [ lsearch -exact $captionList {L2 CSNP Rx} ]
    set RxL2LanHelloCount       [ lsearch -exact $captionList {L2 Hellos Rx} ]
    set TxL1CsnpCount           [ lsearch -exact $captionList {L1 CSNP Tx} ]
    set TxL1LanHelloCount       [ lsearch -exact $captionList {L1 Hellos Tx} ]
    set TxL1LspCount            [ lsearch -exact $captionList {L1 LSP Tx} ]                  
    set TxL2CsnpCount           [ lsearch -exact $captionList {L2 CSNP Tx} ]
    set TxL2LanHelloCount       [ lsearch -exact $captionList {L2 Hellos Tx} ]
    set TxL2LspCount            [ lsearch -exact $captionList {L2 LSP Tx} ]
    set TxPtpHelloCount         [ lsearch -exact $captionList {L2 PTP Hellos Tx} ]
	
    set ret ""
	
    set stats [ ixNet getA $view/page -rowValues ]
Deputs "stats:$stats"

    set connectionInfo [ ixNet getA $hPort -connectionInfo ]
Deputs "connectionInfo :$connectionInfo"
    regexp -nocase {chassis=\"([0-9\.]+)\" card=\"([0-9\.]+)\" port=\"([0-9\.]+)\"} $connectionInfo match chassis card port
Deputs "chas:$chassis card:$card port$port"

    foreach row $stats {
        
        eval {set row} $row
Deputs "row:$row"
Deputs "portname:[ lindex $row $port_name ]"
		if { [ string length $card ] == 1 } {
			set card "0$card"
		}
		if { [ string length $port ] == 1 } {
			set port "0$port"
		}
		if { "${chassis}/Card${card}/Port${port}" != [ lindex $row $port_name ] } {
			continue
		}

        set statsItem   "RxL1LspCount"
        set statsVal    [ lindex $row $RxL1LspCount ]
Deputs "stats val:$statsVal"
        set ret "$ret$statsItem $statsVal "
          
              
        set statsItem   "RxL2LspCount"
        set statsVal    [ lindex $row $RxL2LspCount ]
Deputs "stats val:$statsVal"
        set ret "$ret$statsItem $statsVal "
        
        set statsItem   "RxL1CsnpCount"
        set statsVal    [ lindex $row $RxL1CsnpCount ]
Deputs "stats val:$statsVal"
        set ret "$ret$statsItem $statsVal "
          
              
        set statsItem   "RxL1LanHelloCount"
        set statsVal    [ lindex $row $RxL1LanHelloCount ]
Deputs "stats val:$statsVal"
        set ret "$ret$statsItem $statsVal "
       
       set statsItem   "RxL2CsnpCount"
        set statsVal    [ lindex $row $RxL2CsnpCount ]
Deputs "stats val:$statsVal"
        set ret "$ret$statsItem $statsVal "
          
              
        set statsItem   "RxL2LanHelloCount"
        set statsVal    [ lindex $row $RxL2LanHelloCount ]
Deputs "stats val:$statsVal"
        set ret "$ret$statsItem $statsVal "
        
        set statsItem   "TxL1CsnpCount"
        set statsVal    [ lindex $row $TxL1CsnpCount ]
Deputs "stats val:$statsVal"
        set ret "$ret$statsItem $statsVal "
          
              
        set statsItem   "TxL1LanHelloCount"
        set statsVal    [ lindex $row $TxL1LanHelloCount ]
Deputs "stats val:$statsVal"
        set ret "$ret$statsItem $statsVal "
        
        set statsItem   "TxL1LspCount"
        set statsVal    [ lindex $row $TxL1LspCount ]
Deputs "stats val:$statsVal"
        set ret "$ret$statsItem $statsVal "
          
              
        set statsItem   "TxL2CsnpCount"
        set statsVal    [ lindex $row $TxL2CsnpCount ]
Deputs "stats val:$statsVal"
        set ret "$ret$statsItem $statsVal "
        
        set statsItem   "TxL2LanHelloCount"
        set statsVal    [ lindex $row $TxL2LanHelloCount ]
Deputs "stats val:$statsVal"
        set ret "$ret$statsItem $statsVal "
          
              
        set statsItem   "TxL2LspCount"
        set statsVal    [ lindex $row $TxL2LspCount ]
Deputs "stats val:$statsVal"
        set ret "$ret$statsItem $statsVal "
        
        set statsItem   "TxL1CsnpCount"
        set statsVal    [ lindex $row $TxL1CsnpCount ]
Deputs "stats val:$statsVal"
        set ret "$ret$statsItem $statsVal "
          
              
        set statsItem   "TxPtpHelloCount"
        set statsVal    [ lindex $row $TxPtpHelloCount ]
Deputs "stats val:$statsVal"
        set ret "$ret$statsItem $statsVal "
			  

Deputs "ret:$ret"

    }
        
    return $ret

	
}

body IsisSession::advertise_route { args } {
    global errorInfo
    global errNumber
    set tag "body IsisSession::advertise_route [info script]"
Deputs "----- TAG: $tag -----"

#param collection
Deputs "Args:$args "
    foreach { key value } $args {
        set key [string tolower $key]
        switch -exact -- $key {
            -route_block {
            	set route_block $value
            }
        }
    }
	
	if { [ info exists route_block ] } {
		ixNet setA $routeBlock($route_block,handle) \
			-enabled True
	} else {
		foreach hRouteBlock $routeBlock(obj) {
Deputs "hRouteBlock : $hRouteBlock"		
			ixNet setA $routeBlock($hRouteBlock,handle) -enabled True
		}
	}
	ixNet commit
	return [GetStandardReturnHeader]

}

body IsisSession::withdraw_route { args } {
    global errorInfo
    global errNumber
    set tag "body IsisSession::config [info script]"
Deputs "----- TAG: $tag -----"

#param collection
Deputs "Args:$args "
    foreach { key value } $args {
        set key [string tolower $key]
        switch -exact -- $key {
            -route_block {
            	set route_block $value
            }
        }
    }
	
	if { [ info exists route_block ] } {
		ixNet setA $routeBlock($route_block,handle) \
			enabled False
	} else {
		foreach hRouteBlock $routeBlock(obj) {
			ixNet setA $hRouteBlock -enabled False
		}
	}
	ixNet commit
	return [GetStandardReturnHeader]

}


