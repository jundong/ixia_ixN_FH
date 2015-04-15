#=========================================================================
# 版本号：2.4
# 文件名：Ixia.tcl
# 文件描述：IxiaHL库初始化文件，当用户输入 "package require IxiaHL" 调用此文件
# 作者：李霄石(Shawn Li)
# 创建时间: 2010.03.30
# 修改记录：
#			2010.4.22 by Shawn
#			1）删除名字空间 
#			2）修改全局变量定义格式
#			3）添加env(IXIA_VERSION)以及TRAFFICGEN全局变量
#			2010.6.28
#			1) 修改加载IxP路径
# 版权所有：Ixia
#====================================================================================
#================================
#加载定义的各种类以及类成员函数
set currDir [file dirname [info script]]
source [file join $currDir Ixia_Util.tcl]
source [file join $currDir Ixia_CTester.tcl]
source [file join $currDir Ixia_CPort.tcl]
source [file join $currDir Ixia_CTraffic.tcl]
source [file join $currDir Ixia_CFilter.tcl]
source [file join $currDir Ixia_CCapture.tcl]
source [file join $currDir Ixia_CRoutingMisc.tcl]
source [file join $currDir Ixia_CBgp.tcl]
source [file join $currDir Ixia_COspf.tcl]
source [file join $currDir Ixia_CIsis.tcl]
#=============================
#设置加载IxiaHL所需的环境变量
if {[catch {
   #===================================================
   #-- modified by Eric for suitbale for multi-versions
   #===================================================
   #set oskey         {HKEY_LOCAL_MACHINE\SOFTWARE\Ixia Communications\IxOS} ;#ixos的注册表key值
   #set ossubkey      [registry keys $oskey]                                 ;#ixos在注册表中的subkey值
   #set installinfo   [append oskey \\ $ossubkey \\ InstallInfo]             ;#installinfo的key值
   #set ospath        [registry get $installinfo  HOMEDIR]                   ;#ixos的安装路径
   #--end modify
IxDebugOn   
   set oskey         {HKEY_LOCAL_MACHINE\SOFTWARE\Ixia Communications\IxOS} ;#ixos的注册表key值
   set ossubkey      [ lindex [registry keys $oskey] end ]                  ;#ixos在注册表中的subkey值,注意要求机器只安装一个os版本
   set installinfo   [append oskey \\ $ossubkey \\ InstallInfo]             ;#installinfo的key值
   set ospath        [registry get $installinfo  HOMEDIR]                   ;#ixos的安装路径
Deputs "ospath:$ospath"
   set ixnkey        {HKEY_LOCAL_MACHINE\SOFTWARE\Ixia Communications\IxNetwork} ;#ixnetwork的注册表key值
   set versionCount  [ llength [ registry keys $ixnkey ] ]
   if { $versionCount == 1 } {
      set ixnsubkey 		 [lindex [registry keys $ixnkey] 0]
   } else {
      set ixnsubkey 		 [lindex [registry keys $ixnkey] [ expr $versionCount - 2 ] ]      
   }
   set ixninstallinfo [append ixnkey \\$ixnsubkey \\ InstallInfo]                       
   set ixnpath       [registry get $ixninstallinfo HOMEDIR]                      ;#ixnetwork的安装路径
Deputs "ixnpath:$ixnpath"
   set ixpkey        {HKEY_LOCAL_MACHINE\SOFTWARE\Ixia Communications\IxNProtocols} ;#ixnprotocol的注册表key值
   set versionCount  [ llength [ registry keys $ixpkey ] ]
   if { $versionCount == 1 } {
      set ixpsubkey 		 [lindex [registry keys $ixpkey] 0]
   } else {
      set ixpsubkey 		 [lindex [registry keys $ixpkey] [ expr $versionCount - 2 ] ]
   }
   set ixpinstallinfo [append ixpkey \\$ixpsubkey \\ InstallInfo]                       
   set ixppath       [registry get $ixpinstallinfo HOMEDIR]                      ;#ixnprotocol的安装路径
Deputs "ixppath:$ixppath"   
   set ixhltkey      {HKEY_LOCAL_MACHINE\SOFTWARE\Ixia Communications\hltapi} ;#HLTAPI的注册表key值
   set ixhltsubkey 	 [lindex [registry keys $ixhltkey] 0]
   set ixhltinstallinfo [append ixhltkey \\$ixhltsubkey \\ InstallInfo]                       
   set ixhltpath       [registry get $ixhltinstallinfo HOMEDIR]               ;#HLTAPI的安装路径
Deputs "ixhltpath:$ixhltpath" 
   #=======================================
   #修改tcl解释器auto_path以及env(path)变量   
   #lappend auto_path $ospath
   lappend auto_path [file join $ospath "TclScripts/lib"]
   lappend auto_path [file join $ospath "TclScripts/lib/IxTcl1.0"]
   append  env(PATH) ";${ospath}"
   #append  env(PATH) [format ";%s" [file join $ospath "../.."]]
   lappend auto_path [file join $ixnpath "TclScripts/Lib/IxTclNetwork"]
   #==========================================
   #修改auto_path变量，使其能加载IxTclProtocol
   lappend auto_path [file join $ixppath "TclScripts/Lib/IxTclProtocol"]
   append  env(PATH) ";${ixppath}"
   lappend auto_path [file join $ixhltpath "TclScripts/lib/hltapi"]
   
   #===========
   #加载HLTAPI
   package require Ixia
  
   } gErrMsg]} {
   error "Error: $gErrMsg."
}


#=================================================================
#此环境变量定义了HLTAPI使用那套API，也可以参考HLTAPI release note
#env(IXIA_VERSION) HLT IxOS IxRouter IxNetwork IxAccess IxLoad 
#HLTSET70 4.00 GA Patch1 5.60 GA Patch1 N/A 5.50 SP1 (P) N/A 5.0 EA Patch1 
#HLTSET71 4.00 GA Patch1 5.60 GA Patch1 N/A 5.50 SP1 (N) N/A 5.0 EA Patch1 
#HLTSET72 4.00 GA Patch1 5.60 GA Patch1 N/A 5.50 SP1 (NO) N/A 5.0 EA Patch1 
#HLTSET73 4.00 GA Patch1 5.60 GA Patch1 N/A 5.50 EA SP1 (P2NO) N/A 5.0 EA Patch1 
#HLTSET74 4.00 GA Patch1 5.70 EA EA SP1 N/A 5.60 EA(P)(*) N/A 5.10 EA(*) 
#HLTSET75 4.00 GA Patch1 5.70 EA EA SP1 N/A 5.60 EA(N)(*) N/A 5.10 EA(*) 
#HLTSET76 4.00 GA Patch1 5.70 EA EA SP1 N/A 5.60 EA(NO)(*) N/A 5.10 EA(*) 
#HLTSET77 4.00 GA Patch1 5.70 EA EA SP1 N/A 5.60 EA(P2NO)(*) N/A 5.10 EA(*) 
set env(IXIA_VERSION) HLTSET74

#============
#定义全局变量  
set ::SUCCESS 1
set ::FAILURE 0
set ::VERSION 2.4
set TRAFFICGEN "ixos"
set PORTLIST   ""
set TXPORTLIST ""
set RXPORTLIST ""
set CAPPORTLIST ""
set OBJECTLIST  ""
set CAPFILENAME	""

#======================================
#将所有IxiaHL空间下的命令导入到全局空间
package provide IxiaHL $::VERSION