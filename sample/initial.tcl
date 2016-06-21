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
lappend auto_path $FHLib_PATH
package require fhlib 

puts >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


if {[catch {

puts "调烽火的库LoadLib加载指定的仪表库"
fhlib::loadlib -type $::type


puts "1.加载仪表自动化软件包"
package require $libname
::${libname}::Logto -level debug -msg "1.加载仪表自动化软件包"
	
puts "2.加载仪表库函数"
${libname}::instrument_info_load -version $version
::${libname}::Logto -msg "2.加载仪表库函数"


puts "5.导入仪表配置"
::${libname}::Logto -msg "5.导入仪表配置"
set instrument_config_file_dir [join [lreplace [split $dir /] end end instrument_config_file] /]
# set instrument_config_file_dir [join [lreplace [split $dir /] end-1 end] /]

if {$type == "STC"} {
     set configfile $instrument_config_file_dir/initial.xml
} else {
         set configfile $instrument_config_file_dir/initial.ixncfg
     }
${libname}::instrument_config_init -configfile $configfile

puts "6.占用端口"
::${libname}::Logto -msg "6.占用端口"
${libname}::port_reserve -port "$B29_30_A73_76_A79_82  $B25_26_A65_A68    $B27_28_A48_A51_A54_57  $RNC_8_13"  -offline 0
fhlib::sleep 10

puts "7.起device"
::${libname}::Logto -msg "7.起device..."
${libname}::device_start 
::${libname}::Logto -msg "等待$::device_wait_time秒..."
fhlib::sleep $::device_wait_time

set plink_path [join "[lreplace [split $dir /] end-1 end]" /]

} err]} {
    ::${libname}::Logto -msg "Error Info: $err"
	::${libname}::Logto -msg "\nTest Result: wrong"
	exit
} else {
	    ::${libname}::Logto -msg "\nTest Result: correct"
	   } 

