[![Join the chat at https://gitter.im/goody80/Ralf_Dev](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/goody80/Ralf_Dev?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![RecordIt](http://g.recordit.co/DNo5wZmAmp.gif)](http://recordit.co/DNo5wZmAmp)
If you want to show detail video please click the GIF image :)

* You just can type this command
 * curl -sL http://bit.ly/on-install | sh

* Requires: sudo, BASH, SSH
* Feel free to contact me if you have any Question :) (한국어 지원)
* Contact: goody80762@gmail.com or ralf.yang@gsshop.com
* Links:
 * [English Manual](https://github.com/goody80/Ralf_Dev/wiki)
 * [Zinst Basic lecture via Youtube](https://youtu.be/30PNiJMJAgw)
 * [Slide Share](http://www.slideshare.net/sprdd/zinst-20140415)
 * [Zinst Presentation](https://db.tt/TMrEqt2X)
 * [Official Home](http://ralfyang.com)
 * [*Link: zinst packages repository in github*](https://github.com/goody80/Zinst_packages)

![http://ralfyang.com](https://avatars2.githubusercontent.com/u/4043594?v=3&s=460)
# Zinst 메뉴얼
## 개요

[![RecordIt](http://g.recordit.co/5oNjDo9r60.gif)](http://recordit.co/5oNjDo9r60)

* zinst는 분산된 서버군의 효율적인 관리와 제어를 위해 개발 되었으며, 이를 위해 별도의 agent의 설치를 필요로 하지 않습니다. 
* 예를 들어 특정 리눅스 장비 하나를 관리용도의 메니저 서버로 구성 한 다음, 해당 서버에서 다른 서버로 ssh를 통해 접속이 가능하다면, 한번의 명령어를 바탕으로 복수개의 서버를 관리 할 수 있습니다.
 * 예) 192.168.1.101 서버부터 192.168.1.199 까지 하드웨어 스펙을 확인하는 command 
``` 
$ zinst ssh '/data/bin/hwconfig -c' -h 192.168.1.1[01-99]
```

* Zinst는 리눅스 시스템 운영에 필수적으로 사용되는 명령어를 기반으로, 작업을 간단하게 처리 할 수 있도록 제작 되었습니다.
 * 예) Load-balancer에 해당 서버를 등록하기 위해 Virtual IP를 loopback으로 등록하는 작업
```
$ zinst set vipctl.vips=192.168.2.10 -set vipctl.name=DEFAULT
$ zinst start vipctl

$ ifconfig lo:DEFAULT
lo:DEFAULT Link encap:Local Loopback  
          inet addr:192.168.2.10  Mask:255.255.255.255
          UP LOOPBACK RUNNING  MTU:65536  Metric:1

$ zinst stop vipctl
$ ifconfig lo:DEFAULT
lo:DEFAULT Link encap:Local Loopback  
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
```

* 위 예제와 같은 결과를 얻기 위해 직접 리눅스 명령어를 사용하게 된다면 많은 과정을 거치게 됩니다. 또한 해당 설정 내역에 관련하여 동적으로 관리가 힘들 수도 있습니다.
* 위 내용과 같이 해당 리눅스 시스템에 구성되어있는 zinst set 값은 아래와 같이 확인이 가능 합니다.
```
$ zinst set
vipctl.name=DEFAULT
vipctl.onboot=yes
vipctl.DIR=/data/src/html
vipctl.Check_file=l4-check.html
hwconfig.nameserver1=8.8.8.8
hwconfig.nameserver2=168.126.63.1
vipctl.vips=192.168.2.10
server_default_setting.name1=8.8.8.8
server_default_setting.name2=211.44.62.40
.
.
.
```
* 동일 VIP를 사용하는 다수의 시스템(192.168.2.101~192.168.2.110)의 loopback을 동시에 관리 하기 위해 아래와 같이 활용이 가능 합니다.
```
$ zinst set vipctl.vips=192.168.2.10 -h 192.168.1.1[01-10]
$ zinst start vipctl -h 192.168.1.1[01-10]
```
* 이처럼, zinst는 특정 리눅스 장비의 개별 관리에서 부터 복수개 이상의 서버군을 관리하는 목적으로 만들어졌습니다.
* ip범위 또는 host명의 범위(예 web101.test.com ~ web110.test.com)를 정규표현식 형태로 입력받아 수많은 서버 장비를 관리 할 수 있습니다.
* 마찬가지로 다양한 서버군에 대해 file의 복사, Daemon의 stop/start/restart 등을 수행 할 수 있으며, Crontab의 확인/수정, 특정 작업을 위해 제작한 스크립트를 패키지화 하여 설치/제거/설정변경 등을 수행 할 수 있습니다.
* 일련의 모든 작업은 history에 기록이 되어 작업 tracking이 가능합니다.
* zinst는 Puppet이나 chef 처럼 시스템 Orchestration을 위해 만들어졌으나, 복잡한 설치등이 동반되지 않음으로, yum, rpm, puppet,chef, docker 등과 함께 사용 할 수 있습니다. 
* 쉽게 말해서 사람이 하는 일련의 작업을 Zinst package라는 형태로 wrapping하여 처리한다고 이해 하시면 됩니다.
* Enterprise system의 운영을 위해서는, 심플한 구성의 Infrastructure, 각 요소에 대한 자체 검증, 정규화를 기반으로한 시스템구축이 기본적으로 선행되어야 합니다.
* 이에 따라, 자체 검증 및 최적화된 application을 package 형태로 제작하여 내제화 하고, 중앙에서 전체 시스템을 총괄하여 관리 할 수 있는 방향으로 관리 형태를 일원화 할 수 있게 됩니다.
* Zinst Package 구성에는 set값을 별도로 할당 할 수 있습니다. 즉 하나의 package로 다양한 구성의 적용이 가능합니다.
* 예를 들어, Apache를 설치 시, `httpd_server` package를 사용하여 설치 할 수 있으며, 설치와 동시에 `set`값을 변경하여 구성을 달리 할 수 있습니다.
```
$ zinst i httpd_server \
-set httpd_server.DocumentRoot=/data/src/html \
-set httpd_server.hostname=www.ralfyang.com \
-set httpd_server.port=8080
```


## 시작하기
### Download & install
* zinst는 두가지 형태로 설치가 가능합니다.
* 쉬운 구성 설치를 위해 github.io를 repository화 하여 사용이 가능합니다.
```
curl -sL bit.ly/online-install | sh
```
* 위와 같이 설치 진행 시, sudo package가 필요하여 yum을 통해 자동 설치 진행 됩니다.
 * RedHat계열의 OS의 경우, yum을 통한 sudo 설치가 가능하나, Ubuntu 또는 Darwin의 경우는 그에 맞게 설치 command를 수정 하여 진행 해야 합니다.
 * 참고로, zinst 자체는 bash가 설치 된 모든 Linux, Unix 등에서 사용이 가능하나, 작업을 위한 일부 명령어(curl, bc, awk, sed, echo, printf, tar)는 OS 및 해당 명령어의 Version에 따라 다르게 출력 될 수 있습니다.

* github.io를 통해 설치 가능한 package를 적용하는 경우가 아닌, 자체적인 Package repository를 구축하고자 할 경우 아래와 같이 github의 source를 clone하여 사용 할 수 있습니다.
```
$ git clone https://github.com/goody80/Ralf_Dev.git
$ cd Ralf_Dev/1_zinst_starters_package/
$ install.sh
```
* 자체 repository를 구축 시, Apache web server가 설치됩니다.

### zinst help
* zinst는 별도의 `man-page`가 없습니다. 이는 zinst 명령어의 확산성을 위한 사상에서 시작합니다.
* A라는 서버에 zinst 명령을 통해 B라는 서버로 작업을 수행 시, `zinst` file은 자동으로 B 서버에 복제가 되어 업무를 수행합니다.
* 따라서 불필요한, file 및 config는 별도로 생성하지 않고, 오직 zinst 파일 하나에 모든것을 담아야 합니다.
* 이는, 리눅스 시스템 관리의 편의를 위해 command 형태로 유용하게 사용되기 위해 고안된 방법입니다.
* 반복적인 명령어 작업 등을 package화 하여 설치 실행 등을 수행하기 위해서는, 디렉토리 구조, default 작업 환경등의 셋팅을 위해 `server_default_setting`이라는 package를 설치하여, 시스템 초기 구성을 진행 할 수 있습니다.
```
$ zinst i server_default_setting -stable
```
[![RecordIt](http://g.recordit.co/N6I4U1ywD9.gif)](http://recordit.co/N6I4U1ywD9)

* zinst는 `man-page` 대신, 자체 manual을 command를 통해 확인 할 수 있습니다.
```
$ zinst

------------------------------------------------------------------------------------------------------ 
	zinst	[Command]	[Option Types]		[Target Names]	[-h or -H]	[Targe Host] 
------------------------------------------------------------------------------------------------------ 
		 ssh		[Command]						*Host requires	  
...................................................................................................... 
		 mcp		[local-files]		[Destination DIR]		*Host requires 
		 keydeploy								*Host requires 
------------------------------------------------------------------------------------------------------ 
		 install				[Package]   
				[-same]			[Package]	  
				[-downgrade]		[Package]	  
				[-stable]		[Package without version]	  
		 remove					[Package]	  
				[-force]		[Package]	  
...................................................................................................... 
		 list					[Blank for list-up] or [Package]  
				[-file]			[Package] or [/DIR/File-name]	  
				[-zicf]			[Package]	  
				[-dep]			[Package]	  
...................................................................................................... 
		 sync		[-file]			[Save fie for the Package set sync]	  
		 		[-url]			[Save fie from URL for the Package set sync]	  
		 restore	[-file]			[Saved file_name]	  
				[-igor]			* Not available yet 
------------------------------------------------------------------------------------------------------ 
		 set					[Blank for list-up]			  
		 [Package]	-set 			[Package.option=value]  
------------------------------------------------------------------------------------------------------ 
		 start/stop/restart/run			[Daemon_name]	  
		 on/off					[Daemon_name]	  
...................................................................................................... 
		 crontab	[-e] or [-l]					  
------------------------------------------------------------------------------------------------------ 
		 find		[Blank for list-up] or [Package]	 
		 getset		[Package with version exactly]			 
------------------------------------------------------------------------------------------------------ 
		 track		[Blank for list-up]			 
				[Package or hostname]		 
				[Package or hostname]	[-file] 	 
				[Package or hostname]	[-file=Export_File_name]	 
				"user" or "sudo_user"	 
				[User_Package_name]	[-file] 	 
				[User_Package_name]	[-file=Export_File_name]	 
------------------------------------------------------------------------------------------------------ 
		 history	[Number of Range] 
...................................................................................................... 
		 -pass		Option for Multi-host password automation
		 self-config	ip=x.x.x.x host=xxx.xxx.xxx dir=xxx
		 self-update			 
		 -version			 
		 *, help		 
------------------------------------------------------------------------------------------------------ 
 -h is target host, -H is targe file of hostlist 
 ex) zinst i sample_a sample_b -stable -set sample_a.key=111 -H ./server_list.txt 
 ex) zinst i sample-1.0.0.zinst -h web01.news.kr[1,3] web[03-12].news[1,3] 
------------------------------------------------------------------------------------------------------
 * Current zinst setup: [ Repo: http://goody80.github.io/Zinst_packages - goody80.github.io/Zinst_packages ], [ ROOT-DIR: /data ]
------------------------------------------------------------------------------------------------------ 
```

* 좀 더 상세한 설명을 위해서는 `-help` option을 사용 할 수 있습니다.
```
$ zinst -help

------------------------------------------------------------------------------------------------------ 
	zinst	[Command]	[Option Types]		[Target Names]	[-h or -H]	[Targe Host] 
------------------------------------------------------------------------------------------------------ 
 + For remote work 
 
  - Remote control: You can send a command to seperated hosts 
		 ssh		[Command]						*Host requires	  
...................................................................................................... 
 
  - File copy to remote: You can send a file(s) to seperated hosts(mcp = Multi CoPier) 
		 mcp		[local-files]		[Destination DIR]		*Host requires 
  - ssh-key copy to remote: You can send a ssh-key file to seperated hosts 
		 keydeploy								*Host requires  
------------------------------------------------------------------------------------------------------ 
 + For Package 
 
  - Package manage: You can install/remove a package as under the command 
		 install				[Package]   
				[-same]			[Package]	  
				[-downgrade]		[Package]	  
				[-stable]		[Package without version for latest package]	  
		 remove					[Package]	  
				[-force]		[Package]	  
...................................................................................................... 
 
  - Package view: You can see an installed packages/files/index & dependency 
		 list					[Blank for list-up]	  
				[-files]		[Package]	  
				[-files]		[/Dir/File-name]	  
				[-zicf]			[Package]	  
				[-dep]			[Package]	  
...................................................................................................... 
 
  - Package sync: You can try a sync the package set by a save file	ex) ~/z/save/zinst-* 
		 sync		[-file]			[Save fie for the Package set sync]	  
		 		[-url]			[Save fie from URL for the Package set sync]	  
  - Package restore: You can restore the package set by a save file for restore	ex) ~/z/save/zinst-* 
		 restore	[-file]			[Saved file_name]	  
				[-igor]			* Not available yet 
 
------------------------------------------------------------------------------------------------------ 
 + For Configuration 
 
  - Configuration: Zinst can helps to configure the setup without manual modify the Conf-file 
		 set					[Blank for list-up]			  
							[Package.option=value]			  
 
  - Configuration with Install: Configure the setup with the package install 
		 [Package]	-set 			[Package.option=value]  
 
------------------------------------------------------------------------------------------------------ 
 + For System manage 
 
  - Daemon control: You can control the daemon from the /etc/init.d/ directory 
		 start/stop/restart			[Daemon_name]	  
		 on/off					[Daemon_name]	  
...................................................................................................... 
 
  - Crontab manage: You can touch the cron schduler by zinst 
		 crontab	[-e]						  
				[-l] 
 
------------------------------------------------------------------------------------------------------ 
 + For install available package find 
 
  - Package find 
		 find		[Blank for list-up]			 
				[Package]		 
 
------------------------------------------------------------------------------------------------------ 
 + For tracking the released package 
 
  - Track the package 
		 track		[Blank for list-up]			 
				[Package or hostname]		 
				[Package or hostname]	[-file] 	 
				[Package or hostname]	[-file=Export_File_name]	 
				"user" or "sudo_user"	 
				[User_Package_name]	[-file] 	 
				[User_Package_name]	[-file=Export_File_name]	 
------------------------------------------------------------------------------------------------------ 
 + View history 
 
		 history	[Number of Range] 
...................................................................................................... 
 
		 -pass					 Option for Multi-host password automation
		 self-update			 
		 self-config	ip=x.x.x.x host=xxx.xxx.xxx			 
		 -version			 
 
		 *, help		 
------------------------------------------------------------------------------------------------------ 
 -h is target host, -H is targe file of hostlist 
 ex) zinst i sample-1.0.0.zinst -h web01.news.kr[1,3]  web[03-12].news[1,3] 
 ex) zinst i sample-1.0.0.zinst -H ./server_list.txt 
------------------------------------------------------------------------------------------------------ 
 
 
 
Example)
zinst ssh 'cat /etc/hosts;pwd' -h web[01-09].test.com	: Send a command to seperated hosts 
 
zinst mcp ./test.* /data/var/ -h web[01-09].test.com 	: File copy to seperated hosts 
 
zinst install hwconfig -stable			: for package apply as a latest version automatically 
 
zinst install hwconfig-1.0.2.zinst -same		: for overwrite the package as a same version 
zinst i hwconfig-1.0.2.zinst -downgrade			: for downgrade the package as a lower version 
 
zinst list -files hwconfig				: list-up file of the hwconfig package 
zinst ls -files /data/bin/hwconfig			: find a package as a file 
zinst list -zicf hwconfig				: see the index file of package 
zinst ls -dep hwconfig 					: package dependency check 
 
zinst set						: list-up of zinst current setups 
zinst set hwconfig.nameserver1=1.1.1.1			: change the setup nameserver1=1.1.1.1 to the hwconfig 
 
zinst i hwconfig-1.0.2.zinst -set hwconfig.nameserver1=1.1.1.1 -set hwconfig.nameserver2=2.2.2.2 
 : change the setup nameserver1=1.1.1.1 and nameserver2=2.2.2.2 to the hwconfig with package install 
 
zinst restart httpd					: restart the httpd daemon by /etc/init.d/httpd file control 
 
zinst crontab -l 					: list-up the crontab scheduler 
zinst crontab -u root -l			: list-up the crontab scheduler for an user 
zinst cront -e	 					: edit the crontab scheduler 
 
zinst find						: list-up the available file for install 
zinst find hwcon					: list-up the available file for install as you typed 
 
zinst hist						: show the history 
zinst hist 300						: show the 300 lines history 
 
zinst self-update					: zinst command update( *Requires: Package dist server must has a zinst file) 
zinst  self-config ip=x.x.x.x host=xxx.xxx.xxx	: you can change the configuration what you want
 
zinst help						: Detail view the help 
 
=== For more detail: https://github.com/goody80/Ralf_Dev ===
 

```
### 명령어 입력 방식(DSL: Domain Specific Language)
* zinst의 DSL은 편리 및 직관성을 위해 다양한 형태의 입력을 지원합니다.
* 예를들어 install 또는 inst 또는 i 등으로 입력 하더라도 install 이라는 명령으로 인식하게 되어있습니다
 * install: install, inst, i
 * remove: remove, rm
 * list: list, ls
 * history: history, hist
 * crontab: crontab, cront

### self-config
* Default 구성으로 zinst repository는 github.io을 사용합니다. 하지만 서비스 운영을 위해 자체 Package를 생성 및 관리하기 위한 목적으로 자체 repository를 구축 할 수 있습니다.
* 이때, repository의 변경을 위해 self-config가 사용됩니다.
```
$ zinst self-conf host=package.dist.test.com ip=192.168.10.1
```

## 원격 시스템군 관리하기
### ssh with zinst
* 앞서 개요에서 설명한것과 같이 zinst는 복수개 이상의 대량의 서버군에 특정 명령어를 수행하고 관리하는 목적에 주안점을 두고 있습니다.
* 따라서, 한줄의 명령으로 복수개 이상의 리눅스 시스템에 명령을 전달 할 수 있습니다
```
$ zinst ssh 'rm -f /data/tmp/*.log' -h 192.168.1.1[01-99] -H web_hosts.list
```

### scp with zinst
* 아래와 같이 간단한 명령어 한줄을 통해 원격지에 있는 서버군에 로컬 서버에 있는 파일을 뿌릴 수도 있습니다.
```
$ zinst mcp ./test/* /data/src/test/ -h 192.168.1.1[01-99]
```
***위 예제에서 확인되는 `-h` option을 통해 대상 host를 정규표현식 형태로 표현하여 적용이 가능하며, `-H` option을 통해 이미 구성된 host list를 적용 할 수 있습니다.***
```
$ cat ./web_hosts.list
192.168.3.1
192.168.3.2
192.168.3.3
192.168.3.4
192.168.3.[6-10]
192.168.[4,6].[1,2][0-9]
```

## 패키지 설치 및 관리하기
### find
* 설치가 가능한 package 내역은 아래와 같이 `fine` command를 통해 해당 repository의 정보를 받아옵니다.
```
$ zinst find
MariaDB_client-5.5.33.zinst
MariaDB_server-5.5.33.zinst
asciinema-1.1.1.zinst
bzr_64-2.1.1.zinst
centos_heartbeat_el5-1.0.1.zinst
centos_mond_el5-1.0.0.zinst
cloudera_flume_conf_zum-1.0.0.zinst
cloudera_flume_master-0.9.4+25.40-1.zinst
cloudera_flume_node-0.9.4+25.40-1.zinst
.
.
.
```

* 특정 package에 대한 검색은 아래와 같습니다.
```
$ zinst find mysql
ralfyang_mysql_backup-1.0.2.zinst
mysql_check_realtime_select-1.0.0.zinst
mysql_check_slow_query-1.0.0.zinst
mysql_client_55-1.0.2.zinst
mysql_rpmserver_conf-0.0.1.zinst
mysql_server-5.5.10.7.zinst
mysql_server_test_tool-0.1.0.zinst
```

### install
[![RecordIt](http://g.recordit.co/zZwHeiiRqh.gif)](http://recordit.co/zZwHeiiRqh)
* `zinst find`를 통해 설치가능한 package가 확인되면 해당 package를 `install` 명령을 통해 설치가 가능합니다.
```
$ zinst i hwconfig-1.3.3.zinst
```

* 버젼 명시 없이, 최신 pacakge로 설치를 원할 시, `-stable` option을 통해 버젼명 생략이 가능합니다.
```
$ zinst i hwconfig -stable
```

* 한번에 여러 package를 설치 할 수 있으며, 상호 의존성이 있는 package에 대해서는 정렬 순서를 지켜야 합니다.
* 이때, `-stable` option을 통해 자동 정렬 할 수 있습니다.
```
$ zinst i sudo_user_test002-0.0.1.zinst user_test002-0.0.1.zinst -stable
```

* 위와 같은 조합으로 대량의 서버군에 설치를 진행 할 수 있습니다.
```
$ zinst i sudo_user_test002-0.0.1.zinst user_test002-0.0.1.zinst -stable -H web_hosts.list
```

### list
* 설치 내역에 대한 확인은 아래와 같습니다.
```
$ zisnt ls

2015-08-19 19:48:55  -   asciinema-1.1.1
2015-09-03 11:40:05  -   docker_engine-1.7.1
2015-07-20 22:24:15  -   git_tool-1.0.1
2015-06-10 15:56:37  -   gs_nmap-0.0.1
2015-07-28 15:40:32  -   gs_nodejs-0.0.1
```
* 위와 같이 설치된 package명과 버젼, 설치 일자등을 확인 할 수 있습니다.
* 설치된 package수가 많아서 특정 package만 검색하고 싶을 경우 아래와 같이 특정 package명을 추가 해 주시면 됩니다.
```
$ zinst ls vipctl

2015-09-15 15:54:45  -   vipctl-1.0.5
```

* 해당 Package의 구성 파일을 확인 할 수 있습니다.
```
$ zinst ls -files vipctl

/data/bin/vipctl
/data/src/html/.status
/data/var/status
/data/conf/vipctl.conf
```

* 위와 반대로 특정 file이 어떤 Package에 의해서 설치 되었는지 확인이 가능 합니다. 이때, 해당 file의 디렉토리명을 입력합니다.(상대경로 가능)
```
$ zinst ls -files /data/bin/vipctl

vipctl-1.0.5  <-------   /data/bin/vipctl
```

* 해당 Package의 구성을 위한 인덱스 파일(zicf: Zinst Index Configuration File)의 내역을 확인 할 수 있습니다.
```
$ zinst ls -zicf vipctl

## Package information
PACKAGENAME = vipctl
VERSION = 1.0.5
AUTHORIZED = ralf.yang@ralfyang.com
DESCRIPTION = 'Create the loopback and network startup for the vip grouping - update for status page'
CUSTODIAN = ralfyang-eit-team

#Global setting of the files
OWNER = root
GROUP = wheel
PERM = 775


### Regular Syntax
### Based root Directory = /data/
.
.
.
```

* 해당 Package의 의존성 Check를 할 수 있습니다.
```
$ zinst ls -dep server_default_setting

server_default_setting - package has a dependency with ( ralfyang_account_policy )
```

### remove
* 설치된 Package의 제거를 위해 remove를 사용 합니다.
```
$ zinst remove vipctl

removed `/data/bin/vipctl'
removed `/data/src/html/.status'
removed `/data/var/status'
removed `/data/conf/vipctl.conf'
removed `/data/zinst/vipctl'
removed `/data/vault/Source/vipctl-1.0.5/bin/vipctl'
removed `/data/vault/Source/vipctl-1.0.5/bin/vipctl.conf'
removed directory: `/data/vault/Source/vipctl-1.0.5/bin'
removed `/data/vault/Source/vipctl-1.0.5/status'
removed `/data/vault/Source/vipctl-1.0.5/vipctl.zicf'
removed `/data/vault/Source/vipctl-1.0.5/.file.list'
removed directory: `/data/vault/Source/vipctl-1.0.5'
########## vipctl-1.0.5 package has been removed ######## 
```

* 의존성이 걸린 Pacakge를 삭제 시도 할 경우, 해당 Package를 바라보고 있는 pacakge를 먼저 삭제 해 주어야 합니다. 이때 `-force` option을 통해 의존성에 대한 문제를 무시하고 강제로 삭제 할 수 있습니다.
* 위와 같은 부분은 권장하지 않는 부분이나, 때에 따라 필요 할 경우 제한적으로 사용 할 수 있습니다.


## 패키지 제작하기
### zicf(Zinst index configuration file)의 이해
* RPM 제작에 사용되는 .spec 파일 처럼, zinst package도 file 및 configuration, command, cron scheduler를 위해 설명을 다루는 파일이 필요합니다.
* 이 파일을 .zicf로 구분합니다.
* zicf 파일은 package 설치 후 재사용이 가능하도록 package의 원천 Source를 저장하는 공간에 위치 합니다.
 * 일반적으로 /data/vault/Source 하위에 위치
* zinst Source 디렉토리에서 과거 설치가 이루어졌던 pacakge에 대한 내역을 확인 할 수 있으며, 당시 package를 zicf를 통해 다시 Build 할 수 있습니다.

### zicf 예제
![예제](http://cfile30.uf.tistory.com/image/236ED54B55F7C6611CF52E)

### Zicf 구조
#### Package 기본 정보
* `OS`: 해당 Package가 설치 될 OS의 종류를 입력 합니다. rhel, ubuntu, osx, freebsd중 하나를 입력 합니다.
* `PACKAGENAME`: 해당 Package의 이름이며, zicf파일과 같아야 합니다. vipctl.zicf 일 경우, 해당 `PACKAGENAME`은 vipctl이 됩니다.
* `VERSION`: 현재 Package의 Version을 나타내며 0.1.2와 같이 점 세개로 Major-Minor를 update를 구분 합니다.
* `AUTHORIZED`: Package의 제작자 또는 최종 수정자의 email을 입력합니다.
* `DESCRIPTION`: 해당 Package에 대한 간단한 내용을 기록합니다.
* `CUSTODIAN`: 해당 Package의 관리 책임이 있는 Group을 지정합니다.

#### Global 권한설정
* 해당 부분은 Default로 적용되는 Global Permission을 지정합니다.
* File의 경로 설정 부분에서 File별로 세부 권한 할당이 가능하며, 권한 할당이 없이 `-` 처리 할 시 Default값으로 해당 Global Permission을 따르게 됩니다.
 * OWNER: 권한이 있는 Default user 
 * GROUP = 권한이 있는 Default group
 * PERM = File의 기본 Permission을 지정하며, 8진수로 권한을 설정 합니다.(예. User 및 Group의 모든권한 및 모든사용자의 읽고,실행 할 수 있는 권한: 775)

#### 개별 파일 설정
* 개별 파일의 설정은 순서에 따라 아래와 같습니다.
* 첫번째 단락: Option type을 지정하며, 대문자로 FILE, CONF, SYMB, CRON을 지정 할 수 있습니다.
 * FILE: 복사되는 static한 file 입니다.
 * CONF: zinst set을 통해 설정을 변경 할 수 있게 하기 위해 CONF로 명시합니다.
 * SYMB: file의 복사 없이, 이미 복사된 file을 기준으로 Symbolic link를 생성 할 수 있습니다.
 * CRON: Crontab scheduler에 설정을 지정 할 수 있습니다.
* 권한설정 단락
 * File Permission: 권한설정을 8진수를 통해 설정 가능하며, default를 원할 시 `-`로 표기
 * File Owner: 유저권한 할당을 할 수 있으며, default를 원할 시 `-`로 표기
 * File Group: 그룹권한 할당을 할 수 있으며, default를 원할 시 `-`로 표기
* 경로 단락
 * 설치 목적지 경로: 파일이 복사되어야 할 대상 경로
 * Packaging을 위한 소스 경로: Package 제작을 위해 현재 zicf 파일이 있는 위치에서 확인 가능한 Source 경우

#### 부과설정
* 변경 가능한 Configure 값의 Default값을 할당 합니다. 
 * ZINST set [변수명] [Default 값]
* Package 의존성을 위해, 해당 Package 설치 전에 설치되어야 하는 Package를 지정 해 줍니다.
 * ZINST requires pkg [필요한 Package명]
* Package 설치 후 최초로 실행 해 주어야 하는 명령어등을 추가 할 수 있습니다.
 * COMM [shell command]


### pkg_gen
[![asciicast](https://asciinema.org/a/9lxngabxyei2ticl44gqkm8tz.png)](https://asciinema.org/a/9lxngabxyei2ticl44gqkm8tz)
* 위에서 다뤘던 zicf 파일에 대한 이해가 충분 할 경우, Package를 만드는데 어려움이 없을것입니다.
* 하지만, 좀 더 쉬운 Package 제작을 위해 zicf를 자동으로 생성 해 주는 명령어가 있습니다.
* `zinst_making_tool` Package 설치 후 사용 할 수 있습니다.
```
$ zinst i zinst_making_tool -stable
```
* Package를 제작하고자 하는 디렉토리 경로에서 아래와 같이 입력 하여 Package 제작을 위한 zicf를 생성 해 줍니다.
```
$ pkg_gen make

 === Please insert an information for the index file create ===
 
 * [ Package name: Default=vipctl-1.0.5 ] =
 ! Notice: You only can use a package name with Alphabet, Number, _(underscore) combination
      
 
 * [ Description] =

 
 * [ Version: Default=0.0.1 ] = 

 
 * [ Default Owner: Default=root ] = 

 
 * [ Default Group: Default=wheel ] = 

 
 * [ Defaut Permission: Default=664 ] = 

 
 Do you need a some command when this pacakge removed ?
 * [ y/n : Default=n ] = 

 
 Do you have a required pacakge ?
 * [ y/n : Default= n ]
```
* 위와 같이 기본적인 정보등을 대화식 입력으로 처리 합니다.

### zinst_creator
* 제작된 zicf 파일을 통해서 zinst package 제작을 진행 합니다.
```
$ zinst_creator vipctl.zicf 

Making a package..... /data/vault/Source/vipctl-1.0.5/vipctl-1.0.5.zinst
TOTAL: 0.120000 sec
```
* 이때 해당 zicf가 있는 경로에서 실행하며, 디렉토리 구문자는 사용하지 않습니다.(ex. /home/test/aaa.zicf -> cd /home/test;zinst_creatore aaa.zicf)


### rpm2zinst: Redhat계열  or deb2zinst: debian계열
* 현재 설치가 된 RPM package를 zinst package로 con-version 할 수 있습니다.
```
$ rpm2zinst wget

##############################################################################
What you want package is wget-1.12-5.el6_6.1.x86_64 right? [ y / n ]
##############################################################################
y

##############################################################################
      wget-1.12-5.el6_6.1.x86_64.tgz package has been created
##############################################################################
 
 === Please insert an information for the index file create ===
 
 * [ Package name: Default=wget-1.12-5.el6_6.1.x86_64 ] =
 ! Notice: You only can use a package name with Alphabet, Number, _(underscore) combination
wget_custom
 
 * [ Description] =

 
 * [ Version: Default=0.0.1 ] = 

 
 * [ Default Owner: Default=root ] = 

 
 * [ Default Group: Default=wheel ] = 

 
 * [ Defaut Permission: Default=664 ] = 

 
 Do you need a some command when this pacakge removed ?
 * [ y/n : Default=n ] = 

```
* ※ 데비안 계열에서는 deb2zinst로 사용

## 설치된 패키지 구성 관리하기
### sync
* zinst는 package 설치 내역에 대한 revision을 별도 관리 합니다.
* /[work_dir]/z/save 경로에는 설치에 따른 Package 구성 및 set 구성의 기록이 남아 있습니다.
 * `work_dir`은 일반적으로 /data
* `.save` file 형태이며, 아래와 같습니다.
```
$ cat /data/z/save/zinst-save.99

# --- Last touched by ralf.yang      --- 
# --- Last command " zinst i sshpass -stable " 
# Date: 2015.09.15_13:27:31 
#
# zinst package installer all-configuration backup-list for the package restore
Package install asciinema-1.1.1.zinst
Package install docker_engine-1.7.1.zinst
Package install git_tool-1.0.1.zinst
Package install gs_nmap-0.0.1.zinst
Package install gs_nodejs-0.0.1.zinst
Package install ralfyang_account_policy-1.0.7.zinst
Package install ralfyang_authorize_client-1.0.2.zinst
Package install ralfyang_httpd_conf_pkgdist-1.0.3.zinst
Package install ralfyang_httpd_server-2.4.12.zinst
Package install hwconfig-1.3.3.zinst
Package install ldap_server-1.0.5.zinst
Package install libcgroup-0.4.0.zinst
Package install linux_kernel-3.10.25.zinst
Package install mysql_client_55-1.0.3.zinst
Package install package_tracker-1.0.6.zinst
Package install server_default_setting-1.2.8.zinst
Package install sshpass-1.0.5.zinst
Package install sudo_user_canopus-0.0.1.zinst
Package install sudo_user_gravity-0.0.1.zinst
Package install sudo_user_kim.so-0.0.1.zinst
Package install sudo_user_parkdy-0.0.1.zinst
Package install sudo_user_ralf.yang-0.0.2.zinst
Package install sudo_user_vivek-0.0.1.zinst
Package install user_account_creator-0.1.0.zinst
Package install user_canopus-0.0.1.zinst
Package install user_gravity-0.0.1.zinst
Package install user_kim.so-0.0.1.zinst
Package install user_parkdy-0.0.1.zinst
Package install user_ralf.yang-0.0.2.zinst
Package install user_vivek-0.0.1.zinst
Package install zinst_making_tool-1.2.3.zinst
- - - 
Package setting server_default_setting.name1=8.8.8.8
Package setting server_default_setting.name2=168.126.63.1
Package setting package_tracker.RotateCycle=30
Package setting package_tracker.Downcheck=14
Package setting ralfyang_authorize_client.BaseDN=dc=gravity,dc=gs
Package setting zinst_making_tool.mailing=ralfyang.com
Package setting git_tool.Branch=gh-pages
Package setting hwconfig.nameserver1=8.8.8.8
Package setting hwconfig.nameserver2=168.126.63.1
Package setting ralfyang_httpd_conf_pkgdist.ServerName=package.dist.ralfyang.com
Package setting ralfyang_httpd_conf_pkgdist.DocumentRoot=/data/dist
Package setting ldap_server.BindDN="dc=gravity,dc=gs"
Package setting ralfyang_authorize_client.LDAPserver=192.168.59.104
```
* 위 save file을 통해 해당 시점에 마지막으로 실행 된 command와 설치가 된 이후의 package 및 설정의 내역을 기록하여 두었습니다.
* 이를 바탕으로, package 및 set을 동기화 할 수 있습니다.
* 아래 command를 통해 `zinst-save.99` 파일이 기록된 시점으로 package 구성을 동기화 할 수 있습니다.
```
$ zinst sync -file ./zinst-save.99

=======================================================================================
= Target list for remove                                                              =
=======================================================================================
> Package remove vipctl-1.0.5.zinst
> Package setting vipctl.Check_file=l4-check.html
> Package setting vipctl.DIR=/data/src/html
> Package setting vipctl.name=DEFAULT
> Package setting vipctl.onboot=yes
> Package setting vipctl.vips=VIPS
=======================================================================================

=======================================================================================
= Target list for install & setting                                                   =
=======================================================================================
< Package install sshpass-1.0.5.zinst
=======================================================================================

 === Package & setting will be install & remove as upper list. Are sure ? === [y / n]
```

### restore
* 위 sync option을 사용 했을 시, `save` 파일을 기준으로, 변경내역을 적용 해 주는 역할을 합니다.
* 하지만 restore를 사용하면, 기존 package를 모두 삭제 후, `save` file을 기준으로 재설치를 진행 합니다.
* 작업자가 직접 conf 파일등을 수정하여 이력 추적이 불가능한 상태에서 초기화 하는 용도로 `restore`를 사용 할 수 있습니다.
```
$ zinst restore -file ./zinst-save.107

zinst install asciinema-1.1.1.zinst
zinst install docker_engine-1.7.1.zinst
zinst install git_tool-1.0.1.zinst
zinst install gs_nmap-0.0.1.zinst
zinst install gs_nodejs-0.0.1.zinst
zinst install ralfyang_account_policy-1.0.7.zinst
zinst install ralfyang_authorize_client-1.0.2.zinst
zinst install ralfyang_httpd_conf_pkgdist-1.0.3.zinst
zinst install ralfyang_httpd_server-2.4.12.zinst
zinst install hwconfig-1.3.3.zinst
zinst install ldap_server-1.0.5.zinst
zinst install libcgroup-0.4.0.zinst
zinst install linux_kernel-3.10.25.zinst
zinst install mysql_client_55-1.0.3.zinst
zinst install package_tracker-1.0.6.zinst
zinst install server_default_set-1.2.8.zinst
zinst install sudo_user_canopus-0.0.1.zinst
zinst install sudo_user_gravity-0.0.1.zinst
zinst install sudo_user_kim.so-0.0.1.zinst
zinst install sudo_user_parkdy-0.0.1.zinst
zinst install sudo_user_ralf.yang-0.0.2.zinst
zinst install sudo_user_vivek-0.0.1.zinst
zinst install user_account_creator-0.1.0.zinst
zinst install user_canopus-0.0.1.zinst
zinst install user_gravity-0.0.1.zinst
zinst install user_kim.so-0.0.1.zinst
zinst install user_parkdy-0.0.1.zinst
zinst install user_ralf.yang-0.0.2.zinst
zinst install user_vivek-0.0.1.zinst
zinst install vipctl-1.0.5.zinst
zinst install zinst_making_tool-1.2.3.zinst
zinst set server_default_set.name1=8.8.8.8
zinst set server_default_set.name2=168.126.63.1
zinst set package_tracker.RotateCycle=30
zinst set package_tracker.Downcheck=14
zinst set ralfyang_authorize_client.BaseDN=dc=gravity,dc=gs
zinst set zinst_making_tool.mailing=ralfyang.com
zinst set git_tool.Branch=gh-pages
zinst set hwconfig.nameserver1=8.8.8.8
zinst set hwconfig.nameserver2=168.126.63.1
zinst set ralfyang_httpd_conf_pkgdist.ServerName=package.dist.ralfyang.com
zinst set ralfyang_httpd_conf_pkgdist.DocumentRoot=/data/dist
zinst set ldap_server.BindDN="dc=gravity,dc=gs"
zinst set ralfyang_authorize_client.LDAPserver=192.168.59.104
zinst set vipctl.name=DEFAULT
zinst set vipctl.vips=VIPS
zinst set vipctl.onboot=yes
zinst set vipctl.DIR=/data/src/html
zinst set vipctl.Check_file=l4-check.html
 
 Do you want to restore as these list ? [ y / n ]
```

## 시스템 구성 관리하기
### set for configuration
* zinst를 Package화 하여 관리했을때 가장 강점을 갖는 부분이 이 부분 입니다.
* RPM과 다르게 zinst는 package를 Static하게만 관리 하지 않고, 동적으로 설정 변경이 가능하게 제작 되었습니다.
* `zinst set`이라는 command를 통해 변경 가능한 list를 조회 할 수 있습니다.
```
$ zinst set

package_tracker.RotateCycle=30
package_tracker.Downcheck=14
ralfyang_authorize_client.BaseDN=dc=gravity,dc=gs
zinst_making_tool.mailing=ralfyang.com
git_tool.Branch=gh-pages
hwconfig.nameserver1=211.44.62.40
hwconfig.nameserver2=168.126.63.1
ralfyang_httpd_conf_pkgdist.ServerName=package.dist.ralfyang.com
ralfyang_httpd_conf_pkgdist.DocumentRoot=/data/dist
ldap_server.BindDN="dc=gravity,dc=gs"
ralfyang_authorize_client.LDAPserver=192.168.59.104
vipctl.name=DEFAULT
vipctl.vips=VIPS
vipctl.onboot=yes
vipctl.DIR=/data/src/html
vipctl.Check_file=l4-check.html
```
* Set list의 확인 후 해당 설정을 변경 할 수 있습니다. 이때, zicf에 명시된 `CONF` 파일을 찾아가서 자동으로 해당 설정을 변경 적용 합니다.
```
$ zinst set vipctl.vips=192.168.10.10

vipctl.vips=192.168.10.10
```
* 위에서 보는것과 같이 `vipctl`은 package를 뜻하며, 그 뒤에 `.vips`는 해당 Package에서 지정한 Virtual IP를 무엇으로 받을 것인가 하는 변수를 뜻합니다. `=192.168.10.10`는 해당 변수에 할당 할 변수 값을 뜻합니다.
* 위 작업을 통해서 설정이 아래와 같이 변경 되었습니다.
```sh
$ cat /data/conf/vipctl.conf

name=DEFAULT
vips=192.168.10.10
onboot=yes
DIR=/data/src/html
Check_file=l4-check.html
```
* 해당 set 값일 미리 알고 있을시에는 package 설치 시, 작업을 동시에 실행 할 수 있습니다.
```
$ zinst i vipctl -stable -set vipctl.vips=192.168.10.10 -set vipctl.name=test

===========================================================================
| vipctl-1.0.5.zinst                                        | - Checked   |

----- vipctl-1.0.5.zinst -----
 Downloading...
######################################################################## 100.0%
 [:: 1896 byte has been downloaded ::]
 vipctl-1.0.5 package install ==>>> 
/data/bin/vipctl
/data/src/html/.status
/data/var/status
 --- File Initializing ...
 --- Permission Initializing ...
 --- Setting the Group  ...
vipctl-1.0.5 package has been installed
vipctl.vips=192.168.10.10
vipctl.name=test

$ zinst set  |grep vipctl

vipctl.onboot=yes
vipctl.DIR=/data/src/html
vipctl.Check_file=l4-check.html
vipctl.vips=192.168.10.10
vipctl.name=test
```
* 이처럼 설치와 함께 set 변경이 있을 경우 `-set`으로 구분지어 줍니다. 변경 하고자 하는 set이 많을 경우, 계속해서 `-set`을 붙여서 복수개의 설정을 변경 할 수 있습니다.
* 위 설치 과정을 복수개의 서버에 적용 하고자 할 때에는 `-h` option을 사용하여 여러대의 장비에 적용 할 수 있습니다.
```
$ zinst i vipctl -stable -set vipctl.vips=192.168.10.10 -set vipctl.name=test -h 192.168.33.1[1-5]
```

### Crontab 조회 및 설정 관리
* 설치된 Package의 cron scheduler를 확인 및 수정 할 수 있습니다.
```
$ zinst cront -u root -l

##package_tracker-1.0.6 Cron Scheduler
*/10 * * * * /data/bin/package_tracker  #package_tracker
##package_tracker-1.0.6 Cron Scheduler
01 05 * * * /data/bin/accesslog_rotate  #package_tracker
##package_tracker-1.0.6 Cron Scheduler
01 04 * * * /data/bin/track_purge.sh  #package_tracker
##zinst_making_tool-1.2.3 Cron Scheduler
0 7 * * * /data/bin/indexmaker.sh  #zinst_making_tool
```

* 수정 시
```
$ zinst cront -u root -e

##package_tracker-1.0.6 Cron Scheduler
*/10 * * * * /data/bin/package_tracker  #package_tracker
##package_tracker-1.0.6 Cron Scheduler
01 05 * * * /data/bin/accesslog_rotate  #package_tracker
##package_tracker-1.0.6 Cron Scheduler
01 04 * * * /data/bin/track_purge.sh  #package_tracker
##zinst_making_tool-1.2.3 Cron Scheduler
0 7 * * * /data/bin/indexmaker.sh  #zinst_making_tool
~                                                                                            
~
```

## 시스템 운영하기
### start/stop/restart
* System Daemon을 가동 할 수 있도록 별도의 option을 통한 command를 지원 합니다.
```
$ zinst start httpd
```
* 위 command는 `sudo service httpd start` 형태로 전환되어 실행 됩니다.
* 즉 /etc/init.d/ 하위에 있는 디렉토리에 있는 모든 daemon 관리 파일을 handling 할 수 있습니다.
* 이때 `-h`또는 `-H` option을 통해 다수의 장비의 daemon을 한번에 관리 할 수 있게 해 줍니다.
```
$ zinst start httpd -h 192.168.33.1[1-5]
```

### on/off
* 일부 Package의 기능상 구현을 위해 on/off command를 지원합니다.
* vipctl의 경우, L4-status check 파일의 제어를 위해 on/off command를 사용 합니다.
```
$ zinst on vipctl

 Status file - [ok]
```

### history
* Zinst를 통해 적용된 command는 `zinst hist`를 통해 조회가 가능합니다. 이때 출력을 원하는 줄 수를 입력하면 해당 숫자 만큼 출력합니다.
```
$ zinst hist 100
2015.09.01_14:00:36	 ralf.yang      : + Install - user_canopus-0.0.1 -stable
2015.09.01_14:00:37	 ralf.yang      : + Install - sudo_user_canopus-0.0.1 -stable
2015.09.01_14:01:13	 ralf.yang      :  * setup  - ralfyang_authorize_client.LDAPserver=192.168.59.104  
2015.09.01_14:01:24	 ralf.yang      : # Daemon restart - ldap_client  
			 ralf.yang      : #     - Daemon Not working: [ OK ] 
2015.09.03_11:15:59	 ralf.yang      : # Daemon stop - docker  
			 ralf.yang      : #     - Daemon Not working:  
2015.09.03_11:16:09	 root           : # Daemon stop - docker  
			 root           : #     - Daemon Working: /data/bin/docker: no process killed  
2015.09.03_11:16:10	 ralf.yang      : - Remove  - docker_io-1.6.6  
2015.09.03_11:16:30	 ralf.yang      : + Install - docker_engine-1.7.1 
2015.09.03_11:17:15	 ralf.yang      : - Remove  - docker_engine-1.7.1  
2015.09.03_11:17:32	 ralf.yang      : + Install - libcgroup-0.4.0 -stable
2015.09.03_11:17:36	 ralf.yang      : + Install - docker_engine-1.7.1 -stable
2015.09.03_11:17:41	 ralf.yang      : # Daemon start - docker  
			 ralf.yang      : #     - Daemon Working: [ OK ]  
2015.09.03_11:39:45	 ralf.yang      : # Daemon stop - docker  
			 ralf.yang      : #     - Daemon Not working: [ OK ] 
2015.09.03_11:40:07	 ralf.yang      : + Install - docker_engine-1.7.1 -same
2015.09.03_11:40:17	 ralf.yang      : # Daemon start - docker  
			 ralf.yang      : #     - Daemon Working: [ OK ]  
2015.09.07_16:57:39	 ralf.yang      : # Daemon restart - httpd  
			 ralf.yang      : #     - Daemon Working: [ OK ]  
2015.09.08_09:10:27	 ralf.yang      : # Daemon start - docker  
			 ralf.yang      : #     - Daemon Working: [ OK ]  
2015.09.14_16:17:12	 canopus        : + Install - user_kim.so-0.0.1 
2015.09.14_16:17:14	 canopus        : + Install - sudo_user_kim.so-0.0.1 
2015.09.15_13:26:44	 ralf.yang      : + Install - sshpass-1.0.5 -stable
2015.09.15_19:18:05	 ralf.yang      : # Daemon on - vipctl  
			 ralf.yang      : #     - Daemon Not working:  Status file - [ok] 
```

## 깊이 들어가보기
### getset
* package를 설치하기 이전에, 해당 package가 설정 가능한 `set` 값이 어떤것인지 알고자 할때 사용합니다. 이때 해당 package의 version을 포함한 full-name을 입력해야 합니다.
```
$ zinst getset hwconfig-1.3.3.zinst

hwconfig.nameserver1=211.44.62.40
hwconfig.nameserver2=168.126.63.1
```

### track
* zinst private repository를 구축한 경우 사용이 가능한 command 입니다.
* 자체적으로 zinst repo를 구축했을 시, 해당 repo를 통해 설치 된 package 및 적용 server에 대한 조회 및 내역 출력을 지원 합니다.
```
$ zinst track

Package has been released to below list - Sort by ""
====================================================================================================== 
Host                           Package                                        Date                           
======================================================================================================
110.52.167.188                 ralfyang_deploy_agent-0.0.9.zinst                 [06/Aug/2015:20:12:48]        
110.52.167.224                 vipctl-1.0.5.zinst                              [06/Aug/2015:20:13:27]        
110.52.167.224                 ralfyang_deploy_agent-0.0.9.zinst                 [06/Aug/2015:20:13:29]        
110.52.167.238                 vipctl-1.0.5.zinst                              [06/Aug/2015:20:14:06]        
110.52.167.238                 ralfyang_deploy_agent-0.0.9.zinst                 [06/Aug/2015:20:14:08]        
110.52.167.161                 vipctl-1.0.5.zinst                              [06/Aug/2015:20:14:45]        
110.52.167.161                 ralfyang_deploy_agent-0.0.9.zinst                 [06/Aug/2015:20:14:46]        
110.52.167.175                 vipctl-1.0.5.zinst                              [06/Aug/2015:20:15:19]        
110.52.167.175                 ralfyang_deploy_agent-0.0.9.zinst                 [06/Aug/2015:20:15:21]        
110.52.167.189                 vipctl-1.0.5.zinst                              [06/Aug/2015:20:15:56]        
110.52.167.189                 ralfyang_deploy_agent-0.0.9.zinst                 [06/Aug/2015:20:15:57]        
110.52.167.225                 vipctl-1.0.5.zinst                              [06/Aug/2015:20:16:31]        
110.52.167.225                 ralfyang_deploy_agent-0.0.9.zinst                 [06/Aug/2015:20:16:33]        
110.52.167.239                 vipctl-1.0.5.zinst                              [06/Aug/2015:20:17:09]
110.53.15.171                  vipctl-1.0.5.zinst                              [15/Sep/2015:18:14:48]        
====================================================================================================== 
```
* 특정 Package 별로 sort 가능 합니다.
```
$ zinst track vipctl
====================================================================================================== 
Host                           Package                                        Date                           
======================================================================================================
110.52.167.161                 vipctl-1.0.5.zinst                              [06/Aug/2015:20:14:45]        
110.52.167.175                 vipctl-1.0.5.zinst                              [06/Aug/2015:20:15:19]        
110.52.167.189                 vipctl-1.0.5.zinst                              [06/Aug/2015:20:15:56]        
110.52.167.225                 vipctl-1.0.5.zinst                              [06/Aug/2015:20:16:31]        
110.52.167.239                 vipctl-1.0.5.zinst                              [06/Aug/2015:20:17:09]        
====================================================================================================== 
```

* 특정 Host별 설치 내역 조회를 지원 합니다.
```
$ zinst track 110.52.167.189

Package has been released to below list - Sort by "110.52.167.189"
====================================================================================================== 
Host                           Package                                         Date                           
====================================================================================================== 
110.52.167.189                 hwconfig-1.3.3.zinst                            [05/Aug/2015:12:20:23]        
110.52.167.189                 server_default_setting-1.3.0.zinst              [05/Aug/2015:12:20:24]        
110.52.167.189                 ralfyang_account_policy-1.0.7.zinst               [05/Aug/2015:12:20:25]        
110.52.167.189                 ralfyang_authorize_client-1.0.6.zinst             [05/Aug/2015:12:20:27]        
110.52.167.189                 hosts_file_creator-0.0.2.zinst                  [05/Aug/2015:20:07:09]        
110.52.167.189                 ralfyang_tomcat-7.0.33.zinst                      [06/Aug/2015:14:55:11]        
110.52.167.189                 ralfyang_jennifer_agent-0.0.2.zinst               [06/Aug/2015:14:55:17]        
110.52.167.189                 ralfyang_jennifer_conf-0.0.2.zinst                [06/Aug/2015:14:55:20]        
110.52.167.189                 vipctl-1.0.5.zinst                              [06/Aug/2015:20:15:56]        
======================================================================================================
```

* `-file=` option을 사용하여, package가 적용 된 Host를 sort하고 이것을 Hostlist로 저장 할 수 있습니다.
```
$ zinst track vipctl-1.0. -file=./aaa
====================================================================================================== 
Host                           Package                                        Date                           
======================================================================================================
110.52.167.161                 vipctl-1.0.5.zinst                              [06/Aug/2015:20:14:45]        
110.52.167.175                 vipctl-1.0.5.zinst                              [06/Aug/2015:20:15:19]        
110.52.167.189                 vipctl-1.0.5.zinst                              [06/Aug/2015:20:15:56]        
110.52.167.225                 vipctl-1.0.5.zinst                              [06/Aug/2015:20:16:31]        
110.52.167.239                 vipctl-1.0.5.zinst                              [06/Aug/2015:20:17:09]        
====================================================================================================== 
 Hostlist file has been created to ./aaa 
======================================================================================================

$ cat ./aaa

110.52.167.161
110.52.167.175
110.52.167.189
110.52.167.225
110.52.167.239

```
* 출력된 Hostlist를 기반으로, update를 진행 해야하는 package가 적용 된 서버를 추출하여 별도 작업에 유용하게 사용 할 수 있습니다.
```
$ zinst i vipctl-1.0.7.zinst -H ./aaa
```

### self-update
* zinst 자체의 version을 update 관리 할 필요가 있습니다. 이때 아래와 같이 적용 합니다.
```
$ zinst self-update

 Downloading...
######################################################################## 100.0%
 [:: 87471 byte has been downloaded ::]
Zinst version 4.2.7
```

## Zinst 내부구조
### 디렉토리
* Default 디렉토리를 `/data`로 했을 경우 아래와 같은 디렉토리 구조를 가집니다.
```
/data
 ├ bin: Zinst Package 설치를 통해 실행 파일이 저장되는 위치
 ├ conf: Zinst Package 설치를 통해 설정 파일이 저장되는 위치
 ├ dist: 자체 Repository를 구축 했을 시, Package를 저장하는 공간
   ├ checker: zinst package 설치 전 의존성 및 상세 정보를 검토하기 위한 zicf 원격 저장소
   └ track_110.52.164.250: track 기능 활성화 시, 해당 Repo에는 Package 설치 이력을 해당 repo server의 IP로 구분하여 저장함
 ├ logs: 일반적으로 package를 통해 설치된 데몬이 운영시 log를 저장 하는 위치
 ├ src: Package에 포함된 외부 파일 등을 임시로 저장하는 위치
 ├ var: /var와 동일한 용도의 zinst 자체 var
 ├ vault: Zinst 자체의 기능을 운영하기 위해 사용하는 Source 저장소
   ├ Source: 삭제된 Package를 제외하고, 해당 서버에 설치되었던 package 이력을 모두 저장
   └ zinst: zinst set 값을 기록하고 관리하는 위치
     └ index: Package 설치전 의존성 확인을 위해 zicf를 다운받는 위치
 ├ z: Application 및 Linux System을 컨트롤 하기 위해 /etc, /usr, /bin 등을 심볼릭으로 링크 한 경로
 └ zinst: 설치된 zinst package의 최신 경로를 심볼릭으로 링크를 걸어둔 경로
```

### Nas를 활용한 dist 디렉토리 구성방안
### 주요 Cron job
 * package_tracker

## 활용 예제
### ex1) Dockerized system
### ex2) Backup solution [client / server]
### ex3) vip loopback control
### ex4) kernel update
### ex5) hosts file manager
### ex6) web server 구축하기
### ex7) tomcat server 구축하기
### ex8) Sudoers/OpenLDAP을 이용한 계정 정책 및 관리 시스템 구축하기
### ex9) 무중단 배포 시스템 구축하기
### ex10) iptables_port_forwarding 패키지를 이용한 간단한 port forwarding





