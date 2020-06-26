#!/bin/bash
source `dirname $0`/head.sh

run "yum install ambari-server -y > /dev/null 2>&1"

jdk=`ls ${basedir}/ | grep jdk`

expect > ${ambari_log} 2>&1 <<EOF
spawn ambari-server setup -j ${basedir}/$jdk/
expect {
  "*?*" {send "\r";exp_continue}
}
EOF
if [ $? -eq "0" ]; then
  echo "ambari-server setup -j ${basedir}/$jdk/ successfull"
else
  echo "ambari-server setup -j ${basedir}/$jdk/ fail"
  exit 1
fi

#run sh ${installdir}/setLogo.sh

run "service ambari-server restart >> ${ambari_log} 2>&1"

ambari-server setup --jdbc-db=mysql --jdbc-driver=${mysqldir}/mysql-connector-java-8.0.13.jar

# Fixed Ambari Bug for use local repo
count=`head -39895 /usr/lib/ambari-server/web/javascripts/app.js |tail -1|grep -c useLocalRepo`
if [ $count -ne 1 ]; then
  sed -i "39894 aif (stack.get('useLocalRepo') !== true) {" /usr/lib/ambari-server/web/javascripts/app.js
  sed -i "39900 a}" /usr/lib/ambari-server/web/javascripts/app.js
else
  echo "Ambari bug in app.js has fixed, northing need to do !"
fi
