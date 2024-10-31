#!/bin/bash

tmp_dir=$HOME/tmp
fail_pd=$HOME/tmp/fail_pd.log
fail_pd_ips=$HOME/tmp/fail_pd_ips.log
hosts_deny=/etc/hosts.deny
has_new=0
ip_deny_cron_log=$HOME/Crontab_dir/ip_deny

if [ ! -d $tmp_dir ]; then
	mkdir -p $tmp_dir
fi

if [ ! -d $ip_deny_cron_log ]; then
	mkdir -p $ip_deny_cron_log
fi
ip_deny_cron_log=$ip_deny_cron_log/`date +"%Y%m%d_%H%M%S"`

grep "Failed password" /var/log/auth.log > $fail_pd
cat $fail_pd | grep -oP '(?<=\s)(([01]?\d\d?|2[0-4]\d|25[0-5])\.){3}([01]?\d\d?|2[0-4]\d|25[0-5])(?=\s)' | sort | uniq -c > $fail_pd_ips

while read line ;
do
	num=`echo $line | awk '{print $1}'`
	ip=`echo $line | awk '{print $2}'`
	if [ "$num" -gt "10" ]; then
		if [ `grep -wc $ip $hosts_deny` -eq 0 ]; then
			has_new=1
			echo "New deny ip: $ip" >> $ip_deny_cron_log 
			echo "sshd: $ip" >> $hosts_deny
		fi
	fi
done < $fail_pd_ips

if [ $has_new -eq 1 ]; then
	sudo service ssh restart
    cat $ip_deny_cron_log | mail -s "IP Deny" 623118182@qq.com	
fi
