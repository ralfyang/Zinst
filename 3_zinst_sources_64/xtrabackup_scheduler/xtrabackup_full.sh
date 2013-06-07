#!/bin/bash
Clearlog=4
PATH=/data/mysql/bin:/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/data/bin
innobackupex --user=root  --password=`cat /data/conf/keydb/mysqlroot.keydb |awk -F "=" '{print $2}'` --no-timestamp --slave-info --defaults-file=/tmp/my.cnf /data/Backup/DB_Full-`hostname`_`date +%Y-%m-%d`
tar zcvf /data/Backup/DB_Full-`hostname`_`date +%Y-%m-%d`.tgz /data/Backup/DB_Full-`hostname`_`date +%Y-%m-%d`
rm -Rf /data/Backup/DB_Full-`hostname`_`date +%Y-%m-%d`
rm -Rf /data/Backup/DB_Full-`hostname`_`date -d "$Clearlog day ago" +%Y-%m-%d`.tgz

