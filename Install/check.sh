#!/bin/bash

source `dirname $0`/head.sh

function check_os_release(){
  os_release=`cat /etc/centos-release|grep "CentOS Linux release 7.6"`
  if [ $? -eq 0 -a "${os_release}" != "" ]; then
    echo "The OS release is: ${os_release}, continue"
    return 0
  else
    echo "Not support this OS release, exit now"
    exit 1
  fi
}

function check_file_exists(){
  if [ ! -f "$1" ]; then
    echo "file ${1} is not found, please check it!"
    exit 1
  fi
}


check_os_release


check_file_exists ${ambari_tar}
check_file_exists ${c3rpm_path}
check_file_exists ${cdpath}
check_file_exists ${hdp_tar}
check_file_exists ${hdp_utils_tar}
check_file_exists ${jdkpath}
check_file_exists ${jce_policy_zip}
#check_file_exists ${tooldir}/logo.png      
#check_file_exists ${tooldir}/logo-white.png
check_file_exists ${libtirpc_devel}

check_file_exists ${mysqldir}/mysql-community-client-5.7.24-1.el7.x86_64.rpm
check_file_exists ${mysqldir}/mysql-community-devel-5.7.24-1.el7.x86_64.rpm
check_file_exists ${mysqldir}/mysql-community-libs-5.7.24-1.el7.x86_64.rpm
check_file_exists ${mysqldir}/mysql-community-common-5.7.24-1.el7.x86_64.rpm
check_file_exists ${mysqldir}/mysql-community-embedded-5.7.24-1.el7.x86_64.rpm
check_file_exists ${mysqldir}/mysql-community-server-5.7.24-1.el7.x86_64.rpm
check_file_exists ${mysqldir}/mysql-connector-java-8.0.13.jar

check_file_exists ${installdir}/check.sh             
check_file_exists ${installdir}/head.sh
check_file_exists ${installdir}/install.sh
check_file_exists ${installdir}/installC3.sh          
check_file_exists ${installdir}/installJDK           
check_file_exists ${installdir}/installMysql
#check_file_exists ${installdir}/installMysqlDB       
check_file_exists ${installdir}/installNtpAgent      
check_file_exists ${installdir}/installNtpServer     
check_file_exists ${installdir}/installOS            
check_file_exists ${installdir}/installRpm
check_file_exists ${installdir}/installSnappy.sh     
check_file_exists ${installdir}/setLogo.sh  
check_file_exists ${installdir}/setUp.sh          
check_file_exists ${installdir}/setupAmbari.sh       
#check_file_exists ${installdir}/setupcrontab.sh      
#check_file_exists ${installdir}/setuprsync.sh
check_file_exists ${installdir}/set_ssh_trust.sh
check_file_exists ${installdir}/setYumRepo.sh
