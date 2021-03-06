#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval $(dbus export ssconf_basic_)

mkdir -p /tmp/upload
echo "" > /tmp/upload/ss_log.txt
http_response "$1"

case $2 in
start)
	if [ "$ssconf_basic_enable" == "1" ];then
		sh /jffs/softcenter/ss/ssconfig.sh restart >> /tmp/upload/ss_log.txt
	else
		sh /jffs/softcenter/ss/ssconfig.sh stop >> /tmp/upload/ss_log.txt
	fi
	echo XU6J03M6 >> /tmp/upload/ss_log.txt
	;;
esac
