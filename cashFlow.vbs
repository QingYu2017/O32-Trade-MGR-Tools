'取现金流,c成本，sday起息日，dday到期日，fre付息频率（月数），r收益率,cday计息日
'Excel函数
'=(YEAR(M1)*100+MONTH(M1)<=YEAR($E2)*100+MONTH($E2))*(MOD((YEAR(M1)-YEAR($D2))*12+MONTH(M1)-MONTH($D2),$G2)=0)*1*$I2*$C2+(YEAR(M1)*100+MONTH(M1)=YEAR(E2)*100+MONTH(E2))*I2
'abs(a=b)*1 成立时为1，不成立时为0

Function get_cf(c, sday, dday, cday, fre, r)

'c1判断是否需要付息，当前日小于到期日
c1 = Abs((Year(cday) * 100 + Month(cday) <= Year(dday) * 100 + Month(dday)) * 1)
'c2判断是否当月有付息，与起始日的间隔月数，为付息频率的整数倍
C2 = Abs((((Year(cday) - Year(sday)) * 12 + Month(cday) - Month(sday)) Mod fre) = 0) * 1
'c2判断是否付本金
c3 = Abs((Year(cday) * 100 + Month(cday) = Year(dday) * 100 + Month(dday)) * 1)
get_cf = c1 * C2 * c * r + c3 * c

'get_cf = c3

End Function


