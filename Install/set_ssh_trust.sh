#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Please Enter user and hostname list"
  echo "Example: sh $0 root host01.com,host02.com,host03.com"
  exit 1
fi

user=$1
hosts=$2
  
SSH_DIR=~/.ssh  


read -p "Enter password for user $user: " -s PASSWORD
  
#在所有节点上生成公钥和私钥
for host in `echo ${hosts}|sed "s/,/\n/g"`
do
  expect <<EOF
spawn ssh $host ssh-keygen -b 1024 -t rsa
expect {
  "*continue*" {send "yes\r";exp_continue}
  "*password*" {send "${PASSWORD}\r";exp_continue}
  "*Overwrite*" {send "n\r";exp_continue}
  "*key*" {send "\r";exp_continue}
  "*passphrase*" {send "\r";exp_continue}
  "*again:" {send "\r";exp_continue}
}
EOF
done


mkdir -p /tmp/sshkeys
#将所有节点的公钥发送到当前节点
for host in `echo ${hosts}|sed "s/,/\n/g"`
do
  expect <<EOF
spawn scp $user@$host:$SSH_DIR/id_rsa.pub /tmp/sshkeys/id_rsa.pub.$host
expect {
  "*continue*" {send "yes\r";exp_continue}
  "*password*" {send "${PASSWORD}\r";exp_continue}
}
EOF
done

#在当前节点生成包含所有节点公钥的authorized_keys文件
cat /tmp/sshkeys/id_rsa.pub.* > $SSH_DIR/authorized_keys
chmod 600 $SSH_DIR/authorized_keys

#将包含所有节点公钥的authorized_keys文件分发到所有节点
for host in `echo ${hosts}|sed "s/,/\n/g"`
do
  expect <<EOF
spawn scp $SSH_DIR/authorized_keys $user@$host:$SSH_DIR/authorized_keys
expect {
  "*continue*" {send "yes\r";exp_continue}
  "*password*" {send "${PASSWORD}\r";exp_continue}
}
EOF
done
