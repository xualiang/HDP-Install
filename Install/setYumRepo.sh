#!/bin/bash

source `dirname $0`/head.sh

repo_file=/etc/yum.repos.d/ambari.repo
ambari_name=ambari
ambari_path="ambari/centos7/2.7.3.0-139"
hdp_name="HDP-3.1-repo-1"
hdp_path="HDP/centos7/3.1.0.0-78"
hdp_utils_name="HDP-UTILS-1.1.0.22-repo-1"
hdp_utils_path="HDP-UTILS/centos7/1.1.0.22"

############## Ambari Yum Repo ################# 
if [ ! -d "/var/www/html/${ambari_path}" ];then
  tar zxf ${ambari_tar}  -C /var/www/html/
fi
echo "decompress Ambari successfull"

echo "[${ambari_name}]
name=${ambari_name}
baseurl=http://`hostname`/${ambari_path}
enabled=1
gpgcheck=0" > $repo_file

echo "write yum for Ambari successfull"

############### HDP Yum Repo ###################
if [ ! -d "/var/www/html/${hdp_path}" ];then
  tar zxf $hdp_tar  -C /var/www/html/
fi
echo "decompress hdp successfull"
:<<EOF
echo "[${hdp_name}]
name=${hdp_name}
baseurl=http://`hostname`/${hdp_path}
enabled=1
gpgcheck=0" >> $repo_file

echo "write yum for hdp successfull"
EOF

############### HDP UTIL Yum Repo ################
if [ ! -d "/var/www/html/${hdp_utils_path}" ]; then
  tar zxf $hdp_utils_tar -C /var/www/html/
fi
echo "decompress hdp-utils successfull"

:<<EOF
echo "[${hdp_utils_name}]
name=${hdp_utils_name}
baseurl=http://`hostname`/${hdp_utils_path}
enabled=1
gpgcheck=0" >> $repo_file

echo "write yum for hdp-utils successfull"
EOF

################ mysql Yum Repo ################
if [ ! -d /var/www/html/mysql/repodata ]; then
  mkdir -p /var/www/html/mysql/Packages
  cp ${tooldir}/mysql/*.rpm /var/www/html/mysql/Packages/
  createrepo /var/www/html/mysql
fi
echo "createrepo for mysql successfull"

echo "[mysql]
name=mysql
baseurl=http://`hostname`/mysql
enabled=1
gpgcheck=0" > /etc/yum.repos.d/mysql-community.repo

echo "[mysql-source]
name=mysql-source
baseurl=http://`hostname`/mysql
enabled=1
gpgcheck=0" > /etc/yum.repos.d/mysql-community-source.repo

echo "write yum for mysql successfull"
