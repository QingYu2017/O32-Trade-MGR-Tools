'Auth:Qing.Yu
'Mail:1753330141@qq.com
' Ver:V1.5
'Date:2018-03-14
'更新EzSR行情文件访问账号，更新5002转换机监控的日志文件名称

on error resume next

Set args = WScript.Arguments
'如果有参数则使用参数，如果没有则设置缺省参数auto
if args.count>=1 then
	arg=args(0)
	else
	arg="auto"
end if
'根据参数确定如何执行，start为启动，stop为停止，如果是缺省参数auto，则根据时间判断启动或停止
select case arg
	case "start"
		startProc
	case "stop"
		stopProc
	case else
		if hour(now)>=16 then
			stopProc
			else
			startProc
		end if
end select
	
sub startProc()
	'先关闭所有进程
	stopProc
	'映射EzSR落地行情数据
	mapEzSRData
	'从指定路径启动5002/5006/5008转换机任务,注意添加路径信息（第二个变量），否则会出现无法加载配置信息的情况
	set process = GetObject("winmgmts:Win32_Process")
	r5002 = process.Create ("D:\newtran5002\procmaintran.exe","D:\newtran5002\",null,pid5002)
	r5006 = process.Create ("D:\newtran5006\procmaintran.exe","D:\newtran5006\",null,pid5006)
	r5008 = process.Create ("D:\newtran5008\procmaintran.exe","D:\newtran5008\",null,pid5008)
	'读取5002转换机日志，ZBX开始监控
	mapProcLog
end sub

sub stopProc()
	'遍历当前进程，并根据进程名/进程路径，强制结束当前任务
	strComputer = "."
	Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
	Set colProcessList = objWMIService.ExecQuery("SELECT * FROM Win32_Process")
	'遍历当前进程，如读取到转换机任务/子任务，终止进程
	For Each objProcess in colProcessList
		'考虑改为用ExecuteablePath进行控制
		if objProcess.name="procmaintran.exe" then
			objProcess.terminate
		end if
	next
end sub

sub mapEzSRData()
	on error resume next
	Set WshNetwork = WScript.CreateObject("WScript.Network")
	'删除已有映射
	WshNetwork.RemoveNetworkDrive "Y:"
	'添加映射
	WshNetwork.MapNetworkDrive "Y:", "\\xxx.xx.xx.33\EzSR_DATA",false,"trade","trade_password"
end sub

sub mapProcLog()
	Set WshShell = WScript.CreateObject("WScript.Shell")
	Set fso = CreateObject("Scripting.FileSystemObject")
	datestr=year(now) & "-" & right("0" & month(now),2) & "-" & right("0" & day(now),2)
	logfile="d:\ProcLog_Current\procmaitran5002.log"
	'删除已有日志
	If (fso.FileExists(logfile)) Then
		fso.DeleteFile logfile,true
	end if
	'映射日志文件
	WshShell.Run "fsutil hardlink create d:\ProcLog_Current\procmaitran5002.log d:\newtran5002\Logs\Log(" & datestr &")@行情转换机-5002.log"
end sub

