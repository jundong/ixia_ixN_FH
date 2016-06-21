package provide ipranlib 1.1
namespace eval ipranlib {
    #===========================================================================
    # ��������: stream_analyze
    # �������ܣ�������ҵ���ж�           
    # �������: stream_analyze_condition ������ҵ����ж��������磺"1/25/==0;26/68/<=50;69/92/<=200"
    # ����ֵ:   ��
    # �÷�ʾ��: stream_analyze -stream_analyze_condition "1/25/==0;26/68/<=50;69/92/<=200" 
    # �÷�ʾ��: stream_analyze -stream_analyze_condition $::case1_analyze1
    # �޸ļ�¼: 2015-12-07,����,����      				
    # ��ע�� 
    #===========================================================================
    proc stream_analyze {args} {
        global res
        global libname
        global ErrorInfo1
        global smbArr1
        set ::streamErrorInfo ""
        array set argsArr $args
        
        set num1 0
        #��������ȡ����ҵ���շ������
        array set smbArr1 [::${libname}::results_get -counter S:*.*]
        
        for {set j 1} {$j <= $::stream_num} {incr j} {
            global stream${j}
         
            if { [ catch { 
                set time${j} [expr [expr {$smbArr1([subst $[subst stream${j}]].TxFrameCount) - $smbArr1([subst $[subst stream${j}]].RxFrameCount)}] * 2 ] 
                # puts [subst $[subst stream${j}]]
                # ::${libname}::Logto -msg "������ [subst $[subst stream${j}]] ����ʱ��Ϊ[subst $[subst time${j}]] ms"	
                # if {$smbArr1([subst $[subst stream${j}]].TxFrameCount) >100 && $smbArr1([subst $[subst stream${j}]].RxFrameCount) ==0 } {
                     # ::${libname}::Logto -msg "Error Info:������ [subst $[subst stream${j}]]ҵ���ж�\n"
                     # append ::streamErrorInfo "Error Info:������ [subst $[subst stream${j}]]ҵ���ж�\n"
                     # set ::res fail
                     # fhlib::runtype
                     # incr num1
                # }
            } err ] } {
                append ::streamErrorInfo "Error Info:****��stream${j}���ڷ�������ͳ���У����ܵ��µ�ԭ����ARP/NDû�гɹ�!!!****\n"
                ::${libname}::Logto -msg "Error Info:****��stream${j}���ڷ�������ͳ���У����ܵ��µ�ԭ����ARP/NDû�гɹ�!!!****\n"
            } 
        }
        
        # ::${libname}::Logto -msg "Error Info:****����$num1 ��������ҵ���ж�!!!****\n"
        # append ::streamErrorInfo "Error Info:****����$num1 ��������ҵ���ж�!!!****\n"
             
        #����ж�����������ҵ�񶪰�ʱ����з����ж�
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
                    # ::${libname}::Logto -msg "OK!������ [subst $[subst stream${k}]]����ʱ������$aaa_condition ��Ҫ�󣬶���ʱ��Ϊ[subst $[subst time${k}]] ms\n"
                } else {
                    ::${libname}::Logto -msg "Error Info:������ [subst $[subst stream${k}]]����ʱ�䲻����$aaa_condition ��Ҫ�󣬶���ʱ��Ϊ[subst $[subst time${k}]] ms\n"
                    append ::streamErrorInfo "Error Info:������ [subst $[subst stream${k}]]����ʱ�䲻����$aaa_condition ��Ҫ�󣬶���ʱ��Ϊ[subst $[subst time${k}]] ms\n"
                    set ::res fail
                    fhlib::runtype
                    incr num2
                }			   
            }
        }
          
        ::${libname}::Logto -msg "Error Info:****����$num2 ������������ʱ�䲻����$aaa_condition ��Ҫ��!!!****\n"
        append ::streamErrorInfo "Error Info:****����$num2 ������������ʱ�䲻����$aaa_condition ��Ҫ��!!!****\n"
        ::${libname}::Logto -msg $::streamErrorInfo
    }
}