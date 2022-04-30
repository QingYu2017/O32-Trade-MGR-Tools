'Auth:Qing.Yu
'Mail:1753330141@qq.com
' Ver:V1.0
'Date:2022-04-30
'行情文件拷贝到指定路径下
'添加日期参数，未输入处理当前日期，输入时处理参数输入的指定日志，参数格式YYYYMMD，添加日志打印，需要设置wscript /h:cscript


Set oFso = CreateObject("Scripting.FileSystemObject") 
set oArgs = wscript.Arguments

'wscript.echo oArgs(0)

'wscript.echo oArgs.count
if oArgs.count = 0 then
    'get current business date and format as yyyymmdd
    curBizDate =  year(date) & right("00" & month(date),2) & right("00" & day(date),2)
    else
    curBizDate = oArgs(0)
end if

root_source = "X:\MKTDT\" & curBizDate & "\"
root_des = "E:\SDR_ClearingData\hq\"

if not oFso.FolderExists(root_des) then
    'wscript.echo "路径不存在"
    oFso.CreateFolder root_des
end if



Set oFolder = oFso.GetFolder(root_source)  
Set oFiles = oFolder.Files  
For Each oFile In oFiles  
    'wscript.echo year(oFile.DateLastModified) & right("00" & month(oFile.DateLastModified), 2) & right("00" & day(oFile.DateLastModified), 2)
    if year(oFile.DateLastModified) & right("00" & month(oFile.DateLastModified), 2) & right("00" & day(oFile.DateLastModified), 2) = curBizDate then
        oFile.copy root_des
        'wscript.echo oFile & "拷贝完成"
    end if
next 
