root_path=/root/Crontab_dir
maillog=`date +"%Y%m%d"`_mail.log

sh /root/XunTrueNas/ssh_enable.sh >> $root_path/$maillog 2>&1
echo "IP: "`curl ifconfig.me` >> $root_path/$maillog 

cat $root_path/$maillog | mail -s "Nas Status" 623118182@qq.com
