# O32运维管理工具
基于O3的投资交易系统运维管理组件

- 清算邮件接收[代码示例](https://github.com/QingYu2017/O32-Trade-MGR-Tools/blob/O32%E8%BF%90%E7%BB%B4%E7%AE%A1%E7%90%86%E9%85%8D%E5%A5%97%E5%B7%A5%E5%85%B7/procClearingDataMail.py)
 - **功能说明：券结模式下，邮件分发的清算文件处理**
 - 通过json配置邮件账号信息
 - 正则表达式配置邮件搜索关键字（邮件关键字+业务日期关键字）
 - 按数据日期分拣至指定业务日期目录

- 清算文件接收和检查[代码示例](https://github.com/QingYu2017/O32-Trade-MGR-Tools/blob/O32%E8%BF%90%E7%BB%B4%E7%AE%A1%E7%90%86%E9%85%8D%E5%A5%97%E5%B7%A5%E5%85%B7/fileCheck%20V1.1.sh)
  - **功能说明：盘后沪深交易所、沪深中登清算用文件完整性检查**
  - 扫描目标文件夹，判断清算文件状态；
  - 状态汇总，并短信推送； 
  - 部署定时任务执行；

- 系统资讯数据核对[代码示例](https://github.com/QingYu2017/O32-Trade-MGR-Tools/blob/O32%E8%BF%90%E7%BB%B4%E7%AE%A1%E7%90%86%E9%85%8D%E5%A5%97%E5%B7%A5%E5%85%B7/checkPrice.vbs)
  - **功能说明：由于O32中导入的中债价格可能和银行间当日交易价格不同，引起风控计算和交易室委托异常，增加价格校验机制**
  - sql server链接O32 oracle数据库；
  - 通过vba插件调取Wind资讯数据；
  - 比对O32库中的中债价格，与Wind终端数据是否一致；

- 现金流计算[代码示例](https://github.com/QingYu2017/O32-Trade-MGR-Tools/blob/O32%E8%BF%90%E7%BB%B4%E7%AE%A1%E7%90%86%E9%85%8D%E5%A5%97%E5%B7%A5%E5%85%B7/cashFlow.vbs)
  - 定义时间变量和利率变量；
  - 判断付息日与当前日期（考察日期）先后；
  - 考察周期内收息累加；

- O32日志文件的备份和导出[代码示例](https://github.com/QingYu2017/O32-Trade-MGR-Tools/blob/O32%E8%BF%90%E7%BB%B4%E7%AE%A1%E7%90%86%E9%85%8D%E5%A5%97%E5%B7%A5%E5%85%B7/bakProc%20V1.0.sh)
  - **功能说明：O32修改日志级别后，将产生大量日志文件，需定期删除，考虑排错和系统定期巡检，使用该功能定时压缩备份并清除**
  - trade日志文件压缩
  - 日志文件归集
  - 已存档文件的删除

- oracle环境配置[代码示例](https://github.com/QingYu2017/O32-Trade-MGR-Tools/blob/O32%E8%BF%90%E7%BB%B4%E7%AE%A1%E7%90%86%E9%85%8D%E5%A5%97%E5%B7%A5%E5%85%B7/installORA%20V1.0.sh)
  - 创建oracle用户账号
  - 修改环境变量和核心参数
  - 配置Oracle服务随系统启动
  - 其他：注意processes参数也需要及时调整，否额在trade服务启动过程中会出现超出进程数后，后续服务启动失败

- O32服务的启停批处理
  - **功能说明：顺序启停O32相关服务（ASAR环境）**
```shell
#快速关闭服务
su - mc -c 'cd workspace && ./stopmc'
su - o4bar -c 'cd workspace && ./stopbar'
su - trade -c 'cd workspace && ./stopas'

#快速启动服务
su - o4bar -c 'cd workspace && ./runbar'
su - trade -c 'cd workspace && ./runas'
su - mc -c 'cd workspace && ./runmc'
```
