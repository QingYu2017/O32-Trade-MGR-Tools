#!/bin/bash 
#Auth:Qing.Yu
#Mail:1753330141@qq.com
# Ver:V1.0
#Date:2018-01-22

#prod
bak_path='/home/trade/backup'
des_path='//10.xxx.xx.9/d$ -U administrator@amcdomain.com.cn%xxpwdxx'
des_folder='Trade_Bak\151_trade_backup'

#uat Test
#bak_path='/media/ORADATA/test'
#des_path='//10.xxx.xx.21/d$ -U ./admin%1234xxxx'
#des_folder='test'

cd $bak_path

for f in `ls $bak_path |grep .dmp$`
do
zip -j $bak_path"/"$f".zip" $bak_path"/"$f $bak_path"/"$f".explog";
smbclient $des_path <<EOF
cd $des_folder
put $f".zip"
EOF
rm -f $bak_path"/"$f
rm -f $bak_path"/"$f".explog"
done

cd -
