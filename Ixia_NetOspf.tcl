
# Copyright (c) Ixia technologies 2010-2011, Inc.

# Release Version 1.0
#===============================================================================
# Change made
# Version 1.0 
#       1. Create
#       2. Update

class OspfSession {
    inherit RouterEmulationObject
	public variable hNetworkRange
    
	constructor { port { pHandle null } { hInterface null } } {
		global errNumber
		set tag "body OspfSession::ctor [info script]"
        Deputs "----- TAG: $tag -----"
        
        set handle ""
        set rb_interface ""
        set routeBlock(obj) [ list ]
        set protocolhandle ""
        
		set portObj [ GetObject $port ]
		if { [ catch {
			set hPort   [ $portObj cget -handle ]
		} ] } {
			error "$errNumber(1) Port Object in DhcpHost ctor"
		}
        
		#-- add ospf protocol
        if { $pHandle != "null"  } {
            set handle $pHandle
			set hInt_List [ ixNet getL $handle interface ]
            foreach hInt $hInt_List {
			    set int [ixNet getA $hInt -interfaces ]
			    set interface($int) $hInt	
		    }
        }
        if { $hInterface != "null" } {
            set rb_interface $hInterface
        }
        reborn
	}    
	method reborn {} {
		set tag "body OspfSession::reborn [info script]"
		Deputs "----- TAG: $tag -----"
		
		ixNet setM $hPort/protocols/ospf -enableDrOrBdr True
		ixNet setM $hPort/protocols/ospfV3 -enableDrOrBdr True
		ixNet commit
		
        if { $rb_interface == "" } {
            set rb_interface [ ixNet getL $hPort interface ]
            Deputs "rb_interface is: $rb_interface"
        }
		
	}
    method config { args } {}
	method set_route { args } {}
	method set_topo { args } {}
	method unset_topo { args } {}
	method advertise_topo {} {}
	method withdraw_topo {} {}
	method flapping_topo { args } {}
	method enable {} {}
	method disable {} {}
	method get_status {} {}
	method get_stats {} {}
	method generate_interface { args } {
		set tag "body OspfSession::generate_interface [info script]"
        Deputs "----- TAG: $tag -----"
		foreach int $rb_interface {
			if { [ $this isa Ospfv2Session ] } {
                if { [ llength [ ixNet getL $int ipv4 ] ] == 0 } {
                    continue
                }
			} elseif { [ $this isa Ospfv3Session ] } {
                if { [ llength [ ixNet getL $int ipv6 ] ] == 0 } {
                    continue
                }
            }  
			set hInt [ ixNet add $handle interface ]
			ixNet setM $hInt -interfaces $int -enabled True -connectedToDut True
			ixNet commit
			set hInt [ ixNet remapIds $hInt ]
			set interface($int) $hInt	
		}
	}	
}

class Ospfv2Session {
	inherit OspfSession

    constructor { port { pHandle null }  { hInterface null } } { chain $port $pHandle $hInterface } {
		set tag "body Ospfv2Session::ctor [info script]"
        Deputs "----- TAG: $tag -----"
        
        # Enable ospfv2
		ixNet setA $hPort/protocols/ospf -enabled True
		ixNet commit
        set protocolhandle $hPort/protocols/ospf
		#-- add ospf protocol
        if { $handle == ""  } {
            set handle [ ixNet add $hPort/protocols/ospf router ]
            ixNet setA $handle -Enabled True
            ixNet commit
            set handle [ ixNet remapIds $handle ]
            
            ixNet setA $handle -name $this
            
            generate_interface
        }
        set protocol ospf
    }
	
	method get_status {} {}
    method config { args } {}
	method get_stats {} {}
    method get_fh_stats {} {}
}

class Ospfv3Session {
	inherit OspfSession
	
    constructor { port { pHandle null }  { hInterface null } } { chain $port $pHandle $hInterface } {
		set tag "body Ospfv3Session::ctor [info script]"
        Deputs "----- TAG: $tag -----"
	    
        ixNet setM $hPort/protocols/ospfV3 -enabled True
        ixNet commit 
	    set protocolhandle $hPort/protocols/ospfV3
		#-- add ospf protocol
        if { $handle == ""  } {
            set handle [ ixNet add $hPort/protocols/ospfV3 router ]
            ixNet setA $handle -Enabled True
            ixNet commit
            set handle [ ixNet remapIds $handle ]
            ixNet setA $handle -name $this
            
            generate_interface
        }
        set protocol ospfV3
    }

	method config { agrs } {}
	method get_status {} {}
	method get_stats {} {}
}

class SimulatedSummaryRoute {
	inherit NetObject
	
    constructor { router } {
		global errNumber
	    
		set tag "body SimulatedSummaryRoute::ctor [info script]"
        Deputs "----- TAG: $tag -----"

		set routerObj [ GetObject $router ]
		if { [ catch {
			set hRouter   [ $routerObj cget -handle ]
		} ] } {
			error "$errNumber(1) Router Object in SimulatedSummaryRoute ctor"
		}
		
		set hRouteRange [ixNet add $hRouter routeRange]
		ixNet commit
		
		set handle [ ixNet remapIds $hRouteRange ]
		ixNet setA $handle -enalbed True
		ixNet commit
		
		set trafficObj $handle
	}
		
	method config { args } {}
	
}

class SimulatedInterAreaRoute {
	inherit NetObject
	
    constructor { router } {
		global errNumber
	    
		set tag "body SimulatedSummaryRoute::ctor [info script]"
        Deputs "----- TAG: $tag -----"

		set routerObj [ GetObject $router ]
		if { [ catch {
			set hRouter   [ $routerObj cget -handle ]
		} ] } {
			error "$errNumber(1) Router Object in SimulatedSummaryRoute ctor"
		}
		
		set hRouteRange [ixNet add $hRouter routeRange]
		ixNet commit
		
		set handle [ ixNet remapIds $hRouteRange ]
		ixNet setA $handle -enalbed True
		ixNet commit
		
		set trafficObj $handle
	}
	
	
	method config { args } {}
	
}

class SimulatedLink {
	inherit NetObject
	
    constructor { router } {
		global errNumber
	    
		set tag "body SimulatedSummaryRoute::ctor [info script]"
        Deputs "----- TAG: $tag -----"

		set routerObj [ GetObject $router ]
		if { [ catch {
			set hRouter   [ $routerObj cget -handle ]
		} ] } {
			error "$errNumber(1) Router Object in SimulatedSummaryRoute ctor"
		}
		
		set hRouteRange [ixNet add $hRouter routeRange]
		ixNet commit
		
		set handle [ ixNet remapIds $hRouteRange ]
		ixNet setA $handle -enalbed True
		ixNet commit
		
		set trafficObj $handle
	}
	method config { args } {}
}

class SimulatedRouter {
	inherit NetObject

	public variable hUserlsagroup
	public variable hUserlsa
    constructor { router } {
		global errNumber
	    
		set tag "body SimulatedSummaryRoute::ctor [info script]"
        Deputs "----- TAG: $tag -----"

		set routerObj [ GetObject $router ]
		if { [ catch {
			set hRouter   [ $routerObj cget -handle ]
		} ] } {
			error "$errNumber(1) Router Object in SimulatedSummaryRoute ctor"
		}
        Deputs "hRouter is: $hRouter"
		set hUserlsagroup [ixNet add $hRouter userLsaGroup]
		ixNet commit
		
		set hUserlsagroup [ ixNet remapIds $hUserlsagroup ]
		ixNet setA $hUserlsagroup -enalbed True
		ixNet commit
	    
	    set hUserlsa [ixNet add $hUserlsagroup userLsa]
	    ixNet commit
	    
	    set hUserlsa [ ixNet remapIds $hUserlsa ]
	    ixNet setA $hUserlsa -enalbed True
	    ixNet commit
		
		set trafficObj $hUserlsa
	}
	method config { args } {}
}

class SimulatedNssaRoute {
	inherit NetObject
	
    constructor { router } {
		global errNumber
	    
		set tag "body SimulatedSummaryRoute::ctor [info script]"
        Deputs "----- TAG: $tag -----"

		set routerObj [ GetObject $router ]
		if { [ catch {
			set hRouter   [ $routerObj cget -handle ]
		} ] } {
			error "$errNumber(1) Router Object in SimulatedSummaryRoute ctor"
		}
		
		set hRouteRange [ixNet add $hRouter routeRange]
		ixNet commit
		
		set handle [ ixNet remapIds $hRouteRange ]
		ixNet setA $handle -enalbed True
		ixNet commit
		
		set trafficObj $handle
	}
	method config { args } {}
}

class SimulatedExternalRoute {
	inherit NetObject
	
    constructor { router } {
		global errNumber
	    
		set tag "body SimulatedSummaryRoute::ctor [info script]"
        Deputs "----- TAG: $tag -----"

		set routerObj [ GetObject $router ]
		if { [ catch {
			set hRouter   [ $routerObj cget -handle ]
		} ] } {
			error "$errNumber(1) Router Object in SimulatedSummaryRoute ctor"
		}
		
		set hRouteRange [ixNet add $hRouter routeRange]
		ixNet commit
		
		set handle [ ixNet remapIds $hRouteRange ]
		ixNet setA $handle -enalbed True
		ixNet commit
		
		set trafficObj $handle
	}
	method config { args } {}
}

class SimulatedLinkRoute {
	inherit NetObject
	
    constructor { router } {
		global errNumber
	    
		set tag "body SimulatedSummaryRoute::ctor [info script]"
        Deputs "----- TAG: $tag -----"

		set routerObj [ GetObject $router ]
		if { [ catch {
			set hRouter   [ $routerObj cget -handle ]
		} ] } {
			error "$errNumber(1) Router Object in SimulatedSummaryRoute ctor"
		}
		
		set hRouteRange [ixNet add $hRouter routeRange]
		ixNet commit
		
		set handle [ ixNet remapIds $hRouteRange ]
		ixNet setA $handle -enalbed True
		ixNet commit
		
		set trafficObj $handle
	}
	method config { args } {}
}

class SimulatedIntraAreaRoute {
	inherit NetObject
	
    constructor { router } {
		global errNumber
	    
		set tag "body SimulatedSummaryRoute::ctor [info script]"
        Deputs "----- TAG: $tag -----"

		set routerObj [ GetObject $router ]
		if { [ catch {
			set hRouter   [ $routerObj cget -handle ]
		} ] } {
			error "$errNumber(1) Router Object in SimulatedSummaryRoute ctor"
		}
		
		set hRouteRange [ixNet add $hRouter routeRange]
		ixNet commit
		
		set handle [ ixNet remapIds $hRouteRange ]
		ixNet setA $handle -enalbed True
		ixNet commit
		
		set trafficObj $handle
	}
	method config { args } {}
}

body OspfSession::config { args } {
    global errorInfo
    global errNumber
                      
    set tag "body OspfSession::config [info script]"
    Deputs "----- TAG: $tag -----"
       
    #param collection
    Deputs "Args:$args "
    foreach { key value } $args {
        set key [string tolower $key]
        switch -exact -- $key {
			-ospf_id -
            -router_id {
				set router_id $value
			}
			-area_id {			
				set area_id $value
			}
			-hello_interval {
				set hello_interval $value
			}
			-if_cost {
				set if_cost $value
			}
			-instance_id {
				set instance_id $value
			}
			-network_type {
				set value [string toupper $value]
                switch $value {
                    P2MP -
                    NATIVE {
                        set network_type pointToMultipoint
                    }
                    BROADCAST {
                        set network_type broadcast
                    }
                    P2P {
                        set network_type pointToPoint
                    }
                    default {
                        error "$errNumber(1) key:$key value:$value, valid value are: broadcast or p2p"
                    }
                }
			}
			-options {
				set options $value
			}
		    -option {
				set option $value
			}
		    -router_dead_interval -
			-dead_interval {
				set dead_interval $value
			}
			-retransmit_interval {
				set retransmit_interval $value
			}
			-router_pri -
			-priority {
				set priority $value
			}
			-graceful_restart {
				set graceful_restart $value
			}
			-authentication {
				set authentication $value
			}
			-md5_keyid {
				set md5_keyid $value
			}
			-password {
				set password $value
			}
			-active {
				set active $value
			}
        }
    }
	ixNet setA $handle -enabled True
    Deputs "handle:$handle"
	if { [ info exists graceful_restart ] } {
        Deputs "graceful_restart:$graceful_restart"
		if { $graceful_restart } {
			ixNet setA $handle -gracefulRestart true
		} else {
			ixNet setA $handle -gracefulRestart false
		}
		ixNet commit
	}

	if { [ info exists router_id ] } {
        Deputs "router_id:$router_id"
		ixNet setA $handle -routerId $router_id
		ixNet commit
	}

	if { [ info exists area_id ] } {
        Deputs "area_id:$area_id"
		set id_hex [IP2Hex $area_id]			
		set area_id [format %i 0x$id_hex]
		set intf [ixNet getL $handle interface]
        if { $protocol == "ospf" } {
            ixNet setA $intf -areaId $area_id
        } else {
            ixNet setA $intf -area $area_id
        }
		ixNet commit
	}

	if { [ info exists hello_interval ] } {
        Deputs "hello_interval:$hello_interval"
		set intf [ixNet getL $handle interface]
		ixNet setA $intf -helloInterval $hello_interval	
		ixNet commit
	}

	if { [ info exists instance_id ] } {
        Deputs "instance_id:$instance_id"
		set intf [ixNet getL $handle interface]
		ixNet setA $intf -instanceId $instance_id
		ixNet commit
	}

	if { [ info exists if_cost ] } {
        Deputs "if_cost:$if_cost"
		set intf [ixNet getL $handle interface]
        if { $protocol == "ospf" } {
            ixNet setA $intf -metric $if_cost
        } else {
            ixNet setA $intf -linkMetric $if_cost
        }
		ixNet commit
	}

	# v3 -interfaceType pointToPoint, -interfaceType broadcast
	# v2 -networkType pointToPoint, -networkType broadcast, -networkType pointToMultipoint
	if { [ info exists network_type ] } {
        Deputs "network_type:$network_type"
		set intf [ixNet getL $handle interface]
        if { $protocol == "ospf"  } {
            ixNet setA $intf -networkType $network_type
        } else {
            ixNet setA $intf -interfaceType $network_type
        }
		ixNet commit
	}

	# v3 -routerOptions
	# v2 -options
	if { [ info exists options ] } {
        Deputs "options:$options"
		set options [split $options |]
		if {[string match *dcbit* $options]} {
		set dcbit 1
		} else {
			set dcbit 0
		}
		if {[string match *rbit* $options]} {
			set rbit 1
		} else {
			set rbit 0
		}
		if {[string match *nbit* $options]} {
			set nbit 1
		} else {
			set nbit 0
		}
		if {[string match *mcbit* $options]} {
			set mcbit 1
		} else {
			set mcbit 0
		}
		if {[string match *ebit* $options]} {
			set ebit 1
		} else {
			set ebit 0
		}
		if {[string match *v6bit* $options]} {
			set v6bit 1
		} else {
			set v6bit 0
		}
		set opt_val "00$dcbit$rbit$nbit$mcbit$ebit$v6bit"
		set opt_val [BinToDec $opt_val]
        #set opt_val [Int2Hex $opt_val]	
		set intf [ixNet getL $handle interface]
		ixNet setA $intf -routerOptions $opt_val
		ixNet commit
	}

	if { [ info exists dead_interval ] } {
        Deputs "dead_interval:$dead_interval"
		set intf [ixNet getL $handle interface]
		ixNet setA $intf -deadInterval $dead_interval
		ixNet commit
	}

	# v3 
	# v2 -lsaRetransmitTime
	if { [ info exists retransmit_interval ] } {
        Deputs "retransmit_interval:$retransmit_interval"
		set intf [ixNet getL $handle interface]
		ixNet setA $intf -lsaRetransmitTime $retransmit_interval
		ixNet commit
	}

	if { [ info exists priority ] } {
        Deputs "network_type:$network_type"
		set intf [ixNet getL $handle interface]
		ixNet setA $intf -priority $priority
		ixNet commit
	}

	if { [ info exists authentication ] } {
        Deputs "authentication:$authentication"
		set intf [ixNet getL $handle interface]
		if { $authentication == "md5" } {
			ixNet setA $intf -authenticationMethods md5
            if { [ info exists md5_keyid ] } {
                ixNet setA $intf -md5AuthenticationKeyId $md5_keyid
            }
            set pass [ixNet getA $intf -md5AuthenticationKey]
            if { $pass == "" } {
                if { [ info exists password ] } {
                    ixNet setA $intf -md5AuthenticationKey $password
                } else {
                    ixNet setA $intf -md5AuthenticationKey fiberhome
                }
            } else {
                if { [ info exists password ] } {
                    ixNet setA $intf -md5AuthenticationKey $password
                }
            }
        }

		if { $authentication == "simple" } {
            ixNet setA $intf -authenticationMethods password
            set pass [ixNet getA $intf -authenticationPassword]
            if { $pass == "" } {
                if { [ info exists password ] } {
                    ixNet setM $intf -authenticationPassword $password
                } else {
                    ixNet setA $intf -authenticationPassword fiberhome
                }
            } else {
                if { [ info exists password ] } {
                    ixNet setA $intf -authenticationPassword $password
                }
            }
        }

	}
	if { [ info exists option ] } {
		switch  $option {
			8 {
                if { $protocol == "ospf" } {
                    set opt 0
                } else {
                    set opt $option
                }
			}
            default {
                set opt $option
            }
		}

		set intf [ixNet getL $handle interface]
        if { $protocol == "ospf" } {
            ixNet setA $intf -options $opt
        } else {
            ixNet setA $intf -routerOptions $opt
        }
		ixNet commit
	}

	if { [ info exists active ] } {
		if { $active } {
			ixNet setA $handle -enabled true
		} else {
			ixNet setA $handle -enabled false
		} 
	}

	ixNet commit
    return [GetStandardReturnHeader]
}
body OspfSession::set_route { args } {
    global errorInfo
    global errNumber
    set tag "body OspfSession::set_route [info script]"
    Deputs "----- TAG: $tag -----"
    
    #param collection
    Deputs "Args:$args "
    foreach { key value } $args {
        set key [string tolower $key]
        switch -exact -- $key {
            -route_block {
            	set route_block $value
            }
            -type -
			-origin {
				set origin $value
			}
        }
    }
	
	if { [ info exists route_block ] } {
		foreach rb $route_block {
			set num 		[ $rb cget -num ]
			set step 		[ $rb cget -step ]
			set prefix_len 	[ $rb cget -prefix_len ]
			set start 		[ $rb cget -start ]
			set active      [ $rb cget -active]	
			set metric_lsa  [ $rb cget -metric_lsa]
			if { [lsearch $routeBlock(obj) $rb] == -1 } {
			    set hRouteBlock [ ixNet add $handle routeRange ]
				ixNet commit
				set hRouteBlock [ ixNet remapIds $hRouteBlock ]
				$rb setHandle $hRouteBlock
				set routeBlock($rb,handle) $hRouteBlock
				lappend routeBlock(obj) $rb
			} else {
			    set hRouteBlock $routeBlock($rb,handle)
				$rb setHandle $hRouteBlock
			}			
            puts "hRouteBlock: $hRouteBlock"	
            puts "$num; $start; $prefix_len; $step"
			ixNet setM $hRouteBlock \
				-numberOfRoutes $num \
				-type $origin \
				-networkNumber $start \
				-mask $prefix_len \
				-enabled $active \
				-metric $metric_lsa \
                -firstRoute $start
			ixNet commit
		}
	}
	
    return [GetStandardReturnHeader]
}
body SimulatedSummaryRoute::config { args } {
    global errorInfo
    global errNumber
    set tag "body SimulatedSummaryRoute::config [info script]"
    Deputs "----- TAG: $tag -----"
    
    #param collection
    Deputs "Args:$args "
    foreach { key value } $args {
        set key [string tolower $key]
        switch -exact -- $key {
            
            -age {
				set age $value
            }            
			-checksum {
				set checksum $value
            }
            -metric {
				set metric $value
            }            
			-route_block {
				set route_block $value
            }

        }
    }
	
	if { [ info exists metric ] } {
		ixNet setA $handle -metric $metric
	}
	
	if { [ info exists route_block ] } {
	
		set routeBlock [ GetObject $route_block ]
		$route_block configure -handle $handle
		
		if { $routeBlock == "" } {
		
			return [GetErrorReturnHeader "No object found...-route_block"]
			
		}
		
		set num 		[ $routeBlock cget -num ]
		set start 		[ $routeBlock cget -start ]
		set step		[ $routeBlock cget -step ]
		set prefix_len	[ $routeBlock cget -prefix_len ]
		
		ixNet setM $handle \
			-mask $prefix_len \
			-firstRoute $start \
			-numberOfRoutes $num \
			-step $step
#		-enabled True
		
	} else {
	
		return [GetErrorReturnHeader "Madatory parameter needed...-route_block"]
	}
	
	ixNet commit
	
    return [GetStandardReturnHeader]
	
}

body OspfSession::advertise_topo {} {

	set tag "body OspfSession::advertise_topo [info script]"
    Deputs "----- TAG: $tag -----"

	foreach route [ ixNet getL $handle routeRange ] {
		ixNet setA $route -enabled True
	}
	ixNet setA $hNetworkRange -enabled True
	ixNet commit
    return [GetStandardReturnHeader]
}

body OspfSession::withdraw_topo {} {

	set tag "body OspfSession::withdraw_topo [info script]"
Deputs "----- TAG: $tag -----"

	foreach route [ ixNet getL $handle routeRange ] {
	
		ixNet setA $route -enabled False
	}
	
	ixNet setA $hNetworkRange -enabled False
	ixNet commit
    return [GetStandardReturnHeader]
}

body OspfSession::flapping_topo { args } {

	set tag "body OspfSession::flapping_topo [info script]"
Deputs "----- TAG: $tag -----"


    foreach { key value } $args {
        set key [string tolower $key]
        switch -exact -- $key {
		
			-times {
				set times $value
			}
			-interval {
				set interval $value
			}
		}
	}
	
	for { set index 0 } { $index < $times } { incr index } {
		foreach route [ ixNet getL $handle routeRange ] {
		
			ixNet setA $route -enabled True
		}
		ixNet commit
		
		after [ expr $interval * 1000 ]
		
		foreach route [ ixNet getL $handle routeRange ] {
		
			ixNet setA $route -enabled False
		}
		ixNet commit
		
	}
	
	ixNet commit
    return [GetStandardReturnHeader]
}

body Ospfv2Session::get_status {} {

	set tag "body OspfSession::get_status [info script]"
Deputs "----- TAG: $tag -----"

    set root [ixNet getRoot]
Deputs "root $root"
	if {[ixNet getA $hPort/protocols/ospf -enabled]} {
		set view {::ixNet::OBJ-/statistics/view:"OSPF Aggregated Statistics"}
	} elseif {[ixNet getA $hPort/protocols/ospfV3 -enabled]} {
		set view {::ixNet::OBJ-/statistics/view:"OSPFv3 Aggregated Statistics"}
	} else {
		error "No ospf or ospfv3 aggregated statistics"
	}
#    set view {::ixNet::OBJ-/statistics/view:"OSPF Aggregated Statistics"}
    set captionList         [ ixNet getA $view/page -columnCaptions ]
	
    set name_index        		[ lsearch -exact $captionList {Stat Name} ]
	set down_index 				[ lsearch -exact $captionList {Down State Count} ]
    set attempt_index      		[ lsearch -exact $captionList {Attempt State Count} ]
	set init_index 				[ lsearch -exact $captionList {Init State Count} ]
	set twoway_index 			[ lsearch -exact $captionList {TwoWay State Count} ]
	set exstart_index			[ lsearch -exact $captionList {ExStart State Count} ]
	set exchange_index			[ lsearch -exact $captionList {Exchange State Count} ]
	set loading_index			[ lsearch -exact $captionList {Loading State Count} ]
	set full_index				[ lsearch -exact $captionList {Full State Count} ]
	
	set stats [ ixNet getA $view/page -rowValues ]
Deputs "stats:$stats"
    set portFound 0
    foreach row $stats {
        eval {set row} $row
Deputs "row:$row"
Deputs "port index:$name_index"
        set rowPortName [ lindex $row $name_index ]
Deputs "row port name:$name_index"
    set connectionInfo [ ixNet getA $hPort -connectionInfo ]
Deputs "connectionInfo :$connectionInfo"
    regexp -nocase {chassis=\"([0-9\.]+)\" card=\"([0-9\.]+)\" port=\"([0-9\.]+)\"} $connectionInfo match chassis card port
Deputs "chas:$chassis card:$card port$port"
	set portName ${chassis}/Card${card}/Port${port}
Deputs "filter name: $portName"
        if { [ regexp $portName $rowPortName ] } {
            set portFound 1
            break
        }
    }	
	

	set status "down"

	# down��attempt��init��two_ways��exstart��exchange��loading��full	
    if { $portFound } {
		set down    	[ lindex $row $down_index ]
		set attempt    	[ lindex $row $attempt_index ]
		set init    	[ lindex $row $init_index ]
		set twoway    	[ lindex $row $twoway_index ]
		set exstart     [ lindex $row $exstart_index ]
		set exchange    [ lindex $row $exchange_index ]
		set loading     [ lindex $row $loading_index ]
		set full    	[ lindex $row $full_index ]
		if { $down } {
			set status "down"
		}
		if { $attempt } {
			set status "attempt"
		}
		if { $init } {
			set status "init"
		}
		if { $twoways } {
			set status "two_ways"
		}
		if { $exstart } {
			set status "exstart"
		}
		if { $exchange } {
			set status "exchange"
		}
		if { $loading } {
			set status "loading"
		}
		if { $full } {
			set status "full"
		}
		
	}	
	
    set ret [ GetStandardReturnHeader ]
    set ret $ret[ GetStandardReturnBody "status" $status ]
	return $ret
	
}

body Ospfv2Session::get_stats {} {
	set tag "body OspfSession::get_status [info script]"
Deputs "----- TAG: $tag -----"

    set root [ixNet getRoot]
Deputs "root $root"
    set view {::ixNet::OBJ-/statistics/view:"OSPF Aggregated Statistics"}
    set captionList         [ ixNet getA $view/page -columnCaptions ]

	# {LSAs Acknowledged} 
	# {LSA Acknowledges Rx} 
	# {SummaryASLSA Tx} 
	# {SummaryASLSA Rx} 
	# {OpaqueLocalLSA Tx} 
	# {OpaqueLocalLSA Rx} 
	# {OpaqueAreaLSA Tx} 
	# {OpaqueAreaLSA Rx} 
	# {OpaqueDomainLSA Tx} 
	# {OpaqueDomainLSA Rx} 
	# {GraceLSA Rx} 
	# {HelperMode Attempted} 
	# {HelperMode Failed} 
	# {Rate Control Blocked Flood LSUpdate}
	
	# rx_te_lsa
	# tx_te_lsa
	
    set name_index        		[ lsearch -exact $captionList {Stat Name} ]
    set rx_ack_index          	[ lsearch -exact $captionList {LS Ack Rx} ]
    set tx_ack_index          	[ lsearch -exact $captionList {LS Ack Tx} ]
	set rx_dd_index				[ lsearch -exact $captionList {DBD Rx} ]
	set tx_dd_index				[ lsearch -exact $captionList {DBD Tx} ]
	set rx_hello_index			[ lsearch -exact $captionList {Hellos Rx} ]
	set tx_hello_index			[ lsearch -exact $captionList {Hellos Tx} ]
	set rx_network_lsa_index	[ lsearch -exact $captionList {NetworkLSA Rx} ]
	set tx_network_lsa_index	[ lsearch -exact $captionList {NetworkLSA Tx} ]
	set rx_nssa_lsa_index		[ lsearch -exact $captionList {NSSALSA Rx} ]
	set tx_nssa_lsa_index		[ lsearch -exact $captionList {NSSALSA Tx} ]
	set rx_request_index		[ lsearch -exact $captionList {LS Request Rx} ]
	set tx_request_index		[ lsearch -exact $captionList {LS Request Tx} ]
	set rx_router_lsa_index		[ lsearch -exact $captionList {RouterLSA Rx} ]
	set tx_router_lsa_index		[ lsearch -exact $captionList {RouterLSA Tx} ]
	set rx_summary_lsa_index	[ lsearch -exact $captionList {SummaryIPLSA Rx} ]
	set tx_summary_lsa_index	[ lsearch -exact $captionList {SummaryIPLSA Tx} ]
	set rx_as_external_lsa_index 	[ lsearch -exact $captionList {ExternalLSA Rx} ]
	set tx_as_external_lsa_index 	[ lsearch -exact $captionList {ExternalLSA Tx} ]
    set rx_asbr_summary_lsa_index 	[ lsearch -exact $captionList  {LinkState Advertisement Rx}  ]
    set tx_asbr_summary_lsa_index 	[ lsearch -exact $captionList  {LinkState Advertisement Tx}  ]
    set rx_update_index	 		[ lsearch -exact $captionList  {LS Update Rx}  ]
    set tx_update_index	 		[ lsearch -exact $captionList  {LS Update Tx}  ]

	set stats [ ixNet getA $view/page -rowValues ]
Deputs "stats:$stats"
    set portFound 0
    foreach row $stats {
        eval {set row} $row
Deputs "row:$row"
Deputs "port index:$name_index"
        set rowPortName [ lindex $row $name_index ]
Deputs "row port name:$name_index"
    set connectionInfo [ ixNet getA $hPort -connectionInfo ]
Deputs "connectionInfo :$connectionInfo"
    regexp -nocase {chassis=\"([0-9\.]+)\" card=\"([0-9\.]+)\" port=\"([0-9\.]+)\"} $connectionInfo match chassis card port
Deputs "chas:$chassis card:$card port$port"
	set portName ${chassis}/Card${card}/Port${port}
Deputs "filter name: $portName"
        if { [ regexp $portName $rowPortName ] } {
            set portFound 1
            break
        }
    }	
	


    set ret "Status : true\nLog : \n"
    
    if { $portFound } {
        set statsItem   "rx_ack"
		set statsVal    [ lindex $row $rx_ack_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "tx_ack"
		set statsVal    [ lindex $row $tx_ack_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]

        set statsItem   "rx_dd"
		set statsVal    [ lindex $row $rx_dd_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "tx_dd"
		set statsVal    [ lindex $row $tx_dd_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "rx_hello"
		set statsVal    [ lindex $row $rx_hello_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "tx_hello"
		set statsVal    [ lindex $row $tx_hello_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "rx_network_lsa"
		set statsVal    [ lindex $row $rx_network_lsa_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "tx_network_lsa"
		set statsVal    [ lindex $row $tx_network_lsa_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "rx_nssa_lsa"
		set statsVal    [ lindex $row $rx_nssa_lsa_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "tx_nssa_lsa"
		set statsVal    [ lindex $row $tx_nssa_lsa_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "rx_request"
		set statsVal    [ lindex $row $rx_request_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "tx_request"
		set statsVal    [ lindex $row $tx_request_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "rx_router_lsa"
		set statsVal    [ lindex $row $rx_router_lsa_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "tx_router_lsa"
		set statsVal    [ lindex $row $tx_router_lsa_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "rx_summary_lsa"
		set statsVal    [ lindex $row $rx_summary_lsa_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "tx_summary_lsa"
		set statsVal    [ lindex $row $tx_summary_lsa_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "rx_as_external_lsa"
		set statsVal    [ lindex $row $rx_as_external_lsa_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "tx_as_external_lsa"
		set statsVal    [ lindex $row $tx_as_external_lsa_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "rx_asbr_summary_lsa"
		set statsVal    [ lindex $row $rx_asbr_summary_lsa_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "tx_asbr_summary_lsa"
		set statsVal    [ lindex $row $tx_asbr_summary_lsa_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "rx_update"
		set statsVal    [ lindex $row $rx_update_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "tx_update"
		set statsVal    [ lindex $row $tx_update_index ]
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "rx_te_lsa"
		set statsVal    "NA"
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        set statsItem   "tx_te_lsa"
		set statsVal    "NA"
Deputs "stats val:$statsVal"
        set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
        
        
    }

Deputs "ret:$ret"
	
    return $ret
	
}

body Ospfv2Session::get_fh_stats {} {
	set tag "body OspfSession::get_fh_status [info script]"
Deputs "----- TAG: $tag -----"

    set root [ixNet getRoot]
Deputs "root $root"
    set view {::ixNet::OBJ-/statistics/view:"OSPF Aggregated Statistics"}
    set captionList         [ ixNet getA $view/page -columnCaptions ]

	
	
    set name_index        		    [ lsearch -exact $captionList {Stat Name} ]
    set rx_ack_index          	    [ lsearch -exact $captionList {LS Ack Rx} ]
    set tx_ack_index          	    [ lsearch -exact $captionList {LS Ack Tx} ]
	set rx_dd_index				    [ lsearch -exact $captionList {DBD Rx} ]
	set tx_dd_index				    [ lsearch -exact $captionList {DBD Tx} ]
	set rx_hello_index			    [ lsearch -exact $captionList {Hellos Rx} ]
	set tx_hello_index			    [ lsearch -exact $captionList {Hellos Tx} ]
	set rx_network_lsa_index	    [ lsearch -exact $captionList {NetworkLSA Rx} ]
	set tx_network_lsa_index	    [ lsearch -exact $captionList {NetworkLSA Tx} ]
	set rx_nssa_lsa_index		    [ lsearch -exact $captionList {NSSALSA Rx} ]
	set tx_nssa_lsa_index		    [ lsearch -exact $captionList {NSSALSA Tx} ]
	set rx_request_index		    [ lsearch -exact $captionList {LS Request Rx} ]
	set tx_request_index		    [ lsearch -exact $captionList {LS Request Tx} ]
	set rx_router_lsa_index		    [ lsearch -exact $captionList {RouterLSA Rx} ]
	set tx_router_lsa_index		    [ lsearch -exact $captionList {RouterLSA Tx} ]
	set rx_summary_lsa_index	    [ lsearch -exact $captionList {SummaryIPLSA Rx} ]
	set tx_summary_lsa_index	    [ lsearch -exact $captionList {SummaryIPLSA Tx} ]
	set rx_as_external_lsa_index 	[ lsearch -exact $captionList {ExternalLSA Rx} ]
	set tx_as_external_lsa_index 	[ lsearch -exact $captionList {ExternalLSA Tx} ]
    set rx_asbr_summary_lsa_index 	[ lsearch -exact $captionList  {LinkState Advertisement Rx}  ]
    set tx_asbr_summary_lsa_index 	[ lsearch -exact $captionList  {LinkState Advertisement Tx}  ]
    set rx_update_index	 		    [ lsearch -exact $captionList  {LS Update Rx}  ]
    set tx_update_index	 		    [ lsearch -exact $captionList  {LS Update Tx}  ]

	set stats [ ixNet getA $view/page -rowValues ]
Deputs "stats:$stats"
    set portFound 0
    foreach row $stats {
        eval {set row} $row
Deputs "row:$row"
Deputs "port index:$name_index"
        set rowPortName [ lindex $row $name_index ]
Deputs "row port name:$name_index"
    set connectionInfo [ ixNet getA $hPort -connectionInfo ]
Deputs "connectionInfo :$connectionInfo"
    regexp -nocase {chassis=\"([0-9\.]+)\" card=\"([0-9\.]+)\" port=\"([0-9\.]+)\"} $connectionInfo match chassis card port
Deputs "chas:$chassis card:$card port$port"
	set portName ${chassis}/Card${card}/Port${port}
Deputs "filter name: $portName"
        if { [ regexp $portName $rowPortName ] } {
            set portFound 1
            break
        }
    }	
	


    set ret ""
    
    if { $portFound } {
        set statsItem   "RxHello"
		set statsVal    [ lindex $row $rx_hello_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal
       
        
        set statsItem   "TxHello"
		set statsVal    [ lindex $row $tx_hello_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal
        
        set statsItem   "RxDd"
		set statsVal    [ lindex $row $rx_dd_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal
        
        set statsItem   "TxDd"
		set statsVal    [ lindex $row $tx_dd_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal
        
        set statsItem   "RxAck"
		set statsVal    [ lindex $row $rx_ack_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal
        
        set statsItem   "TxAck"
		set statsVal    [ lindex $row $tx_ack_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal

        set statsItem   "RxRequest"
		set statsVal    [ lindex $row $rx_request_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal
        
        set statsItem   "TxRequest"
		set statsVal    [ lindex $row $tx_request_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal
        
        set statsItem   "RxUpdate"
		set statsVal    [ lindex $row $rx_update_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal
        
        set statsItem   "TxUpdate"
		set statsVal    [ lindex $row $tx_update_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal
        
        set statsItem   "RxRouterLsa"
		set statsVal    [ lindex $row $rx_router_lsa_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal
        
        set statsItem   "TxRouterLsa"
		set statsVal    [ lindex $row $tx_router_lsa_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal
      
        
        set statsItem   "RxNetworkLsa"
		set statsVal    [ lindex $row $rx_network_lsa_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal
        
        set statsItem   "TxNetworkLsa"
		set statsVal    [ lindex $row $tx_network_lsa_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal
        
        set statsItem   "RxSummaryLsa"
		set statsVal    [ lindex $row $rx_summary_lsa_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal
        
        set statsItem   "TxSummaryLsa"
		set statsVal    [ lindex $row $tx_summary_lsa_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal
        
        set statsItem   "RxAsExternalLsa"
		set statsVal    [ lindex $row $rx_as_external_lsa_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal
        
        set statsItem   "TxAsExternalLsa"
		set statsVal    [ lindex $row $tx_as_external_lsa_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal
        
        set statsItem   "RxNssaLsa"
		set statsVal    [ lindex $row $rx_nssa_lsa_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal
        
        set statsItem   "TxNssaLsa"
		set statsVal    [ lindex $row $tx_nssa_lsa_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal
               
        set statsItem   "RxAsbrSummaryLsa"
		set statsVal    [ lindex $row $rx_asbr_summary_lsa_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal
        
        set statsItem   "TxAsbrSummaryLsa"
		set statsVal    [ lindex $row $tx_asbr_summary_lsa_index ]
Deputs "stats val:$statsVal"
        lappend ret $statItem $statsVal
       
        
        
    }

Deputs "ret:$ret"
	
    return $ret
	
}

body Ospfv2Session::config { args } {
	global errorInfo
	global errNumber
	
	set tag "body Ospfv2Session::config [info script]"
    Deputs "----- TAG: $tag -----"
            
    Deputs "Args:$args "
	foreach { key value } $args {
		set key [string tolower $key]
		switch -exact -- $key {
			-ipv4_addr {
				set ipv4_addr $value
			}
            -ipv4_mask -
			-ipv4_prefix_len {
				if { [ string is integer $value ] && $value <= 32 } {
					set ipv4_prefix_len $value					
				} else {
					error "$errNumber(1) key:$key value:$value"					
				}				
			}
			-ipv4_gw {
				set ipv4_gw $value
			}
			-outer_vlan_id {
				if { [ string is integer $value ] && ( $value >= 0 ) && ( $value < 4096 ) } {
					set outer_vlan_id $value
					set flagOuterVlan   1					
				} else {
					error "$errNumber(1) key:$key value:$value"					
				}
			}
			-outer_vlan_step {
				if { [ string is integer $value ] && ( $value >= 0 ) && ( $value < 4096 ) } {
					set outer_vlan_step $value
					set flagOuterVlan   1					
				} else {
					error "$errNumber(1) key:$key value:$value"					
				}				
			}
			-outer_vlan_num {
				if { [ string is integer $value ] && ( $value >= 0 ) } {
					set outer_vlan_num $value
					set flagOuterVlan   1					
				} else {
					error "$errNumber(1) key:$key value:$value"					
				}				
			}
			-outer_vlan_priority {
				if { [ string is integer $value ] && ( $value >= 0 ) && ( $value < 8 ) } {
					set outer_vlan_priority $value
					set flagOuterVlan   1					
				} else {
					error "$errNumber(1) key:$key value:$value"					
				}				
			}
			-inner_vlan_id {
				if { [ string is integer $value ] && ( $value >= 0 ) && ( $value < 4096 ) } {
					set inner_vlan_id $value
					set flagInnerVlan   1					
				} else {
					error "$errNumber(1) key:$key value:$value"					
				}				
			}
			-inner_vlan_step {
				if { [ string is integer $value ] && ( $value >= 0 ) && ( $value < 4096 ) } {
					set inner_vlan_step $value
					set flagInnerVlan   1					
				} else {
					error "$errNumber(1) key:$key value:$value"					
				}				
			}
			-inner_vlan_num {
				if { [ string is integer $value ] && ( $value >= 0 ) } {
					set inner_vlan_num $value
					set flagInnerVlan   1					
				} else {
					error "$errNumber(1) key:$key value:$value"					
				}				
			}
			-inner_vlan_priority {
				if { [ string is integer $value ] && ( $value >= 0 ) && ( $value < 8 ) } {
					set inner_vlan_priority $value
					set flagInnerVlan   1					
				} else {
					error "$errNumber(1) key:$key value:$value"					
				}				
			}
			-outer_vlan_cfi {
				set outer_vlan_cfi $value				
			}
			-inner_vlan_cfi {
				set inner_vlan_cfi $value				
			}
			-loopback_ipv4_addr {
				set loopback_ipv4_addr $value
                if { ![info exists loopback_ipv4_gw] } {
                    set loopback_ipv4_gw 192.85.1.1
                }
			}
			-loopback_ipv4_gw {
				set loopback_ipv4_gw $value
                if { ![info exists loopback_ipv4_addr] } {
                    set loopback_ipv4_addr 192.85.1.2
                }
			}
		}
	}
	if { $handle == "" } {
		reborn
	}
	if { [ info exists ipv4_addr ] } {
		foreach rb $rb_interface {
			if { [ ixNet getA $rb -type ] == "routed" } {
				continue
			}
			ixNet setA $rb/ipv4 -ip $ipv4_addr 
			ixNet commit
		}
 		#generate_interface	
	}	
	if { [ info exists ipv4_prefix_len ] } {
		foreach rb $rb_interface {
			if { [ ixNet getA $rb -type ] == "routed" } {
				continue
			}
			ixNet setM $rb/ipv4 -maskWidth $ipv4_prefix_len
			ixNet commit
		}
 		#generate_interface	
	}
	if { [ info exists ipv4_gw ] } {
		foreach rb $rb_interface {
			if { [ ixNet getA $rb -type ] == "routed" } {
				continue
			}
			ixNet setM $rb/ipv4 -gateway $ipv4_gw 
			ixNet commit
		}
 		#generate_interface	
	}
	if {[ info exists outer_vlan_id ]} {
		foreach int $rb_interface {
            if { [ info exists outer_vlan_id ] } {
                set vlanId $outer_vlan_id
                ixNet setM $int/vlan \
                    -count 1 \
                    -vlanEnable True \
                    -vlanId $vlanId
                ixNet commit

                if { [ info exists outer_vlan_priority ] } {
                    ixNet setM $int/vlan -vlanPriority $outer_vlan_priority
                    ixNet commit
                }
                
                if { [ info exists inner_vlan_id ] } {
                    set inVlanId $inner_vlan_id
                    set vlanId1	[ ixNet getA $int/vlan -vlanId ]					
                    set vlanId	"${vlanId1},${inVlanId}"
                    ixNet setM $int/vlan \
                                -count 2 \
                                -vlanEnable True \
                                -vlanId $vlanId 
                    ixNet commit
                    
                    if { [ info exists inner_vlan_priority ] } {
                        set outerPri [ ixNet getA $int/vlan -vlanPriority]
                        set Pri "${outerPri},${inner_vlan_priority}"
                        ixNet setM $int/vlan -vlanPriority $Pri
                        ixNet commit
                    }
                }
            }

            if { [ info exists enabled ] } {
                ixNet setA $int -enabled $enabled
                ixNet commit			
            }
		}
	}
	
	if { [ info exists loopback_ipv4_addr ] } {
		catch { Host $this.loopback $portObj }
		$this.loopback config \
			-ipv4_addr $loopback_ipv4_addr \
			-unconnected 1 \
			-ipv4_prefix_len 32 \
			-ipv4_gw $loopback_ipv4_gw
		set loopbackInt [ $this.loopback cget -handle ] 
        Deputs "loopback int:$loopbackInt"
		set viaInt [ lindex $rb_interface end ]
        Deputs "via interface:$viaInt"
		ixNet setA $loopbackInt/unconnected \
			-connectedVia $viaInt
		ixNet commit
		set hInt [ ixNet add $handle interface ]
		ixNet setM $hInt \
			-interfaceIpAddress $loopback_ipv4_addr \
			-interfaceIpMaskAddress 255.255.255.255 \
			-enabled True \
			-connectedToDut False \
			-linkTypes stub
		
		ixNet commit
		set interface($loopbackInt) $hInt	
	}
	
	ixNet commit
	eval chain $args
	return [GetStandardReturnHeader]
}

body OspfSession::set_topo {args} {
	
	set tag "body OspfSession::set_topo [info script]"
Deputs "----- TAG: $tag -----"

	set hRouter $handle
	set hNetworkRange [ixNet add $hRouter networkRange]
	ixNet commit

	set hNetworkRange [ ixNet remapIds $hNetworkRange ]
	ixNet setA $hNetworkRange -enalbed True
	ixNet commit
	
	
	foreach { key value } $args {
		set key [string tolower $key]
		switch -exact -- $key {
			-topo {
				set topo $value
			}
		}
	}
	
	if { [ info exists topo ] } {
		
		
		if { $topo == "" || [ $topo isa Topology ] == 0 } {
			return [GetErrorReturnHeader "No valid object found...-topo $topo"]
		}
		
		set type [$topo cget -type]
		set sim_rtr_num [$topo cget -sim_rtr_num]
		set row_num [$topo cget -row_num]
		set column_num [$topo cget -column_num]
		set attach_row [$topo cget -attach_row]
		set attach_column [$topo cget -attach_column]
		
		ixNet setM $hNetworkRange \
			-numRows $row_num \
			-numCols $column_num \
			-entryRow $attach_row \
			-entryColumn $attach_column
		
	} else {
		return [GetErrorReturnHeader "Madatory parameter needed...-topo"]
	}
	ixNet commit
	
	return [GetStandardReturnHeader]
}

body OspfSession::unset_topo {} {
	
	set tag "body OspfSession::unset_topo [info script]"
    Deputs "----- TAG: $tag -----"

	ixNet remove $hNetworkRange
	ixNet commit
}

body SimulatedInterAreaRoute::config { args } {
    global errorInfo
    global errNumber
    set tag "body SimulatedInterAreaRoute::config [info script]"
    Deputs "----- TAG: $tag -----"

    #param collection
    Deputs "Args:$args "
    foreach { key value } $args {
	   set key [string tolower $key]
	   switch -exact -- $key {
		  
		  -age {
				set age $value
		  }            
			-checksum {
				set checksum $value
		  }
		  -metric {
				set metric $value
		  }   
		   -prefix_options {
			   set prefix_options $value
		   } 
		   -seq_num  {
			   set seq_num  $value
		   } 
			-route_block {
				set route_block $value
		  }

	   }
    }
	
	if { [ info exists metric ] } {
		ixNet setA $handle -metric $metric
	}
	
	if { [ info exists route_block ] } {
	
		set routeBlock [ GetObject $route_block ]
		$route_block configure -handle $handle
		
		if { $routeBlock == "" } {
		
			return [GetErrorReturnHeader "No object found...-route_block"]
			
		}
		
		set num 		[ $routeBlock cget -num ]
		set start 		[ $routeBlock cget -start ]
		set step		[ $routeBlock cget -step ]
		set prefix_len	[ $routeBlock cget -prefix_len ]
		
		ixNet setM $handle \
		-numberOfRoutes $num \
		-firstRoute $start \
		-step $step \
		-mask $prefix_len 
		
	} else {
	
		return [GetErrorReturnHeader "Madatory parameter needed...-route_block"]
	}
	
	ixNet commit
	
    return [GetStandardReturnHeader]
	
}

body Ospfv3Session::get_status {} {

	set tag "body Ospfv3Session::get_status [info script]"
    Deputs "----- TAG: $tag -----"

    set root [ixNet getRoot]
    Deputs "root $root"
    set view {::ixNet::OBJ-/statistics/view:"OSPFv3 Aggregated Statistics"}
	after 5000
    set captionList         [ ixNet getA $view/page -columnCaptions ]
	
    set name_index        		[ lsearch -exact $captionList {Stat Name} ]
	set down_index 				[ lsearch -exact $captionList {Down State Count} ]
    set attempt_index      		[ lsearch -exact $captionList {Attempt State Count} ]
	set init_index 				[ lsearch -exact $captionList {Init State Count} ]
	set twoway_index 			[ lsearch -exact $captionList {TwoWay State Count} ]
	set exstart_index			[ lsearch -exact $captionList {ExStart State Count} ]
	set exchange_index			[ lsearch -exact $captionList {Exchange State Count} ]
	set loading_index			[ lsearch -exact $captionList {Loading State Count} ]
	set full_index				[ lsearch -exact $captionList {Full State Count} ]
	
	set stats [ ixNet getA $view/page -rowValues ]
    Deputs "stats:$stats"
    set portFound 0
    foreach row $stats {
        eval {set row} $row
        Deputs "row:$row"
        Deputs "port index:$name_index"
        set rowPortName [ lindex $row $name_index ]
        Deputs "row port name:$name_index"
        set connectionInfo [ ixNet getA $hPort -connectionInfo ]
        Deputs "connectionInfo :$connectionInfo"
        regexp -nocase {chassis=\"([0-9\.]+)\" card=\"([0-9\.]+)\" port=\"([0-9\.]+)\"} $connectionInfo match chassis card port
        Deputs "chas:$chassis card:$card port$port"
        set portName ${chassis}/Card${card}/Port${port}
        Deputs "filter name: $portName"
	   if { [ regexp $portName $rowPortName ] } {
		  set portFound 1
		  break
	   }
    }	

	set status "down"

	# down��attempt��init��two_ways��exstart��exchange��loading��full	
    if { $portFound } {
		set down    	[ lindex $row $down_index ]
		set attempt    	[ lindex $row $attempt_index ]
		set init    	[ lindex $row $init_index ]
		set twoway    	[ lindex $row $twoway_index ]
		set exstart     [ lindex $row $exstart_index ]
		set exchange    [ lindex $row $exchange_index ]
		set loading     [ lindex $row $loading_index ]
		set full    	[ lindex $row $full_index ]
		if { $down } {
			set status "down"
		}
		if { $attempt } {
			set status "attempt"
		}
		if { $init } {
			set status "init"
		}
		if { $twoways } {
			set status "two_ways"
		}
		if { $exstart } {
			set status "exstart"
		}
		if { $exchange } {
			set status "exchange"
		}
		if { $loading } {
			set status "loading"
		}
		if { $full } {
			set status "full"
		}
	}	
	
    set ret [ GetStandardReturnHeader ]
    set ret $ret[ GetStandardReturnBody "status" $status ]
	return $ret
}

body Ospfv3Session::get_stats {} {
	set tag "body Ospfv3Session::get_status [info script]"
Deputs "----- TAG: $tag -----"

    set root [ixNet getRoot]
Deputs "root $root"
    set view {::ixNet::OBJ-/statistics/view:"OSPFv3 Aggregated Statistics"}
	after 5000
    set captionList         [ ixNet getA $view/page -columnCaptions ]
	
    set name_index        		[ lsearch -exact $captionList {Stat Name} ]
    set rx_ack_index          	[ lsearch -exact $captionList {LS Ack Rx} ]
    set tx_ack_index          	[ lsearch -exact $captionList {LS Ack Tx} ]
	set rx_dd_index				[ lsearch -exact $captionList {DBD Rx} ]
	set tx_dd_index				[ lsearch -exact $captionList {DBD Tx} ]
	set rx_hello_index			[ lsearch -exact $captionList {Hellos Rx} ]
	set tx_hello_index			[ lsearch -exact $captionList {Hellos Tx} ]
	set rx_network_lsa_index	[ lsearch -exact $captionList {NetworkLSA Rx} ]
	set tx_network_lsa_index	[ lsearch -exact $captionList {NetworkLSA Tx} ]
	set rx_nssa_lsa_index		[ lsearch -exact $captionList {NSSALSA Rx} ]
	set tx_nssa_lsa_index		[ lsearch -exact $captionList {NSSALSA Tx} ]
	set rx_request_index		[ lsearch -exact $captionList {LS Request Rx} ]
	set tx_request_index		[ lsearch -exact $captionList {LS Request Tx} ]
	set rx_router_lsa_index		[ lsearch -exact $captionList {RouterLSA Rx} ]
	set tx_router_lsa_index		[ lsearch -exact $captionList {RouterLSA Tx} ]
	set rx_as_external_lsa_index 	[ lsearch -exact $captionList {ExternalLSA Rx} ]
	set tx_as_external_lsa_index 	[ lsearch -exact $captionList {ExternalLSA Tx} ]
	set rx_update_index	 		[ lsearch -exact $captionList  {LS Update Rx}  ]
	set tx_update_index	 		[ lsearch -exact $captionList  {LS Update Tx}  ]
	
    set rx_inter_area_prefix_lsa_index 	[ lsearch -exact $captionList  {InterareaPrefixLSA Rx}  ]
    set tx_inter_area_prefix_lsa_index 	[ lsearch -exact $captionList  {InterareaPrefixLSA Tx}  ]
	set rx_inter_area_router_lsa_index	[ lsearch -exact $captionList {InterareaRouterLSA Rx} ]
	set tx_inter_area_router_lsa_index	[ lsearch -exact $captionList {InterareaRouterLSA Tx} ]
	set rx_intra_area_prefix_lsa_index	[ lsearch -exact $captionList {IntraareaPrefixLSA Rx} ]
	set tx_intra_area_prefix_lsa_index	[ lsearch -exact $captionList {InterareaPrefixLSA Tx} ]
	set rx_link_lsa_index	[ lsearch -exact $captionList {LinkLSA Rx} ]
	set tx_link_lsa_index	[ lsearch -exact $captionList {LinkLSA Tx} ]


	set stats [ ixNet getA $view/page -rowValues ]
Deputs "stats:$stats"
    set portFound 0
    foreach row $stats {
	   eval {set row} $row
Deputs "row:$row"
Deputs "port index:$name_index"
	   set rowPortName [ lindex $row $name_index ]
Deputs "row port name:$name_index"
    set connectionInfo [ ixNet getA $hPort -connectionInfo ]
Deputs "connectionInfo :$connectionInfo"
    regexp -nocase {chassis=\"([0-9\.]+)\" card=\"([0-9\.]+)\" port=\"([0-9\.]+)\"} $connectionInfo match chassis card port
Deputs "chas:$chassis card:$card port$port"
	set portName ${chassis}/Card${card}/Port${port}
Deputs "filter name: $portName"
	   if { [ regexp $portName $rowPortName ] } {
		  set portFound 1
		  break
	   }
    }	
	


    set ret "Status : true\nLog : \n"
    
    if { $portFound } {
	   set statsItem   "rx_ack"
		set statsVal    [ lindex $row $rx_ack_index ]
Deputs "stats val:$statsVal"
	   set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	   
	   set statsItem   "tx_ack"
		set statsVal    [ lindex $row $tx_ack_index ]
Deputs "stats val:$statsVal"
	   set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]

	   set statsItem   "rx_dd"
		set statsVal    [ lindex $row $rx_dd_index ]
Deputs "stats val:$statsVal"
	   set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	   
	   set statsItem   "tx_dd"
		set statsVal    [ lindex $row $tx_dd_index ]
Deputs "stats val:$statsVal"
	   set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	   
	   set statsItem   "rx_hello"
		set statsVal    [ lindex $row $rx_hello_index ]
Deputs "stats val:$statsVal"
	   set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	   
	   set statsItem   "tx_hello"
		set statsVal    [ lindex $row $tx_hello_index ]
Deputs "stats val:$statsVal"
	   set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	   
	   set statsItem   "rx_network_lsa"
		set statsVal    [ lindex $row $rx_network_lsa_index ]
Deputs "stats val:$statsVal"
	   set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	   
	   set statsItem   "tx_network_lsa"
		set statsVal    [ lindex $row $tx_network_lsa_index ]
Deputs "stats val:$statsVal"
	   set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	   
	   set statsItem   "rx_nssa_lsa"
		set statsVal    [ lindex $row $rx_nssa_lsa_index ]
Deputs "stats val:$statsVal"
	   set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	   
	   set statsItem   "tx_nssa_lsa"
		set statsVal    [ lindex $row $tx_nssa_lsa_index ]
Deputs "stats val:$statsVal"
	   set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	   
	   set statsItem   "rx_request"
		set statsVal    [ lindex $row $rx_request_index ]
Deputs "stats val:$statsVal"
	   set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	   
	   set statsItem   "tx_request"
		set statsVal    [ lindex $row $tx_request_index ]
Deputs "stats val:$statsVal"
	   set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	   
	   set statsItem   "rx_router_lsa"
		set statsVal    [ lindex $row $rx_router_lsa_index ]
Deputs "stats val:$statsVal"
	   set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	   
	   set statsItem   "tx_router_lsa"
		set statsVal    [ lindex $row $tx_router_lsa_index ]
Deputs "stats val:$statsVal"
	   set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]	   
	   
	   set statsItem   "rx_as_external_lsa"
		set statsVal    [ lindex $row $rx_as_external_lsa_index ]
Deputs "stats val:$statsVal"
	   set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	   
	   set statsItem   "tx_as_external_lsa"
		set statsVal    [ lindex $row $tx_as_external_lsa_index ]
Deputs "stats val:$statsVal"
	   set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	   
	   set statsItem   "rx_update"
		set statsVal    [ lindex $row $rx_update_index ]
Deputs "stats val:$statsVal"
	   set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	   
	   set statsItem   "tx_update"
		set statsVal    [ lindex $row $tx_update_index ]
Deputs "stats val:$statsVal"
	   set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	      
	    set statsItem   "rx_inter_area_prefix_lsa"
	    set statsVal    [ lindex $row $rx_inter_area_prefix_lsa_index ]
Deputs "stats val:$statsVal"
	  set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	   
	   set statsItem   "tx_inter_area_prefix_lsa"
	   set statsVal    [ lindex $row $tx_inter_area_prefix_lsa_index ]
Deputs "stats val:$statsVal"
	 set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	    
	    set statsItem   "rx_inter_area_router_lsa"
	    set statsVal    [ lindex $row $rx_inter_area_router_lsa_index ]
Deputs "stats val:$statsVal"
	  set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	    
	    set statsItem   "tx_inter_area_router_lsa"
	    set statsVal    [ lindex $row $tx_inter_area_router_lsa_index ]
Deputs "stats val:$statsVal"
	  set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	    
	    set statsItem   "rx_intra_area_prefix_lsa"
	    set statsVal    [ lindex $row $rx_intra_area_prefix_lsa_index ]
Deputs "stats val:$statsVal"
	  set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	    
	    set statsItem   "tx_intra_area_prefix_lsa"
	    set statsVal    [ lindex $row $tx_intra_area_prefix_lsa_index ]
Deputs "stats val:$statsVal"
	  set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	    
	    set statsItem   "rx_link_lsa"
	    set statsVal    [ lindex $row $rx_link_lsa_index ]
Deputs "stats val:$statsVal"
	  set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	    
	    set statsItem   "tx_link_lsa"
	    set statsVal    [ lindex $row $tx_link_lsa_index ]
Deputs "stats val:$statsVal"
	  set ret $ret[ GetStandardReturnBody $statsItem $statsVal ]
	    
    }

Deputs "ret:$ret"
	
    return $ret
	
}

body SimulatedRouter::config { args } {
	global errorInfo
     global errNumber
	
	set type normal
     set tag "body SimulatedRouter::config [info script]"
Deputs "----- TAG: $tag -----"

Deputs "Args:$args "
	foreach { key value } $args {
		set key [string tolower $key]
		switch -exact -- $key {
			-id {
				set id $value
			}            
			-type {
				set type $value
			}
		}
	}
	
	if { [ info exists id ] } {
		ixNet setA $hUserlsa -advertisingRouterId $id
	}
	
	if { [ info exists type ] } {
		switch $type {						
			abr {
				ixNet setM $hUserlsa/router -bBit True
			}
			asbr {
				ixNet setM $hUserlsa/router -eBit True								
			}	
			vl {
				ixNet setM $hUserlsa/router -vBit True
			}
			normal {
				ixNet setM $hUserlsa/router \
				-bBit False \
				-eBit False \
				-vBit False \
				-wBit False
			}
		}
	}
	
	ixNet commit
	return [GetStandardReturnHeader]
	
}

body Ospfv3Session::config { args } {
	global errorInfo
	global errNumber
	
	set tag "body Ospfv3Session::config [info script]"
    Deputs "----- TAG: $tag -----"
	
    Deputs "Args:$args "
	foreach { key value } $args {
		set key [string tolower $key]
		switch -exact -- $key {
			-ipv6_addr {
				set ipv6_addr $value
			}
			-ipv6_prefix_len {
				if { [ string is integer $value ] && $value <= 128 } {
					set ipv6_prefix_len $value					
				} else {
					error "$errNumber(1) key:$key value:$value"					
				}				
			}
			-ipv6_gw {
				set ipv6_gw $value
			}
			-outer_vlan_id {
				if { [ string is integer $value ] && ( $value >= 0 ) && ( $value < 4096 ) } {
					set outer_vlan_id $value
					set flagOuterVlan   1					
				} else {
					error "$errNumber(1) key:$key value:$value"					
				}
			}
			-outer_vlan_step {
				if { [ string is integer $value ] && ( $value >= 0 ) && ( $value < 4096 ) } {
					set outer_vlan_step $value
					set flagOuterVlan   1					
				} else {
					error "$errNumber(1) key:$key value:$value"					
				}				
			}
			-outer_vlan_num {
				if { [ string is integer $value ] && ( $value >= 0 ) } {
					set outer_vlan_num $value
					set flagOuterVlan   1					
				} else {
					error "$errNumber(1) key:$key value:$value"					
				}				
			}
			-outer_vlan_priority {
				if { [ string is integer $value ] && ( $value >= 0 ) && ( $value < 8 ) } {
					set outer_vlan_priority $value
					set flagOuterVlan   1					
				} else {
					error "$errNumber(1) key:$key value:$value"					
				}				
			}
			-inner_vlan_id {
				if { [ string is integer $value ] && ( $value >= 0 ) && ( $value < 4096 ) } {
					set inner_vlan_id $value
					set flagInnerVlan   1					
				} else {
					error "$errNumber(1) key:$key value:$value"					
				}				
			}
			-inner_vlan_step {
				if { [ string is integer $value ] && ( $value >= 0 ) && ( $value < 4096 ) } {
					set inner_vlan_step $value
					set flagInnerVlan   1					
				} else {
					error "$errNumber(1) key:$key value:$value"					
				}				
			}
			-inner_vlan_num {
				if { [ string is integer $value ] && ( $value >= 0 ) } {
					set inner_vlan_num $value
					set flagInnerVlan   1					
				} else {
					error "$errNumber(1) key:$key value:$value"					
				}				
			}
			-inner_vlan_priority {
				if { [ string is integer $value ] && ( $value >= 0 ) && ( $value < 8 ) } {
					set inner_vlan_priority $value
					set flagInnerVlan   1					
				} else {
					error "$errNumber(1) key:$key value:$value"					
				}				
			}
			-outer_vlan_cfi {
				set outer_vlan_cfi $value				
			}
			-inner_vlan_cfi {
				set inner_vlan_cfi $value				
			}
		}
	}
	if { [ info exists ipv6_addr ] } {
		foreach int $rb_interface {
			if { [ llength [ ixNet getList $int ipv6 ] ] == 0 } {
				set ipv6Int   [ ixNet add $int ipv6 ]				
			} else {
				set ipv6Int   [ lindex [ ixNet getList $int ipv6 ] end ]				
			}
			ixNet setA $ipv6Int -ip $ipv6_addr
            if { [ info exists ipv6_prefix_len ] } {
                ixNet setA $ipv6Int -prefixLength $ipv6_prefix_len
            }
            if { [ info exists ipv6_gw ] } {
                ixNet setA $ipv6Int -gateway $ipv6_gw
            }
            ixNet commit
		}
		ixNet commit
	}	
	
	if {[ info exists outer_vlan_id ]} {
		foreach int $rb_interface {
            if { [ info exists outer_vlan_id ] } {
                set vlanId $outer_vlan_id
                ixNet setM $int/vlan \
                    -count 1 \
                    -vlanEnable True \
                    -vlanId $vlanId
                ixNet commit

                if { [ info exists outer_vlan_priority ] } {
                    ixNet setM $int/vlan -vlanPriority $outer_vlan_priority
                    ixNet commit
                }
                
                if { [ info exists inner_vlan_id ] } {
                    set inVlanId $inner_vlan_id
                    set vlanId1	[ ixNet getA $int/vlan -vlanId ]					
                    set vlanId	"${vlanId1},${inVlanId}"
                    ixNet setM $int/vlan \
                                -count 2 \
                                -vlanEnable True \
                                -vlanId $vlanId 
                    ixNet commit
                    
                    if { [ info exists inner_vlan_priority ] } {
                        set outerPri [ ixNet getA $int/vlan -vlanPriority]
                        set Pri "${outerPri},${inner_vlan_priority}"
                        ixNet setM $int/vlan -vlanPriority $Pri
                        ixNet commit
                    }
                }
            }

            if { [ info exists enabled ] } {
                ixNet setA $int -enabled $enabled
                ixNet commit			
            }
		}
	}
	
	ixNet commit
    eval chain $args
	return [GetStandardReturnHeader]
	
}

body SimulatedLink::config { args } {
    global errorInfo
    global errNumber
    set tag "body SimulatedLink::config [info script]"
Deputs "----- TAG: $tag -----"

#param collection
Deputs "Args:$args "
    foreach { key value } $args {
	   set key [string tolower $key]
	   switch -exact -- $key {
		  
		  -age {
				set age $value
		  }            
			-checksum {
				set checksum $value
		  }
		  -metric {
				set metric $value
		  }            
			-route_block {
				set route_block $value
		  }

	   }
    }
	
	if { [ info exists metric ] } {
		ixNet setA $handle -metric $metric
	}
	
	if { [ info exists route_block ] } {
	
		set routeBlock [ GetObject $route_block ]
		$route_block configure -handle $handle
		
		if { $routeBlock == "" } {
		
			return [GetErrorReturnHeader "No object found...-route_block"]
			
		}
		
		set num 		[ $routeBlock cget -num ]
		set start 		[ $routeBlock cget -start ]
		set step		[ $routeBlock cget -step ]
		set prefix_len	[ $routeBlock cget -prefix_len ]
		
		ixNet setM $handle \
			-mask $prefix_len \
			-firstRoute $start \
			-numberOfRoutes $num \
			-step $step
#		-enabled True
		
	} else {
	
		return [GetErrorReturnHeader "Madatory parameter needed...-route_block"]
	}
	
	ixNet commit
	
    return [GetStandardReturnHeader]
	
}

body SimulatedNssaRoute::config { args } {
    global errorInfo
    global errNumber
    set tag "body SimulatedNssaRoute::config [info script]"
Deputs "----- TAG: $tag -----"

#param collection
Deputs "Args:$args "
    foreach { key value } $args {
	   set key [string tolower $key]
	   switch -exact -- $key {
		  
		  -age {
				set age $value
		  }            
			-checksum {
				set checksum $value
		  }
		  -metric {
				set metric $value
		  }            
			-route_block {
				set route_block $value
		  }

	   }
    }
	
	if { [ info exists metric ] } {
		ixNet setA $handle -metric $metric
	}
	
	if { [ info exists route_block ] } {
	
		set routeBlock [ GetObject $route_block ]
		$route_block configure -handle $handle
		
		if { $routeBlock == "" } {
		
			return [GetErrorReturnHeader "No object found...-route_block"]
			
		}
		
		set num 		[ $routeBlock cget -num ]
		set start 		[ $routeBlock cget -start ]
		set step		[ $routeBlock cget -step ]
		set prefix_len	[ $routeBlock cget -prefix_len ]
		
		ixNet setM $handle \
			-mask $prefix_len \
			-firstRoute $start \
			-numberOfRoutes $num \
			-step $step
#		-enabled True
		
	} else {
	
		return [GetErrorReturnHeader "Madatory parameter needed...-route_block"]
	}
	
	ixNet commit
	
    return [GetStandardReturnHeader]
	
}

body SimulatedExternalRoute::config { args } {
    global errorInfo
    global errNumber
    set tag "body SimulatedExternalRoute::config [info script]"
Deputs "----- TAG: $tag -----"

#param collection
Deputs "Args:$args "
    foreach { key value } $args {
	   set key [string tolower $key]
	   switch -exact -- $key {
		  
		  -age {
				set age $value
		  }            
			-checksum {
				set checksum $value
		  }
		  -metric {
				set metric $value
		  }            
			-route_block {
				set route_block $value
		  }

	   }
    }
	
	if { [ info exists metric ] } {
		ixNet setA $handle -metric $metric
	}
	
	if { [ info exists route_block ] } {
	
		set routeBlock [ GetObject $route_block ]
		$route_block configure -handle $handle
		
		if { $routeBlock == "" } {
		
			return [GetErrorReturnHeader "No object found...-route_block"]
			
		}
		
		set num 		[ $routeBlock cget -num ]
		set start 		[ $routeBlock cget -start ]
		set step		[ $routeBlock cget -step ]
		set prefix_len	[ $routeBlock cget -prefix_len ]
		
		ixNet setM $handle \
			-mask $prefix_len \
			-firstRoute $start \
			-numberOfRoutes $num \
			-step $step
#		-enabled True
		
	} else {
	
		return [GetErrorReturnHeader "Madatory parameter needed...-route_block"]
	}
	
	ixNet commit
	
    return [GetStandardReturnHeader]
	
}

body SimulatedLinkRoute::config { args } {
    global errorInfo
    global errNumber
    set tag "body SimulatedLinkRoute::config [info script]"
Deputs "----- TAG: $tag -----"

#param collection
Deputs "Args:$args "
    foreach { key value } $args {
	   set key [string tolower $key]
	   switch -exact -- $key {
		  
		  -age {
				set age $value
		  }            
			-checksum {
				set checksum $value
		  }
		  -metric {
				set metric $value
		  }            
			-route_block {
				set route_block $value
		  }

	   }
    }
	
	if { [ info exists metric ] } {
		ixNet setA $handle -metric $metric
	}
	
	if { [ info exists route_block ] } {
	
		set routeBlock [ GetObject $route_block ]
		$route_block configure -handle $handle
		
		if { $routeBlock == "" } {
		
			return [GetErrorReturnHeader "No object found...-route_block"]
			
		}
		
		set num 		[ $routeBlock cget -num ]
		set start 		[ $routeBlock cget -start ]
		set step		[ $routeBlock cget -step ]
		set prefix_len	[ $routeBlock cget -prefix_len ]
		
		ixNet setM $handle \
			-mask $prefix_len \
			-firstRoute $start \
			-numberOfRoutes $num \
			-step $step
#		-enabled True
		
	} else {
	
		return [GetErrorReturnHeader "Madatory parameter needed...-route_block"]
	}
	
	ixNet commit
	
    return [GetStandardReturnHeader]
	
}

body SimulatedIntraAreaRoute::config { args } {
    global errorInfo
    global errNumber
    set tag "body SimulatedIntraAreaRoute::config [info script]"
Deputs "----- TAG: $tag -----"

#param collection
Deputs "Args:$args "
    foreach { key value } $args {
	   set key [string tolower $key]
	   switch -exact -- $key {
		  
		  -age {
				set age $value
		  }            
			-checksum {
				set checksum $value
		  }
		  -metric {
				set metric $value
		  }            
			-route_block {
				set route_block $value
		  }

	   }
    }
	
	if { [ info exists metric ] } {
		ixNet setA $handle -metric $metric
	}
	
	if { [ info exists route_block ] } {
	
		set routeBlock [ GetObject $route_block ]
		$route_block configure -handle $handle
		
		if { $routeBlock == "" } {
		
			return [GetErrorReturnHeader "No object found...-route_block"]
			
		}
		
		set num 		[ $routeBlock cget -num ]
		set start 		[ $routeBlock cget -start ]
		set step		[ $routeBlock cget -step ]
		set prefix_len	[ $routeBlock cget -prefix_len ]
		
		ixNet setM $handle \
			-mask $prefix_len \
			-firstRoute $start \
			-numberOfRoutes $num \
			-step $step
#		-enabled True
		
	} else {
	
		return [GetErrorReturnHeader "Madatory parameter needed...-route_block"]
	}
	
	ixNet commit
	
    return [GetStandardReturnHeader]
	
}