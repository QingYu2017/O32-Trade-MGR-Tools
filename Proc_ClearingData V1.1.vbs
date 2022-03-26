'Auth:Qing.Yu
'Mail:1753330141@qq.com
' Ver:V1.1
'Date:2022-03-24
'清算文件解压缩处理
'由于中信测试文件合并，修改文件解压缩路径

Dim oShell
Set oShell = CreateObject ("WScript.shell")
'提取当前业务日期，可手动赋值测试历史日期数据
curBizDate =  year(date) & right("00" & month(date),2) & right("00" & day(date),2)
'curBizDate = "20220323"
'定义RAR文件路径
rar = """c:\Program Files\WinRAR\WinRAR.exe"""
'路径定义，压缩文件存放路径，和解压缩文件写入路径
root_source = "E:\S_ClearingData\"
root_des = "E:\S_ClearingData\"

'定义当前清算文件名和目标路径
accounts = array(_
    "仿真712020xxxx|",_
    "712020xxxx-|",_
    "SXXX投资|")

'传入文件名，剔除当前业务日期后，返回匹配的子目录名
function get_folder(filename)
    'WScript.echo d
    keyinfo = replace(filename, curBizDate, "")
    des_path = "None"
    'wscript.echo "keyinfo is "&keyinfo
    for each account in accounts
        if keyinfo = split(account,"|")(0) then
            des_path = split(account,"|")(1)
            'WScript.echo account
            exit for
        end if
    next
    'WScript.echo filename
    get_folder = des_path
end function

'处理文件解压缩
sub proc_file(filepath)
    path_source = filepath
    filename = split(path_source,"\")(ubound(split(path_source,"\")))
    'wscript.echo "文件名是："&filename
    '注意要去掉文件扩展名
    sub_folder = get_folder(left(filename,len(filename)-4))
    'wscript.echo "子目录名是："&sub_folder
    if sub_folder <> "None" then
        path_des = root_des & curBizDate & "\" & sub_folder & "\"
        path_des = replace(path_des,"\\","\")
        oShell.run rar & " e -o+ " & path_source & " " & path_des, 0, True
    end if
end sub

Set oFso = CreateObject("Scripting.FileSystemObject") 
sPath = oFso.getFolder(".").path
'msgbox(sPath)
sPath = root_source
Set oFolder = oFso.GetFolder(sPath)  
Set oFiles = oFolder.Files  
For Each oFile In oFiles  
	'WScript.Echo oFile.Path  
    proc_file oFile.path
next

wscript.sleep 3

'新建market_data目录
oFso.createfolder(root_des & "\market_data")
'获取hq目录，移动到market_data目录的日期目录中
set hq = oFso.getFolder(root_source & "hq")
hq.move root_des & "market_data\" & curBizDate

'压缩当天文件
oShell.run rar & " m -ep1 " & root_source & "\" & curBizDate & " " & root_des & "\" & curBizDate & " " & root_source & "market_data", 0, True
Set oShell = Nothing
wscript.echo "处理完毕！"



