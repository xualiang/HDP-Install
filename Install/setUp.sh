#!/bin/bash

# 关闭防火墙
systemctl disable firewalld
systemctl stop firewalld
echo "Stop and Disabled firewalld successfull"

# 禁用 selinux
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
echo "Disabled SELINUX successfull"

# 设置umask
line_count=`grep -c "umask 0022" /etc/profile`
if [ ${line_count} -gt 0 ] && [ `umask` -eq "0022" ]; then
  echo "umask has been 0022"
else
  echo umask 0022 >> /etc/profile
  echo "Modify umask successfull"
fi

# 修改可打开文件数
line_count=`grep -c "hard nofile 65535" /etc/security/limits.conf`
if [ ${line_count} -gt 0 ]; then
  echo "limits.conf already configuration, nothing to do"
else
  echo "* soft nofile 65535" >> /etc/security/limits.conf
  echo "* hard nofile 65535" >> /etc/security/limits.conf
  echo "Modify limits.conf successfull"
fi

line_count=`grep -c "session    required        pam_limits.so" /etc/pam.d/login`
if [ ${line_count} -gt 0 ]; then
  echo "pam.d already configuration, nothing to do"
else
  echo "session    required        /lib64/security/pam_limits.so" >>/etc/pam.d/login
  echo "session    required        pam_limits.so" >>/etc/pam.d/login
  echo "Change the number of file handles successfull"
fi

# 禁用 THP
echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/enabled
line_count=`grep -c "transparent_hugepage" /etc/rc.local`
if [ ${line_count} -gt 0 ]; then
  echo "transparent_hugepage already configuration in /etc/rc.local, nothing to do"
else
  echo "echo never > /sys/kernel/mm/transparent_hugepage/defrag" >> /etc/rc.local
  echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /etc/rc.local
  chmod u+x /etc/rc.d/rc.local 
  echo "Disabled THP successfull"
fi
