declare @par_date as nvarchar(20),@sql_str as nvarchar(max)
--set @par_date=@q_year+'-'+@q_month+'-'+@q_date
set @par_date='2017-2-9'
set @sql_str='select 
case 
	when ti.L_CURRENT_AMOUNT=fi.L_ZQCC then ''01 match''
	when ti.L_CURRENT_AMOUNT+0<>fi.L_ZQCC+0 then ''02 not match''
	when ti.L_CURRENT_AMOUNT is null then ''03 fa only''
	when fi.L_ZQCC is null then ''04 trade only''
	else ''05 other''
end check_flag,
ti.vc_fund_code,ti.vc_fund_name,ti.vc_invest_name,ti.VC_MARKET_NAME,
ti.VC_REPORT_CODE,ti.VC_STOCK_NAME,ti.VC_STOCKtype_NAME,cast(ti.L_CURRENT_AMOUNT as decimal(20,2)) L_CURRENT_AMOUNT,
fi.l_ztbh,fi.vc_ztname,fi.VC_ISIN,fi.vc_zqjc,fi.invest_name,fi.market_name,fi.stock_type_name,cast(fi.l_zqcc as decimal(20,2)) l_zqcc
from
--#估值为fi 
(select * from openquery(ora_fa,''select tjc.d_date,tjc.l_ztbh,tsys.vc_name vc_ztname,tw.vc_jjdm,txx.vc_isin,txx.vc_zqjc,tjc.l_zqcc,
vtz.l_tzlx_o32 invest_code,vtz.vc_bz invest_name,
tscxx.vc_scmc market_name,
txx.l_zqlb,vlb.c_stock_type stock_type,vlb.vc_bz stock_type_name
from taccountzqjc tjc,tzqxx txx,tsysinfo tsys,v_o32qs_zqlbmxyzqlb vlb,
v_o32qs_tzlxytzlx vtz,(select distinct l_ztbh,vc_jjdm from TWBZHYZT) tw,tscxx
where tjc.l_ccfl=0
and tjc.l_zqnm=txx.l_zqnm
and tjc.l_ztbh=tsys.l_id
and txx.l_zqlb=vlb.l_zqlb(+)
and txx.l_zqlbmx1=vlb.l_zqlbmx1(+)
and tsys.l_id not in (''''2300'''',''''3300'''',''''3600'''')
and tjc.l_tzlx=vtz.l_tzlx
and tjc.l_sclb=tscxx.l_scdm(+)
and tjc.l_ztbh=tw.l_ztbh(+)
and tjc.l_zqcc<>0
and tjc.d_date=to_date('''''+@par_date+''''',''''yyyy/mm/dd'''')'')) 
--#估值为fi
as fi
full join 
--#交易为ti
(select ts.*,case when FA_TRADE_TRANS.FA_Code is null then ts.vc_report_code else FA_TRADE_TRANS.FA_Code end trans_code,
case when FA_TRADE_TRANS.FA_Code is null then l_zqlb else 4 end l_zqlb
from
(select * from openquery(ora_trade,
''select to_date(tu.l_date,''''yyyymmdd'''') l_date,tf.vc_fund_code,tf.vc_fund_name,tu.c_invest_type,tii.vc_item_name vc_invest_name,
tsi.c_market_no,tm.vc_market_name,tsi.vc_report_code,tsi.vc_stock_name,
tsi.c_stock_type,tt.vc_stocktype_name,tu.l_current_amount
from 
tfundinfo tf,
(select l_date,l_fund_id,vc_inter_code,c_invest_type,l_current_amount from thisunitstock) tu,
(select l_date,vc_inter_code,c_market_no,vc_report_code,vc_stock_name,c_stock_type from thisstockinfo) tsi,
tmarketinfo tm,(SELECT c_lemma_item, vc_item_name FROM tdictionary WHERE l_dictionary_no = 40351) tii,
tstocktype tt
where tf.l_fund_id=tu.l_fund_id
and tu.vc_inter_code=tsi.vc_inter_code
and tu.vc_inter_code=tsi.vc_inter_code 
and tu.l_date=tsi.l_date
and tu.l_current_amount<>0
and tsi.c_market_no=tm.c_market_no
and tu.c_invest_type=tii.c_lemma_item
and tsi.c_stock_type=tt.c_stock_type
and tsi.c_market_no=tt.c_market_no
and tu.l_date=to_char(to_date('''''+@par_date+''''',''''yyyy-mm-dd''''),''''yyyymmdd'''')'')) ts
left join trade.dbo.stock_type_convert st
on ts.c_stock_type=st.c_stock_type
left join FA_TRADE_TRANS
on ts.vc_report_code=FA_TRADE_TRANS.TRADE_Code) 
--#交易为ti
as ti
on ti.vc_fund_code=fi.VC_JJDM
--#注释对照代码转换，使用改为包含自定义转换代码对照
--and ti.VC_REPORT_CODE=fi.VC_ISIN
and ti.trans_code=fi.VC_ISIN
and ti.C_INVEST_TYPE=fi.invest_code
and ti.l_zqlb=fi.l_zqlb
order by check_flag,ti.vc_fund_code'
exec (@sql_str)
