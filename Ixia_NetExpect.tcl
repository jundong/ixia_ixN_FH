package require Expect

proc ExLogin {host port user pw} {
    global spawn_id
    global expect_out

    spawn telnet $host $port
	after 2000
    send "\r"
    expect -re "(.*)username:" { send "$username\r" }
    expect -re "(.*)password:" { send "$password\r" }
    expect -re "(.*)%" { 
	send "enable\r" 
	expect -re "(.*)#"
    }
    expect -re "(.*)#" { 
	send "\r"
    }
    if {[string bytelength $expect_out(buffer)] > 0} {
	for {set i 0} {$i < 3} {incr i} {
			sendCmd "inhibit msg all"
			after 2000
		}
    } else {
    }
}

proc ExLogout {} {
    global spawn_id
    global expect_out
    sendCmd "allow msg all"
    atfLog::log4e "Logout the BLM... "	
    sendCmd  "exit"
    log_file
    return 0
}

proc sendCmd {cmd} {
    global spawn_id
    global expect_out
    expect * 
	match_max 70000
    set prebuffer ""
    exp_send "$cmd\r"
    expect {
    	timeout {atfLog::error4e "Send command \"$cmd\" to BLM timeout"; exp_continue}
		-re "Continue*" {
			append prebuffer $expect_out(buffer)
			after 2000
			send "all\r"
			after 2000
			exp_continue
		    }
		-re "(error)(.*)#" {atfLog::error4e "Encountering an error when sending command \"$cmd\" to BLM"}		
    	-re "(.*)%" {}
    	-re "(.*)#" {  
			if { $prebuffer != ""} {
				append prebuffer $expect_out(buffer)
				set expect_out(buffer) $prebuffer
			}
		    }    	
		-re "(.*)lost" {}
    }
	
}