'Auth:Qing.Yu
'Mail:1753330141@qq.com
' Ver:V1.0
'Date:2017-05-09
'Excel加载Wind插件，通过证券代码获取Wind中债登净价，与checkPrice函数从O32中获取的价格对比

Function checkPrice(Str As String)
    Dim dbConnectStr As String
    Dim Catalog As Object
    Dim cnt As ADODB.Connection
    Dim dbPath As String
    Dim rs As Recordset
    dbConnectStr = "Data Source=10.xxx.xx.21\ccblifeamc;User ID=it_support;password=1234xxxx;Initial Catalog=it_data;Provider=SQLOLEDB.1;Auto Translate=false;"
    Set cnt = New ADODB.Connection
    With cnt
        .Open dbConnectStr
    End With
    Set rs = cnt.Execute("select * from openquery(ORA_TRADE,'select vc_report_code,vc_stock_name,en_zzd_price from tstockinfo where vc_report_code=''" & Str & "''')")
    checkPrice = rs.Fields("en_zzd_price").Value
    Set rs = Nothing
    Set cnt = Nothing
End Function
