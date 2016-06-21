package provide ipranlib 1.1
namespace eval ipranlib {
    #===========================================================================
    # 函数名称: stream_analyze
    # 函数功能：数据流业务判定           
    # 输入参数: stream_analyze_condition 数据流业务的判定条件，如："1/25/==0;26/68/<=50;69/92/<=200"
    # 返回值:   无
    # 用法示例: stream_analyze -stream_analyze_condition "1/25/==0;26/68/<=50;69/92/<=200" 
    # 用法示例: stream_analyze -stream_analyze_condition $::case1_analyze1
    # 修改记录: 2015-12-07,汪丹,创建      				
    # 备注： 
    #===========================================================================
    proc stream_analyze {args} {
        global res
        global libname
        global ErrorInfo1
        global smbArr1
        set ::streamErrorInfo ""
        array set argsArr $args
        
        set num1 0
        #基于流获取数据业务收发包结果
        array set smbArr1 [::${libname}::results_get -counter S:*.*]
        
        for {set j 1} {$j <= $::stream_num} {incr j} {
            global stream${j}
         
            if { [ catch { 
                set time${j} [expr [expr {$smbArr1([subst $[subst stream${j}]].TxFrameCount) - $smbArr1([subst $[subst stream${j}]].RxFrameCount)}] * 2 ] 
                # puts [subst $[subst stream${j}]]
                # ::${libname}::Logto -msg "数据流 [subst $[subst stream${j}]] 丢包时间为[subst $[subst time${j}]] ms"	
                # if {$smbArr1([subst $[subst stream${j}]].TxFrameCount) >100 && $smbArr1([subst $[subst stream${j}]].RxFrameCount) ==0 } {
                     # ::${libname}::Logto -msg "Error Info:数据流 [subst $[subst stream${j}]]业务中断\n"
                     # append ::streamErrorInfo "Error Info:数据流 [subst $[subst stream${j}]]业务中断\n"
                     # set ::res fail
                     # fhlib::runtype
                     # incr num1
                # }
            } err ] } {
                append ::streamErrorInfo "Error Info:****流stream${j}不在返回数据统计中，可能导致的原因是ARP/ND没有成功!!!****\n"
                ::${libname}::Logto -msg "Error Info:****流stream${j}不在返回数据统计中，可能导致的原因是ARP/ND没有成功!!!****\n"
            } 
        }
        
        # ::${libname}::Logto -msg "Error Info:****共有$num1 条数据流业务中断!!!****\n"
        # append ::streamErrorInfo "Error Info:****共有$num1 条数据流业务中断!!!****\n"
             
        #逐个判定条件对数据业务丢包时间进行分析判定
        set condition $argsArr(-stream_analyze_condition)
        set each_condition [split $condition \;]
        set num2 0
        foreach single_condition $each_condition {
            set aaa [split $single_condition //]
            set aaa_min [lindex $aaa 0]
            set aaa_max [lindex $aaa 1]
            set aaa_condition [lindex $aaa 2]		
            for {set k $aaa_min} {$k <= $aaa_max} {incr k} {
                set analyze "\[subst \$\[subst time\$\{k\}\]\]"
                append analyze $aaa_condition
                if $analyze {
                    # ::${libname}::Logto -msg "OK!数据流 [subst $[subst stream${k}]]丢包时间满足$aaa_condition 的要求，丢包时间为[subst $[subst time${k}]] ms\n"
                } else {
                    ::${libname}::Logto -msg "Error Info:数据流 [subst $[subst stream${k}]]丢包时间不满足$aaa_condition 的要求，丢包时间为[subst $[subst time${k}]] ms\n"
                    append ::streamErrorInfo "Error Info:数据流 [subst $[subst stream${k}]]丢包时间不满足$aaa_condition 的要求，丢包时间为[subst $[subst time${k}]] ms\n"
                    set ::res fail
                    fhlib::runtype
                    incr num2
                }			   
            }
        }
          
        ::${libname}::Logto -msg "Error Info:****共有$num2 条数据流丢包时间不满足$aaa_condition 的要求!!!****\n"
        append ::streamErrorInfo "Error Info:****共有$num2 条数据流丢包时间不满足$aaa_condition 的要求!!!****\n"
        ::${libname}::Logto -msg $::streamErrorInfo
    }
}