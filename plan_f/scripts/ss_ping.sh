#!/bin/sh

source /jffs/softcenter/scripts/base.sh

if [ -n "$(pidof ping)" ] && [ -n "$(pidof lua)" ]; then
	while [ -n "$(pidof lua)" ]
	do
		usleep 500000
	done
	sleep 2
	response_text=$(/jffs/softcenter/bin/lua /jffs/softcenter/scripts/ss_ping.lua)
	http_response "$response_text"
	rm -rf /var/lock/ss_ping.lock
else
	rm -rf /tmp/ping.txt
	response_text=$(/jffs/softcenter/bin/lua /jffs/softcenter/scripts/ss_ping.lua)
	http_response "$response_text"
	rm -rf /var/lock/ss_ping.lock
fi
