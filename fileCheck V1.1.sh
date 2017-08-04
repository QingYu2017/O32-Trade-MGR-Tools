#!/bin/bash 
#Auth:Qing.Yu
#Mail:1753330141@qq.com
# Ver:V1.1
#Date:2017-08-01


t=`/bin/date +%H`

#判断执行时间
if (($t>=13)); then 
	d=`/bin/date +%Y%m%d`
	else
	d=`/bin/date -d '-1 day' +%Y%m%d`
fi

echo $t

echo $d

#定义checkFile返回变量
r=''

#定义文件检查函数，函数第一个变量为检查文件类别，第二个为文件名
checkFile(){
#echo $2
if [ ! -f $2 ]; then
  r="□"$1"：读取失败"
  return 0
  else
  r="■"$1"：就绪"
  return 1 
fi
}

#定义路径
f_path='/root/clearData/'$d'/'

#status of file check
checkFile "上交所行情文件" $f_path'mktdt00.txt'
s_ezsr=$r
checkFile "上交所地面行情资讯文件" $f_path'fjy'$d'.txt'
s_bt=$r
checkFile "上交所过户文件" $f_path'gh36573.dbf'
s_eztrans=$r
checkFile "深交所盘终行情文件" $f_path'securities_'$d'.xml'
s_szfx=$r
checkFile "沪中登PROP文件" $f_path'fsbz_dz'.${d:5}
s_prop=$r
checkFile "深中登D-COM文件" $f_path'JS.OK'
s_dcom=$r


str="※※※※※※※※※※※※交易所清算文件检查※※※※※※※※※※※※\n\n文件日期：【"$d"】\n\n"$s_ezsr"\n\n"$s_bt"\n\n"$s_eztrans"\n\n"$s_prop"\n\n"$s_szfx"\n\n"$s_dcom

echo -e $str

python /root/clearDataCheck/sendWeixin.py Qing.Yu xx $str
