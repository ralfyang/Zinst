#!/bin/bash   
# GSshop package install manager   
# Made by Jiook Yang
# goody80762@gmail.com & ralf.yang@gsshop.com


echo " ======================================================================================== "
echo "  Please insert directory name for you want (ex /data )"
echo "  Directory will be created as you type it "
echo " ======================================================================================== "
read ZinstBaseRootO
# -> ex) /data



if [[ $ZinstBaseRootO = "" ]]
	then
	echo " === Empty data has been inserted! ==="
	echo " ===  Processor has been stopped   ==="
	exit 0;
fi

ZinstBaseRoot=`echo "$ZinstBaseRootO" | sed -e 's/\//\\\\\//g'`

export ZinstDir="$ZinstBaseRootO"
# It needs to be the set for the listing of RHEL 6.x environment
# echo "export TIME_STYLE=\"+%b %e %R\"" >> /etc/profile



echo " ======================================================================================== "
echo "  Do you want to make a Distribute server for packages download? [y / n ]" 
echo "  * Notice: Apache web server will be start in this server automaticlly *"
echo " ======================================================================================== "
read Dist_IC

if [[ $Dist_IC = y ]]
	then
	mkdir -p $ZinstBaseRootO/dist/checker
	chown nobody.nobody $ZinstBaseRootO/dist
	echo " ======================================================================================= "
	echo "  File directory for the Distritution is $ZinstBaseRootO/dist  "
	echo " ======================================================================================= "
elif [[ $Dist_IC = "" ]]; then
	echo " === Empty data has been inserted! ==="
	echo " ===  Processor has been stopped   ==="
	exit 0;
fi

echo " ======================================================================================== "
echo "  Please insert your Domain name of the Distribution server ex)package.dist.blahblah.com"
echo " ======================================================================================== "
read Dist_server
# -> ex) package.dist.gsshop.com

if [[ $Dist_server = "" ]]
	then
	echo " === Empty data has been inserted! ==="
	echo " === You can't use the package distributer  === "
	exit 0;
fi

echo " ======================================================================================= "
echo "  Please insert your IP address of the Distribution server"
echo " ======================================================================================= "
read Dist_server_IP

# -> ex) 192.168.10.141

if [[ $Dist_server_IP = "" ]]
	then
		echo " === Empty data has been inserted! ==="
		echo " === You can't use the package distributer  === "
		exit 0;
fi

echo " ======================="
echo " | Go ahead ? [y or n] |"
echo " ======================="
read Ggo

if [[ $Ggo != "y" ]]
	then
	echo " ===  Processor has been stopped   ==="
	exit 0;
fi

sed -i "s/RootDirectorY/$ZinstBaseRoot/g" ./zinst
sed -i "s/DISTsERVERsET/$Dist_server/g" ./zinst
sed -i "s/DISTsERVERIp/$Dist_server_IP/g" ./zinst

mkdir -p $ZinstBaseRootO/zinst
mkdir -p $ZinstBaseRootO/z
mkdir -p $ZinstBaseRootO/vault/Source/bin
echo "set -o emacs" >> /etc/profile

cp ./zinst $ZinstBaseRootO/vault/Source/bin/zinst
cp ./zinst $ZinstBaseRootO/dist/
ln -sf $ZinstBaseRootO/vault/Source/bin/zinst /usr/bin/zinst

if [[ $Dist_IC = y ]]
    then
	cp ./*.zinst $ZinstBaseRootO/vault/Source/
	cp ./*.zinst $ZinstBaseRootO/dist/
	cd $ZinstBaseRootO/vault/Source/

	zinst i server_default_setting*.zinst 
	zinst i gsshop_httpd_server*.zinst 
	zinst i gsshop_httpd_conf_pkgdist*.zinst -set gsshop_httpd_conf_pkgdist.ServerName=$Dist_server
	zinst set gsshop_httpd_conf_pkgdist.DocumentRoot=$ZinstBaseRootO/dist
	zinst i package_tracker*.zinst
	zinst start httpd
	echo " ======================================================================================= "
	echo "  Apache web server has been installed "
	echo "  You can push the packages to $ZinstBaseRootO/dist for the package distribute "
	echo " ======================================================================================= "
fi


echo " =============================== "
echo " ===== Job finished!! :) ======= "
echo " =============================== "

