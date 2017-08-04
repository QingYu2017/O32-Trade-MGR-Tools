'Auth:Qing.Yu
'Mail:1753330141@qq.com
' Ver:V1.3
'Date:2017-08-01

on error resume next
'net use \\xxx.xx.xx.33\c$ /delete

dim wshshell
set wshshell = createobject("wscript.shell")

dateStr=year(now) & right("0" & month(now),2) & right("0" & day(now),2)
Set fso = CreateObject("Scripting.FileSystemObject")
if not fso.DriveExists("D:") then
	mapFolder "D:","\\xx.xxx.xx.154\d$","administrator","xxxxxxxx"
end if
if not fso.FolderExists("D:\Trade\" & dateStr) then
	set desFolder=fso.CreateFolder("D:\Trade\" & dateStr)
	else 
	set desFolder=fso.GetFolder("D:\Trade\" & dateStr)
end if 

'映射EzSR取上交所行情
mapFolder "G:","\\xxx.xx.xx.33\c$\EzSR_DATA","administrator","xxxxxxxxx"
'复制上交所行情文件
fso.CopyFile "G:\mktdt00.txt", desFolder.path & "\mktdt00.txt"
fso.CopyFile "G:\mktdt03.txt", desFolder.path & "\mktdt03.txt"
'映射biTransClientV3取fjy
mapFolder "G:","\\xxx.xx.xx.33\c$\biTransClientV3\Data\shfile","administrator","xxxxxxxxx"
'复制非交易资讯
fso.CopyFile "G:\fjy" & dateStr &".txt", desFolder.path & "\fjy" & dateStr &".txt"
'映射FxClient取深交所行情
mapFolder "G:","\\xxx.xx.xx.51\c$\Users\Administrator\Desktop\FxClient\temp\F000000X0001","administrator","xxxxxxxxx"
'复制深交所行情文件
fso.CopyFile "G:\cashsecurityclosemd_" & dateStr & ".xml", desFolder.path & "\cashsecurityclosemd_" & dateStr & ".xml"
fso.CopyFile "G:\securities_" & dateStr & ".xml", desFolder.path & "\securities_" & dateStr & ".xml"
fso.CopyFile "G:\issueparams_" & dateStr & ".xml", desFolder.path & "\issueparams_" & dateStr & ".xml"
'映射EzTrans取上交所过户
mapFolder "G:","\\xxx.xx.xx.34\c$\EzTrans_Data","administrator","xxxxxxxxx"
'等待文件拷贝结束
sleep(3000)
'解压缩GH文件
wshshell.exec "c:\Program Files\WinRAR\WinRAR.exe x " & desFolder.path & "\*.zip " & desFolder.path & " -o+"
'复制上交所过户文件夹
fso.CopyFolder "G:\" & dateStr, desFolder.path
'wshshell.exec "c:\Program Files\WinRAR\WinRAR.exe x " & "G:\" & dateStr & "\*.zip " & desFolder.path & " -o+"
'映射PROP沪中登清算文件
mapFolder "G:","\\xxx.xx.xx.41\c$\prop2000\mailbox","administrator","xxxxxxxxx"
'复制PROP沪中登清算文件
fso.CopyFolder "G:\" & dateStr, desFolder.path
'映射D-COM取深中登清算
mapFolder "G:","\\xxx.xx.xx.57\c$\DownloadFiles","administrator","xxxxxxxxx"
'复制D-COM数据
fso.CopyFolder "G:\" & dateStr, desFolder.path
'复制清算数据到估值
fso.CopyFolder "D:\Trade\" & dateStr, "D:\Hundsun\招商\" & dateStr

sub mapFolder(drv,pathStr,usr,usrpwd)'"Y:","\\xxx.xx.xx.33\EzSR_DATA"
	'on error resume next
	Set WshNetwork = WScript.CreateObject("WScript.Network")
	'删除已有映射
	if fso.DriveExists(drv) then
		WshNetwork.RemoveNetworkDrive drv
	end if
	'添加映射
	WshNetwork.MapNetworkDrive drv, pathStr,false,usr,usrpwd
end sub
