# O32运维管理工具
基于O3的投资交易系统运维管理组件

解决部分运维管理问题：
- 清算文件接收和检查![检查脚本](https://github.com/QingYu2017/O32-Trade-MGR-Tools/blob/O32%E8%BF%90%E7%BB%B4%E7%AE%A1%E7%90%86%E9%85%8D%E5%A5%97%E5%B7%A5%E5%85%B7/fileCheck%20V1.1.sh)
  - 扫描目标文件夹，判断清算文件状态；
  - 状态汇总，并短信推送； 
  - 部署定时任务执行；
- 系统资讯数据核对![代码示例](https://github.com/QingYu2017/O32-Trade-MGR-Tools/blob/O32%E8%BF%90%E7%BB%B4%E7%AE%A1%E7%90%86%E9%85%8D%E5%A5%97%E5%B7%A5%E5%85%B7/checkPrice.vbs)
  - sql server链接O32 oracle数据库；
  - 通过vba插件调取Wind资讯数据；
  - 比对O32库中的中债价格，与Wind终端数据是否一致；

- 现金流计算![代码示例](https://github.com/QingYu2017/O32-Trade-MGR-Tools/blob/O32%E8%BF%90%E7%BB%B4%E7%AE%A1%E7%90%86%E9%85%8D%E5%A5%97%E5%B7%A5%E5%85%B7/cashFlow.vbs)
  - 定义时间变量和利率变量；
  - 判断付息日与当前日期（考察日期）先后；
  - 考察周期内收息累加；

- oracle环境配置；
