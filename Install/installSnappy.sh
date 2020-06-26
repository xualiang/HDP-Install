#!/bin/bash

source `dirname $0`/head.sh

snappy=`rpm -qa | grep snappy`

if [ "x${snappy}" != "x" ]; then
  rpm --nodeps -e $snappy
fi

mv /etc/yum.repos.d/OS.repo /etc/yum.repos.d/OS.repo.bak

run "yum install snappy.x86_64 -y > /dev/null 2>&1"

mv /etc/yum.repos.d/OS.repo.bak /etc/yum.repos.d/OS.repo
