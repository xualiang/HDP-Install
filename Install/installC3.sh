#!/bin/bash

source `dirname $0`/head.sh

is_installed=`rpm -qa c3|wc -l`
if [ $is_installed = "0" ]; then

  run rpm -ivh ${c3rpm_path} --force

fi

echo "
cluster hdp {
`hostname`:`hostname`#head node
dead remove-index-00
`echo ${hdp_hosts}|sed "s/,/\n/g"`
}
" > /etc/c3.conf
