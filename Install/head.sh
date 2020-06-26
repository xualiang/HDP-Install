#!/bin/bash

date=`date "+%Y%m%d"`

#目录
basedir=/software
logfile=${basedir}/install.log
installdir=${basedir}/Install
tooldir=${basedir}/Tool
mysqldir=${tooldir}/mysql

#文件
cdpath=${tooldir}/CentOS-7-x86_64-DVD-1810.iso
hdp_tar=${tooldir}/HDP-3.1.0.0-centos7-rpm.tar.tar
hdp_utils_tar=${tooldir}/HDP-UTILS-1.1.0.22-centos7.tar.tar
ambari_tar=${tooldir}/ambari-2.7.3.0-centos7.tar.gz
jdkpath=${tooldir}/jdk-8u181-linux-x64.tar.gz
jce_policy_zip=${tooldir}/jce_policy-8.zip
c3rpm_path=${tooldir}/c3-5.1.3-0.1.noarch.rpm
libtirpc_devel=${tooldir}/libtirpc-devel-0.2.4-0.15.el7.x86_64.rpm

#Logo替换相关的文件和图片
gz_file_path=/usr/lib/ambari-server/web/javascripts/app.js.gz
logo_file_path=/usr/lib/ambari-server/web/javascripts/app.js
logo_img=${tooldir}/logo.png
logo_white_img=${tooldir}/logo-white.png
img_path=/usr/lib/ambari-server/web/img/

#ambari-setup日志
ambari_log=/tmp/ambari-setup.log

function run(){
  local script_name=`basename ${0}`
  local date_str=`date "+%Y-%m-%d %H:%M:%S"`
  echo "${date_str} [INFO] [IN SCRIPT: ${script_name}, CMD: $@] begin running..."

  eval "$@"
  if [ $? -eq 0 ]; then    #####此句之前不可再添加任何其他语句，否则影响$?的判断
    local date_str=`date "+%Y-%m-%d %H:%M:%S"`
    echo "${date_str} [SUCC] [IN SCRIPT: ${script_name}, CMD: $@] execute successfull"
  else
    local date_str=`date "+%Y-%m-%d %H:%M:%S"`
    echo "${date_str} [ERROR] [IN SCRIPT: ${script_name}, CMD: $@] execute failed"
    exit 1
  fi
}
