#!/bin/bash

source $(dirname $0)/head.sh

function main(){
# 如果没有参数，默认安装全部
  if [ "$#" = "0" ]; then
    echo "********************************************************************"
    echo "******************** Check Environment if OK ***********************"
    echo "********************************************************************"
    run sh $installdir/check.sh


    echo "********************************************************"
    echo "******************** Install yum OS ********************"
    echo "********************************************************"
    run sh $installdir/installOS


    echo "********************************************************"
    echo "******************** Set Rpm tool **********************"
    echo "********************************************************"
    echo "yum install tcl、expect、createrepo, begin..."
    run sh $installdir/installRpm


    echo "********************************************************"
    echo "******************** Set ssh_auth **********************"
    echo "********************************************************"
    read -p "Enter all hosts for HDP (example: node1,node2,node3):" hdp_hosts
    echo ${hdp_hosts}|sed "s/,/\n/g"
    read -p "Please confirm the hosts, Enter (y/n): " yes_or_no
    if [ "${yes_or_no}" = "y" -o "${yes_or_no}" = "Y" ]; then
      export hdp_hosts
      run sh $installdir/set_ssh_trust.sh root ${hdp_hosts}
    else
      exit 1
    fi


    echo "********************************************************"
    echo "****************** Install C3 Tool *********************"
    echo "********************************************************"
    echo "install c3 rpm, begin..."
    run sh $installdir/installC3.sh

    run cpush hdp: /etc/hosts /etc/hosts


    echo "--------------------------------- All-Node start ----------------------------------"
    
    echo "********************************************************************"
    echo "*************** All nodes mkdir dir install and tool ***************"
    echo "********************************************************************"
    # 在 copy 脚本或者 jdk 之前，需要建立目录。
    run cexec hdp: "mkdir -p $installdir"
    run cexec hdp: "mkdir -p $tooldir"
    run cpush hdp: ${installdir}/head.sh ${installdir}/

    echo "******************************************"
    echo "****** All-Node set the Environment ******"
    echo "******************************************"
    run cpush hdp: ${installdir}/setUp.sh ${installdir}/
    run cexec hdp: "sh ${installdir}/setUp.sh"


    echo "**********************************************"
    echo "****** All-Node set the Repo ******"
    echo "**********************************************"
    run cexec hdp: "rm -rf /etc/yum.repos.d/Cent*"
    echo "master node set yum repo for ambari、hdp、hdp-util and mysql，require some minutes..."
    run sh $installdir/setYumRepo.sh
    run cpush hdp: /etc/yum.repos.d/*.repo /etc/yum.repos.d/
    run cexec hdp: "yum clean all"
    run cexec hdp: "yum makecache"
    run cexec hdp: "yum repolist"

    echo "************************************"
    echo "******  All-Node install JDK  ******"
    echo "************************************"
    echo "Master node decompression JDK and setup environment, begin..."
    run sh $installdir/installJDK
    run cpush hdp: ${basedir}/jdk* ${basedir}/
    run cpush hdp: /etc/profile /etc/profile
    run cexec hdp: "source /etc/profile"
    run cpush hdp: ${basedir}/jdk*/jre/lib/security/ ${basedir}/jdk*/jre/lib/security/


    echo "********************************************************"
    echo "****** All-Node set the ntp-server and ntp-agent  ******"
    echo "********************************************************"
    # 1.设置 ntp-server
    run sh $installdir/installNtpServer
    # 2.设置 ntp-agent
    run cpush hdp: $installdir/installNtpAgent $installdir
    run cexec hdp: "sh $installdir/installNtpAgent `hostname`"


    echo "********************************************************"
    echo "*********** Main-Node install ambari-server  ***********"
    echo "********************************************************"
    run sh $installdir/setupAmbari.sh

:<<EOF
    echo "********************************************************"
    echo "************** All-node Install snappy  ****************"
    echo "********************************************************"
    echo "main-node installing snappy ...."
    run sh $installdir/installSnappy.sh
    run cpush hdp: $installdir/installSnappy.sh $installdir
    run cexec hdp: "sh $installdir/installSnappy.sh"
EOF

    echo "********************************************************"
    echo "********** All-node Install libtirpc-devel  ************"
    echo "********************************************************"
    run cpush hdp: ${libtirpc_devel} ${libtirpc_devel}
    run cexec hdp: "rpm -ivh --replacepkgs ${libtirpc_devel}"

    echo "********************************************************"
    echo "************** Main-node Install mysql  *****************"
    echo "********************************************************"

    #run cpush hdp: $installdir/installMysql $installdir

    run sh $installdir/installMysql


    echo "                                "
    echo "All finished, Congratulations!"

  else
    var=($@)
    for (( i=0; i<"$#"; i++ ))
    do
      if [ "${var[$i]}" = "ntpserver" ]; then
        echo ${var[$i]}
        run sh $installdir/installNtpServer
      elif [ "${var[$i]}" = "ntpagent" ]; then
        echo ${var[$i]}
        run cpush hdp: $installdir/installNtpAgent $installdir
        run cexec hdp: "sh $installdir/installNtpAgent"      
      elif [ "${var[$i]}" = "crontab" ]; then
        echo ${var[$i]}
        run sh $installdir/setupcrontab.sh        
      elif [ "${var[$i]}" = "jdk" ]; then
        echo ${var[$i]}
        run sh $installdir/installJDK
        run cpush hdp: ${basedir}/jdk* ${basedir}/
        run cpush hdp: /etc/profile /etc/profile
        run cexec hdp: "source /etc/profile"
      fi
      echo $installdir
    done
  fi
}

echo "The install program running now, log file is ${logfile}"
main "$@" 2>&1 | tee ${logfile}
echo "Finish! Please check log file ${logfile}, make sure successfull or not!"
