#!/bin/bash

root_path=/root/Crontab_dir
d=`date | awk '{print $3}'`
n=`grep PasswordAuthentication -n /etc/ssh/sshd_config | awk -F ':' '{print $1}'`
maillog=`date +"%Y%m%d"`_mail.log

if [ $(expr $d % 2) -eq 1 ]; then 
  sudo sed -i "${n}s/^.*$/PasswordAuthentication yes/" /etc/ssh/sshd_config
else
  #sudo sed -i "${n}s/^.*$/PasswordAuthentication no/" /etc/ssh/sshd_config
  sudo sed -i "${n}s/^.*$/PasswordAuthentication yes/" /etc/ssh/sshd_config
fi

if [ `grep -c "Port 9010" /etc/ssh/sshd_config` -eq 0 ]; then
        echo "Port 9010" >> /etc/ssh/sshd_config
fi

sudo service ssh restart

cat /etc/ssh/sshd_config > $root_path/$maillog
