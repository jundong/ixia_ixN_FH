
# Copyright (c) Ixia technologies 2010-2011, Inc.

# Release Version 1.3
#===============================================================================
# Change made
# Version 1.0 
#       1. Create
# Version 1.1
#       1. If the specified CSV file of RFC2544 with the same path, when run a number of times,
#          results additional to the before of previous record.
# Version 1.2
#       1. Rfc2544.config change -streams into lappend trafficSelection $stream
# Version 1.3
#       1. Rfc2544 add testtype throughput frameloss back2back
class Rfc2544 {
    inherit NetObject
    
    constructor {} {}
	method reborn { } {}
    method throughput { args} {}
    method frameloss { args } {}
    method back2back { args } {}
    method config { args } {}
	method unconfig {} {
		chain
		catch { 
			delete object $this.traffic
		}
	}
	
    #trafficSelection - inTest
    public variable trafficSelection
    #trafficSelection - background
    public variable trafficBackground
    public variable testtype
}

body Rfc2544::reborn { } {
    set tag "body Rfc2544::reborn [info script]"
    Deputs "----- TAG: $tag -----"
    Deputs "Rfc2544 $testtype testing"

	if { [ info exists handle ] == 0 || $handle == "" } {
		set root [ixNet getRoot]
        if { $testtype == "rfcthroughput" } {
		    set handle [ ixNet add $root/quickTest rfc2544throughput ]
        } elseif { $testtype == "rfcback2back" } {
            set handle [ ixNet add $root/quickTest rfc2544back2back ]
        } elseif { $testtype =="rfcframeloss" } {
            set handle [ ixNet add $root/quickTest rfc2544frameLoss ]
        }
		ixNet setA $handle -name $this -mode existingMode
		ixNet commit
		set handle [ixNet remapIds $handle]
		ixNet setA $handle/testConfig -frameSizeMode fixed
		ixNet commit
	}
}


body Rfc2544::constructor {} {
    
    set tag "body Rfc2544::ctor [info script]"
    Deputs "----- TAG: $tag -----"
    set testtype "rfcthroughput"
    
    
	#reborn 
}


body Rfc2544::config { args } {
    
    global errorInfo
    global errNumber
    set tag "body Rfc2544::config [info script]"
    Deputs "----- TAG: $tag -----"
    	
    set frame_len_type custom
    set load_unit percent
    set duration 30
    set resolution 1
    set trial 1
    set traffic_mesh fullmesh
    set bidirection 1
    set traffic_type L2
    set latency_type LILO
    set measure_jitter 0
    set resultdir "d:/1"
    set resultfile "1.csv"
    set inter_frame_gap 12
	set no_run 0

    foreach { key value } $args {
        set key [string tolower $key]
        switch -exact -- $key {
        	-frame_len {
				if { [ llength $value ] < 1 } {
					 error "$errNumber(1) key:$key value:$value"
				 } else {
					set frame_len $value
Deputs "frame len under test:$frame_len"			 
				 }
        	}
			-dif_len_type -
			-frame_len_type {
				set frame_len_type $value
			}
        	-port_load {
				if { [ llength $value ] < 3 } {
					error "$errNumber(1) key:$key value:$value"
				} else {
					set port_load $value
				}
        	}
        	-load_unit {
        		set load_unit $value
        	}
        	-duration {
        		set duration $value
        	}
        	-resolution {
        		set resolution $value
        	}
        	-trial {
        		set trial $value
        	}
        	-upstream {
				foreach stream $value {
					if { [ $stream isa Traffic ] } {
						set upstream $value
					} else {
						error "$errNumber(1) key:$key value:$value"
					}
				}
        	}
        	-downstream {
				foreach stream $value {
					if { [ $stream isa Traffic ] } {
						set downstream $value
					} else {
						error "$errNumber(1) key:$key value:$value"
					}
				}
        	}
			-streams {
				foreach stream $value {
					if { [ $stream isa Traffic ] } {
						set teststream $value
					} else {
						error "$errNumber(1) key:$key value:$value"
					}
				}
			}
        	-traffic_mesh {
        		set traffic_mesh $value
        	}
        	-src_endpoint {
        		set src_endpoint $value
        	}
        	-dst_endpoint {
        		set dst_endpoint $value
        	}
        	-bidirection {
        		set bidirection $value
        	}
        	-bg_traffic {
        		set bg_traffic $value
        	}
        	-traffic_type {
        		set traffic_type $value
        	}
        	-latency_type {
        		set latency_type $value
        	}
        	-measure_jitter {
				set trans [ BoolTrans $value ]
				if { $trans == "1" || $trans == "0" } {
					set measure_jitter $value
				} else {
					error "$errNumber(1) key:$key value:$value"
				}
        	}
			-resultdir {
				set resultdir $value
			}
			-resultfile {
                	set resultfile $value
        	}
        	-inter_frame_gap {
        		set inter_frame_gap $value
        	}
			-no_run {
				set no_run $value
			}
        	default {
        	    error "$errNumber(3) key:$key value:$value"
        	}
		}
    }
	
    # reborn
    if { [ info exists handle ] == 0 || $handle == "" } {
Deputs "Step10"
		reborn
    }
Deputs "Step20"	
    if { [ info exists frame_len ] == 0 } {
Deputs "Step30"
    	error "$errNumber(2) key:frame_len"
    } 
	
    set trafficSelection [list]
Deputs "Step40"
    if { [ info exists upstream ] && [ info exists downstream ] } {
Deputs "Step41"
		#-- add existing traffic item
		foreach stream $upstream {
			set upTs [ ixNet add $handle trafficSelection ]
	Deputs "upTs:$upTs"
			ixNet setM $upTs \
				-id [ $stream cget -handle ] \
				-includeMode inTest \
				-itemType trafficItem \
				-type upstream
			set upTs  [ ixNet remapIds $upTs ]
			lappend trafficSelection $stream 
		}
		foreach stream $downstream {
			set dnTs [ ixNet add $handle trafficSelection ]
	Deputs "dnTs:$dnTs"		
			ixNet setM $dnTs \
				-id [ $stream cget -handle ] \
				-includeMode inTest \
				-itemType trafficItem \
				-type downstream
			ixNet commit
			
			set dnTs  [ ixNet remapIds $dnTs ]
			
			lappend trafficSelection $stream 
		}
    } elseif { [ info exists src_endpoint ] && [ info exists dst_endpoint ] } {
Deputs "Step42"
	    #-- add new traffic item
		set stream $this.traffic
	    Traffic $stream [ [ lindex $src_endpoint 0 ] cget -portObj ]
		
		if { [ string tolower $traffic_type ] == "l2" } {
			set trafficType ethernetVlan
		} else {
			set trafficType ipv4
		}
Deputs "traffic type:$trafficType"		
	    $this.traffic config \
			-src $src_endpoint -dst $dst_endpoint \
			-traffic_type $trafficType -bidirection $bidirection
		set ts [ ixNet add $handle trafficSelection ]
		ixNet setM $ts \
			-id [ $stream cget -handle ] \
			-includeMode inTest \
			-itemType trafficItem 
	    lappend trafficSelection $this.traffic
	    #-- following args will be added to Traffic.set
#	    if { [ info exists traffic_mesh ] } {
#	    }
#	    if { [ info exists traffic_type ] } {
#	    }
#	    if { [ info exists bidirection ] } {
#	    }
    } else {
Deputs "Step43"
		if { [ info exists teststream ] } {
			foreach stream $teststream {
Deputs "streams :$stream"
				set ts [ ixNet add $handle trafficSelection ]
				ixNet setM $ts \
					-id [ $stream cget -handle ] \
					-includeMode inTest \
					-itemType trafficItem
				ixNet commit
				lappend trafficSelection $stream
			}		
			#lappend trafficSelection $teststream
		} else {
			error "$errNumber(2) key:upstream/downstream src_endpoint/dst_endpoint"
		}
    }
	    
Deputs "Step50"
    if { [ info exists bg_traffic ] } {
	    #-- add bg traffic
	    foreach stream $bg_traffic {
Deputs "bg_traffic :$stream"
        	    set ts [ ixNet add $handle trafficSelection ]
        	    ixNet setM $ts \
                        -id [ $stream cget -handle ] \
                        -includeMode background \
        		-itemType trafficItem
        	    ixNet commit
	    }
		lappend trafficBackground $bg_traffic
    }
Deputs "Step60"
    if { [ info exists latency_type ] } {
    	switch $latency_type {
            lifo {
            	set latency_type storeForward
            }
    	    lilo {
    	    	set latency_type forwardingDelay
    	    }
    	    filo {
    	    	set latency_type mef
    	    }
    	    fifo {
    	    	set latency_type cutThrough
    	    }
    	}
		set root [ ixNet getRoot ]
    	ixNet setA $root/traffic/statistics/latency -mode $latency_type
    	ixNet commit
		ixNet setA $handle/testConfig -latencyType $latency_type
		ixNet commit
    }
Deputs "Step70"
    if { [ info exists frame_len_type ] } {
Deputs "Step71"	
Deputs "frame len type:$frame_len_type"
    	switch $frame_len_type {
			custom {
Deputs "Step73"			
                ixNet setA $handle/testConfig -frameSizeMode custom
				ixNet commit
Deputs "Step74"				
				ixNet setA $handle/downstreamConfig -downstreamFrameSizeMode custom
				ixNet setA $handle/upstreamConfig -upstreamFrameSizeMode custom
				ixNet commit
Deputs "Step75"
Deputs "frame len:$frame_len len:[ llength $frame_len ]"		
                set customLen ""
                foreach len $frame_len {
                	set len [string trim $len]
                	set customLen "$customLen,$len"
                }
                set customLen [ string range $customLen 1 end ]
Deputs "handle:$handle custom len:$customLen"
                ixNet setA $handle/testConfig -framesizeList $customLen
                ixNet setA $handle/downstreamConfig -downstreamFramesizeList $customLen
                ixNet setA $handle/upstreamConfig -upstreamFramesizeList $customLen
                ixNet commit
            }
            imix {
Deputs "Step72"
                foreach traffic $trafficSelection {
                    set el [$traffic cget -highLevelStream]
					foreach stream $el {
						ixNet setM $stream/frameSize \
							-weightedPairs $frame_len \
							-type weightedPairs
					}
                    ixNet commit
                }
            }
			random {
                ixNet setM $handle/testConfig \
					-frameSizeMode random \
					-minRandomFrameSize [ lindex $frame_len 0 ] \
					-maxRandomFrameSize [ lindex $frame_len end ]
				ixNet commit
			}
    	}
    }
Deputs "Step80"	
    if { [ info exists inter_frame_gap ] } {
Deputs "traffic selection: $trafficSelection len: [ llength $trafficSelection ]"	
	    foreach traffic $trafficSelection {
		    set el [$traffic cget -highLevelStream]
			foreach highLevelStream $el {
				ixNet setA $highLevelStream/transmissionControl -minGapBytes $inter_frame_gap 
			}
		    ixNet commit
	    }
    }
	
Deputs "Step90"
    if { [ info exists port_load ] } {
	    set port_load_init [ lindex $port_load 0 ]
	    set port_load_min  [ lindex $port_load 1 ]
	    set port_load_max  [ lindex $port_load 2 ]
	    ixNet setM $handle/testConfig \
	    	-binarySearchType perPort \
	    	-initialBinaryLoadRate $port_load_init \
		    -minBinaryLoadRate $port_load_min \
		    -maxBinaryLoadRate $port_load_max
    }
Deputs "Step100"	
    if { [ info exists load_unit ] } {
	    set load_unit [ string tolower $load_unit ]
	    switch $load_unit {
		    fps {
		    	set load_unit fpsRate
		    }
		    mbps {
		    	set load_unit mbpsRate
		    }
		    kbps {
		    	set load_unit kbpsRate
    		    }
		    percent {
		    	set load_unit percentMaxRate
		    
		    }
		    default {
		    	set load_unit percentMaxRate
			    
			    
		    }
		   
	    }
	    ixNet setA $handle/testConfig  -binaryLoadUnit $load_unit
    }
	
Deputs "Step110"
    if { [ info exists duration ] } {
	    ixNet setA $handle/testConfig -duration $duration
    }
Deputs "Step120"   
    if { [ info exists measure_jitter ] } {
		if { $measure_jitter } {
			ixNet setA $handle/testConfig -calculateJitter True
		} else {
			ixNet setA $handle/testConfig -calculateJitter False
		}
    }
	
Deputs "Step130"
    if { [ info exists resolution ] } {
	    ixNet setA $handle/testConfig -resolution $resolution
    }
Deputs "Step140"	
    if { [ info exists trial ] } {
	    ixNet setA $handle/testConfig -numtrials $trial
    }
	
Deputs "Step150"
# enable latency
	ixNet setM $handle/testConfig \
		-calculateLatency True
    ixNet commit
	if { !$no_run } {
		ixNet exec apply $handle
		ixNet exec run $handle
		ixNet exec waitForTest $handle
	}
	catch { 
		delete object $this.traffic
	}

	if { [ info exists resultdir ] } {
		set path [ ixNet getA $handle/results -resultPath ]
Deputs "path:$path"
		if { [ catch {
			file copy $path $resultdir
		} err ] } {
Deputs "err:$err"
		}
		if { [ info exists resultfile ] } {
		    if { [file exists $resultdir/$resultfile ] } {
			    if { [ catch {
                   
                    set rfile [ open $resultdir/$resultfile r ]
                    set rpattern [ read -nonewline $rfile ]
					close $rfile 
				    file delete $resultdir/$resultfile
					file copy $path/results.csv $resultdir/$resultfile
					set apdfile [ open $resultdir/$resultfile a ]
					puts $apdfile "\n"
                    puts $apdfile $rpattern
                    flush $apdfile
                    close $apdfile
                 
				} err ] } {
				    return [GetErrorReturnHeader $err]
			        }
			} else {				
			    if { [ catch {
				    file copy $path/results.csv $resultdir/$resultfile
			    } err ] } {
				return [GetErrorReturnHeader $err]
			        }
			    }
		}	
	}
	
    return [GetStandardReturnHeader]

}

body Rfc2544::throughput { args } {
    set testtype "rfcthroughput"
    reborn
    eval config $args
}

body Rfc2544::frameloss { args } {
    set testtype "rfcframeloss"
    reborn
    eval config $args
}

body Rfc2544::back2back { args } {
    set testtype "rfcback2back"
    reborn
    eval config $args
}

class Async2544 {
	inherit Rfc2544
	
	method reborn {} {}
	method config { args } {}
}

body Async2544::reborn {} {
    set root [ixNet getRoot]
    set handle [ ixNet add $root/quickTest asymmetricThroughput ]
    ixNet setA $handle -name $this -mode existingMode
    ixNet commit
    set handle [ixNet remapIds $handle]
	ixNet setA $handle/downstreamConfig -downstreamFrameSizeMode unchanged
	ixNet setA $handle/upstreamConfig -upstreamFrameSizeMode unchanged
	ixNet commit
}

body Async2544::config { args } {

    global errorInfo
    global errNumber
    set tag "body Async2544::config [info script]"
    Deputs "----- TAG: $tag -----"

	set frame_len_type custom
	set no_run 0
	
    foreach { key value } $args {
        set key [string tolower $key]
        switch -exact -- $key {
        	-streams {
				set streams $value
				set index [ lsearch $args $key ]
				set args [ lreplace $args $index [ expr $index + 1 ] ]
			}
		}
	}	

	if { [ info exists streams ] } {
		eval chain { -streams $streams -no_run 1 } $args
	} else {
		eval chain -no_run 1 $args
	}

	if { !$no_run } {
		ixNet exec apply $handle
		ixNet exec run $handle
		ixNet exec waitForTest $handle
	}
	
    return [GetStandardReturnHeader]
}

