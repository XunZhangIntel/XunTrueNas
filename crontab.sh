root_path=/root/Crontab_dir
maillog=`date +"%Y%m%d"`_mail.log

sh /root/XunTrueNas/ssh_enable.sh
echo "IP: "`curl ifconfig.me` >> $root_path/$maillog 

cat $root_path/$maillog | mail -s "Nas Status" 623118182@qq.com
