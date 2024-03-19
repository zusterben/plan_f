#!/bin/sh

source /jffs/softcenter/scripts/base.sh

if [ -n "$(pidof ping)" ] && [ -n "$(pidof lua)" ]; then
	while [ -n "$(pidof lua)" ]
	do
		usleep 500000
	done
	sleep 2
	rm -rf /tmp/upload/ping.log
	response_text=$(/jffs/softcenter/bin/lua /jffs/softcenter/scripts/ss_ping.lua)
	echo $response_text > /tmp/upload/ping.log
	echo XU6J03M6 >> /tmp/upload/ping.log
	http_response "$1"
	rm -rf /var/lock/ss_ping.lock
else
	rm -rf /tmp/upload/ping.log
	response_text=$(/jffs/softcenter/bin/lua /jffs/softcenter/scripts/ss_ping.lua)
	echo $response_text > /tmp/upload/ping.log
	echo XU6J03M6 >> /tmp/upload/ping.log
	http_response "$1"
	rm -rf /var/lock/ss_ping.lock
fi

