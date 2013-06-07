#!/bin/bash


Option=$1
Option2=$2


	if [[ $Option = "make" ]]
	then
		Tar="package_creator.tgz"
		PWD=`pwd`
		zicf=`echo $PWD |awk -F '/' '{print $NF}'`
		zicfN="$zicf.zicf"
    
		## Make sure the work directory
		cd $PWD
    
		tar zcvf ./$Tar ./*
		tar tfv $Tar > ./listup
    
		echo "" > ./perm.txt
		## ==================  Create zicf base file =================
		echo "" > ./$zicfN
		echo "### Package infomation" >> ./$zicfN
		echo "#PACKAGENAME = $zicf" >> ./$zicfN
		echo "#VERSION = 1.0.0" >> ./$zicfN
		echo "#AUTHORIZED = AUTH@gsshop.com" >> ./$zicfN
		echo "#DESCRIPTION = 'Please insert a description for this package'" >> ./$zicfN
		echo "#CUSTODIAN = gsshop-eit-team" >> ./$zicfN
		echo "" >> ./$zicfN
		echo "### Global setting of the files" >> ./$zicfN
		echo "#OWNER = root" >> ./$zicfN
		echo "#GROUP = wheel" >> ./$zicfN
		echo "#PERM = 755" >> ./$zicfN
		echo "">> ./$zicfN
		echo "">> ./$zicfN
		echo "### Regular Syntax" >> ./$zicfN
		echo "### Based root Directory = /data/" >> ./$zicfN
		echo "## --------------------------------------------------------------------------------------------------------------------" >> ./$zicfN
		echo "## Option type | File Permission | File Owner | File Group | Destination Dir | Source Dir | Conf option(CONF type only)" >> ./$zicfN
		echo "## --------------------------------------------------------------------------------------------------------------------" >> ./$zicfN
		echo "##" >> ./$zicfN
		echo "## Option type = FILE - Sorce file, CONF - Configuration file, SYMB - Symbolic link, CRON - Crontab" >> ./$zicfN
		echo "## File permission =  ex)644 or \"-\" ( \"-\" is default, it will be accept by global setting if you used it)" >> ./$zicfN
		echo "## File Owner =  ex)krystal or root or \"-\" ( \"-\" is default, it will be accept by global setting if you used it)" >> ./$zicfN
		echo "## File group =  ex)krystal or wheel or \"-\" ( \"-\" is default, it will be accept by global setting if you used it)" >> ./$zicfN
		echo "## Destinatin Dir = Target directory for the file copy or symbolic link" >> ./$zicfN
		echo "## Source Dir = Source directory for the file copy or symbolic link" >> ./$zicfN
		echo "## Conf option - ex) expand-overwite or expand-nomerge, Optional: file overwrite or not(CONF only), default = expand-overwrite" >> ./$zicfN
		echo "">> ./$zicfN
		echo "#CONF 644 - -			tmp/conf/httpd_gsshp.conf		./conf/httpd_gsshop.conf" >> ./$zicfN
		echo "#FILE - - -				tmp/logrotation.sh			./logrotation.sh" >> ./$zicfN
		echo "#FILE - nobody nobody	tmp/www/index.html			./html/index.html" >> ./$zicfN
		echo "#SYMB x x x				tmp/www/top.html			tmp/www/index.html" >> ./$zicfN
		echo "#CRON x - x				* * * * *					tmp/logrotation.sh" >> ./$zicfN
		echo "">> ./$zicfN
		echo "">> ./$zicfN.footer
		echo "### Zinst detail command" >> ./$zicfN.footer
		echo "### requires pkg = You can add an option to this line about of the dependency package for this work(install or upgrade)." >> ./$zicfN.footer
		echo "### ex) ZINST requires pkg [Packagename] [Lowest version] [latest version]" >> ./$zicfN.footer
		echo "">> ./$zicfN.footer
		echo "### set = You can control the configuration in the CONF file by this options" >> ./$zicfN.footer
		echo "### ex) ZINST set [Variables name] [Value]" >> ./$zicfN.footer
		echo "#ZINST set MaxClient 64" >> ./$zicfN.footer
		echo "">> ./$zicfN.footer
		echo "### post-activate = You can contral the daemon after the package install as below" >> ./$zicfN.footer
		echo "### ex) ZINST post-activate [Target executable file and directory] [Command: stop, start, restart]" >> ./$zicfN.footer
		echo "#" >> ./$zicfN.footer
		echo "">> ./$zicfN.footer
		echo "#ZINST post-activate /data/tomcat/bin/tomcat restart" >> ./$zicfN.footer
		echo "#ZINST requires pkg perl-log4j" >> ./$zicfN.footer
		echo "">> ./$zicfN.footer
		echo "">> ./$zicfN.footer
		echo "### Extra command" >> ./$zicfN.footer
		echo "## COMM = simple command after the package installed. basedir is the package dir " >> ./$zicfN.footer
		echo "## ex) " >> ./$zicfN.footer
		echo "## COMM /data/zinst/foo.bar/install.sh" >> ./$zicfN.footer
		echo "#COMM service network restart" >> ./$zicfN.footer
		
    
		## ==================  End zicf Base file ===================
		cat ./listup | awk '{print "stat -c \"%A (%a) %8s %.19y %n\"  " $6,"\| awk \#%{print $2,$6}\#% \>> ./perm.txt "}' > ./Package_gen.sh 
		sed -i '/\/ | /d' ./Package_gen.sh 
		sed -i "s/#%/'/g" ./Package_gen.sh
		chmod 755 ./Package_gen.sh 
		./Package_gen.sh 
		cat ./perm.txt | sed 's/(//g' | sed 's/)//g' | awk '{print "FILE",$1,"- -", $2,"\t\t",$2}' |sed 's/- .\//- /g' > Package.zicf
		sed -i '/FILE  - - /d' ./Package.zicf
    
    
			if [[ $Option2 = "-default" ]]
			then
				sed -i 's/ - - / - - z\/temp\//g' ./Package.zicf
			fi
    
		cat Package.zicf >> ./$zicfN
		cat $zicfN.footer >> ./$zicfN
    
		sed -i 's/FILE 777 - -/SYMB x x x/g' ./$zicfN
		echo " ==== Need to change below list for the Symbolic link ==== "
		cat  $zicfN | grep "^SYMB x" | awk '{print $6}' |awk '{print $NF}'
    
		## Clear Temporary files
		rm -f ./perm.txt ./$Tar ./Package_gen.sh ./listup ./Package.zicf ./$zicfN.footer 

	else
		echo ""
		echo "===================================================================================="
		echo "= make: Make a new zicf file as a filelist in current directory                    ="
		echo "= make -default: Set default directory add as \"z/temp/~\" before the result files   ="
		echo "===================================================================================="
		exit 0;
	fi
