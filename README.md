[![asciicast](https://asciinema.org/a/3b6111luruun70bmui5n887gf.png)](https://asciinema.org/a/3b6111luruun70bmui5n887gf)
Simple install Video by asciinema

* You just can type this command
 * curl -sL http://bit.do/online-install | sh

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


![http://ralfyang.com](http://cfile1.uf.tistory.com/image/2565453E55E52DFF1DACD6)
# Zinst 메뉴얼
## 개요
* zinst는 분산된 서버군의 효율적인 관리와 제어를 위해 개발 되었습니다. 예를 들어 특정 리눅스 장비 하나를 관리용도의 메니저 서버로 구성 한 다음, 해당 서버에서 다른 서버로 ssh를 통해 접속이 가능하다면, 한번의 명령어를 바탕으로 복수개의 서버를 관리 할 수 있습니다.
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
curl -sL bit.do/online-install | sh
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
* zinst는 `man-page` 대신, 자체 manual을 command를 통해 확인 할 수 있습니다.
```
$ zinst

------------------------------------------------------------------------------------------------------ 
	zinst	[Command]	[Option Types]		[Target Names]	[-h or -H]	[Targe Host] 
------------------------------------------------------------------------------------------------------ 
		 ssh		[Command]						*Host requires	  
...................................................................................................... 
		 mcp		[local-files]		[Destination DIR]		*Host requires 
------------------------------------------------------------------------------------------------------ 
		 install				[Package]   
				[-same]			[Package]	  
				[-downgrade]		[Package]	  
				[-stable]		[Package without version]	  
		 remove					[Package]	  
				[-force]		[Package]	  
...................................................................................................... 
		 list					[Blank for list-up] or [Package]  
				[-files]		[Package] or [/DIR/File-name]	  
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
		 start/stop/restart			[Daemon_name]	  
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
gsshop_mysql_backup-1.0.2.zinst
mysql_check_realtime_select-1.0.0.zinst
mysql_check_slow_query-1.0.0.zinst
mysql_client_55-1.0.2.zinst
mysql_rpmserver_conf-0.0.1.zinst
mysql_server-5.5.10.7.zinst
mysql_server_test_tool-0.1.0.zinst
```

### install
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
* 

### remove

## 패키지 제작하기
### zicf(Zinst index configuration file)의 이해
### pkg_gen
### rpm2zinst

## 설치된 패키지 구성 관리하기
### sync
### restore

## 시스템 구성 관리하기
### set for configuration
### crontab

## 시스템 운영하기
### start/stop/restart
### on/off
### history

## 깊이 들어가보기
### getset
### track
### self-update

## Zinst 내부구조
### 디렉토리
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



[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/goody80/ralf_dev/trend.png)](https://bitdeli.com/free "Bitdeli Badge")



[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/goody80/ralf_dev/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

