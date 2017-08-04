#!/bin/bash
#Auth:Qing.Yu
#Mail:1753330141@qq.com
# Ver:V1.1
#Date:2017-08-01
#定义实例名称，挂载路径，数据库程序安装路径，数据库路径
#缺省用户名oracle，组dba
ora_sid='ASTORADB23'
disk_path='/media/ORADATA'
dbsoft_path=$disk_path'/DBSoftware/app/oracle'
dbdata_path=$disk_path'/DBData/oradata'


#创建账号和组
groupadd -g 5001 dba
useradd -u 5001 -g dba -d /home/oracle/ -m -s /bin/bash oracle
#passwd oracle
echo "#创建组完成#"

#创建目录
mkdir -p $dbsoft_path
mkdir -p $dbdata_path
echo "#创建目录完成#"

#修改权限
chown -R oracle:dba $dbsoft_path $dbdata_path
chmod -R 777 $dbsoft_path $dbdata_path
echo "#更新目录权限完成#"

#变更linux核心参数，参照8G内存配置
sed -i "$a \\n#Oracle part\nkernel.shmmax=8589934591\nkernel.shmmni=4096\nkernel.shmall=2097152\nkernel.sem=250 32000 100 128\nfs.file-max=65536\nfs.aio-max-nr=1048576\nnet.ipv4.ip_local_port_range=1024 65000\nnet.core.rmem_default=262144\nnet.core.rmem_max=1048576\nnet.core.wmem_default=262144\nnet.core.wmem_max=1048576\nkernel.sem=800 32000 400 800\nkernel.msgmni=4096\nkernel.msgmax=65536\nkernel.msgmnb=84000\n" /etc/sysctl.conf
echo "#更新内核参数完成#"


#变更生效
sysctl -p
echo "#内核参数更新生效#"


#修改oracle账户配置
su - oracle -c 'sed -i '\''$a \\n#oracle part\nexport ORACLE_BASE='$dbsoft_path'\nexport ORACLE_SID='$ora_sid'\nexport ORACLE_HOME=\$ORACLE_BASE/product/11.2.0.4.0/db_1\nexport PATH=\$PATH:\$ORACLE_HOME/bin\nexport LD_LIBARY_PATH=\$ORACLE_HOME/lib\nexport PATH  \numask 022\n'\'' /home/oracle/.bash_profile'
echo "#oracle账户配置更新完成#"

#变更生效
su - oracle -c "source .bash_profile"
echo "#oracle账户配置生效#"

#创建启动脚本
echo '' >/etc/init.d/oracle
echo "#启动脚本新建完成#"


#允许执行
chmod a+x /etc/init.d/oracle
echo "#启动脚本权限更新#"

#写入启动信息
sed -i '$a #!/bin/sh\n#chkconfig: 2345 20 80\n#description: Oracle dbstart / dbshut\n#以上两行为chkconfig所需\nORA_HOME='$dbsoft_path'/product/11.2.0.4.0/db_1\nORA_OWNER=oracle\nLOGFILE=/var/log/oracle.log\necho "#################################" >> \${LOGFILE}\ndate +"### %T %a %D: Run Oracle" >> \${LOGFILE}\nif [ ! -f \${ORA_HOME}/bin/dbstart ] || [ ! -f \${ORA_HOME}/bin/dbshut ]; then\n    echo "Error: Missing the script file \${ORA_HOME}/bin/dbstart or \${ORA_HOME}/bin/dbshut!" >> \${LOGFILE}\n    echo "#################################" >> \${LOGFILE}\n    exit\nfi\nstart(){\n    echo "###Startup Database..."\n    su - \${ORA_OWNER} -c "\${ORA_HOME}/bin/dbstart \${ORA_HOME}"\n    echo "###Done."\n    echo "###Run database control..."\n    su - \${ORA_OWNER} -c "\${ORA_HOME}/bin/emctl start dbconsole"\n    echo "###Done."\n}\nstop(){\n    echo "###Stop database control..."\n    su - \${ORA_OWNER} -c "\${ORA_HOME}/bin/emctl stop dbconsole"\n    echo "###Done."\n    echo "###Shutdown Database..."\n    su - \${ORA_OWNER} -c "\${ORA_HOME}/bin/dbshut \${ORA_HOME}"\n    echo "###Done."\n}\ncase "\$1" in\n    '\''start'\'')\n        start >> \${LOGFILE}\n    ;;\n    '\''stop'\'')\n        stop >> \${LOGFILE}\n    ;;\n    '\''restart'\'')\n        stop >> \${LOGFILE}\n        start >> \${LOGFILE}\n    ;;\nesac\ndate +"### %T %a %D: Finished." >> \${LOGFILE}\necho "#################################" >> \${LOGFILE}\necho ""\n' /etc/init.d/oracle
echo "#启动脚本内容更新#"


chkconfig --add oracle
chkconfig --level 24 oracle off
chkconfig --level 35 oracle on

ln -s /etc/init.d/oracle /etc/rc0.d/K01oracle 
ln -s /etc/init.d/oracle /etc/rc6.d/K01oracle
echo "#启动配置完成#"


#安装结束后，修改启动配置
#sed -i "s/:N/:Y/g" /etc/oratab
#su - oracle -c 'sed -i '\''s/ORACLE_HOME_LISTNER=$1/ORACLE_HOME_LISTNER=$ORACLE_HOME/'\'' $ORACLE_HOME/bin/dbstart'
#su - oracle -c 'sed -i '\''s/ORACLE_HOME_LISTNER=$1/ORACLE_HOME_LISTNER=$ORACLE_HOME/'\'' $ORACLE_HOME/bin/dbstart'


