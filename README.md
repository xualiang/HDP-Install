1.安装完成虚拟机后，需要手动配置 ip、网关、hostname。
2.在运行脚本的节点，进行 hosts 配置，确保/etc/hosts文件的第三行是集群的第一个节点（即：执行安装脚本的节点）。
3.将 Install 文件夹放置到 /software 下，确保最终脚本路径如：“/software/Install/install.sh”
4.将 Tool 文件夹放置到 /software 下，确保最终工具包路径如：“/software/Tool/jdk-8u181-linux-x64.tar.gz”  (下载地址：ftp://10.10.50.202/mnt/disk01/syssoftware/Tools)
5.确保/software/Install/install.sh中的路径跟 Tool 中的工具包名称对应。
6.在主节点运行 install.sh，不需要带任何参数。 运行此脚本的节点将作为所有源和 ambari-server。
7.当所有脚本执行完毕后，可以登录 Ambari-web 管理界面进行安装组件。

ps: 
Tool文件结构如下：
software
  |
  |--Tool
  |     |---ambari-2.1.0-centos7.tar.gz
  |     |---c3-5.1.3-0.1.noarch.rpm  
  |     |---CentOS-7-x86_64-DVD.iso  
  |     |---HDP-2.3.0.0-centos7-rpm.tar.gz  
  |     |---HDP-UTILS-1.1.0.20-centos7.tar.gz  
  |     |---jdk-8u181-linux-x64.tar.gz
  |     |---logo.png
  |     |---logo-white.png
  |     |---mysql
  |	       |---mysql-community-client-5.5.47-2.el7.x86_64.rpm  
  |	       |---mysql-community-devel-5.5.47-2.el7.x86_64.rpm     
  |	       |---mysql-community-libs-5.5.47-2.el7.x86_64.rpm
  |	       |---mysql-community-common-5.5.47-2.el7.x86_64.rpm  
  |	       |---mysql-community-embedded-5.5.47-2.el7.x86_64.rpm  
  |	       |---mysql-community-server-5.5.47-2.el7.x86_64.rpm
  |
  |--Install 文件结构如下：
        |---check.sh
        |---head.sh
        |---install.sh
        |---installC3.sh
        |---installJDK
        |---installMysql 
        |---installMysqlDB    
        |---installNtpAgent
        |---installNtpServer   
        |---installOS
        |---installRpm  
        |---installSnappy.sh           
        |---setLogo.sh 
        |---setUp.sh
        |---setupAmbari.sh
        |---setupcrontab.sh
        |---setuprsync.sh    
        |---setupssh_auth.sh
        |---setYumRepo.sh