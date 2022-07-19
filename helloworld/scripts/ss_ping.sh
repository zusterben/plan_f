#!/bin/sh

source /jffs/softcenter/scripts/base.sh

start_ping(){
	local node_doamin
	touch /tmp/ss_ping.lock
	eval $(dbus export ssconf_basic_ping)
	[ -z "$ssconf_basic_ping_node" ] && ssconf_basic_ping_node="0"
	[ -z "$ssconf_basic_ping_method" ] && ssconf_basic_ping_method="2"
	if [ "$ssconf_basic_ping_node" != "0" ];then
		node_doamin=$(eval dbus get ssconf_basic_json_${ssconf_basic_ping_node} | base64 -d | jq -r .server)
		[ "$ssconf_basic_ping_method" == "1" ] && ping_text=$(ping -4 $node_doamin -c 1 -w 1 -q)
		[ "$ssconf_basic_ping_method" == "2" ] && ping_text=$(ping -4 $node_doamin -c 10 -w 10 -q)
		[ "$ssconf_basic_ping_method" == "3" ] && ping_text=$(ping -4 $node_doamin -c 20 -w 20 -q)
		ping_time=$(echo $ping_text|grep avg|awk -F '/' '{print $4}')
		[ -z "$ping_time" ] && ping_time="failed"
		ping_loss=$(echo $ping_text|grep loss|awk -F ', ' '{print $3}'|awk '{print $1}')
		echo "$ssconf_basic_ping_node>$ping_time>$ping_loss" >> /tmp/ping.txt
	else
		dbus list ssconf_basic_json_|sort -n -t "_" -k 4|while read node
		do
		{
			node_nu=$(echo $node|cut -d "=" -f1|cut -d "_" -f4)
			node_doamin=$(eval dbus get ssconf_basic_json_${node_nu} | base64 -d | jq -r .server)
			[ "$ssconf_basic_ping_method" == "1" ] && ping_text=$(ping -4 $node_doamin -c 1 -w 1 -q)
			[ "$ssconf_basic_ping_method" == "2" ] && ping_text=$(ping -4 $node_doamin -c 5 -w 5 -q)
			[ "$ssconf_basic_ping_method" == "3" ] && ping_text=$(ping -4 $node_doamin -c 10 -w 10 -q)
			[ "$ssconf_basic_ping_method" == "4" ] && ping_text=$(ping -4 $node_doamin -c 20 -w 20 -q)
			ping_time=$(echo $ping_text|awk -F '/' '{print $4}')
			[ -z "$ping_time" ] && ping_time="failed"
			ping_loss=$(echo $ping_text|grep loss|awk -F ', ' '{print $3}'|awk '{print $1}')
			echo "$node_nu>$ping_time>$ping_loss" >> /tmp/ping.txt
		} &
		done
	fi
	sleep 2
	TOTAL_LINE=$(dbus list ssconf_basic_json_|sort -n -t "_" -k 4|wc -l)
	CURR_LINE=$(cat /tmp/ping.txt|wc -l)
	while [ "$CURR_LINE" -lt "$TOTAL_LINE" ]
	do
		usleep 200000
		CURR_LINE=$(cat /tmp/ping.txt|wc -l)
	done
	response_text=$(cat /tmp/ping.txt|sort -t '>' -nk1|sed 's/^/["/g'|sed 's/>/","/g'|sed 's/$/"],/g'|sed 's/failed//g'|sed ':a;N;$!ba;s#\n##g'|sed 's/,$/]/g'|sed 's/^/[/g'|base64|sed ':a;N;$!ba;s#\n##g')
	http_response "$response_text"
	rm -rf /tmp/ss_ping.lock
}

if [ -n "$(pidof ping)" ] && [ -n "$(pidof ss_ping.sh)" ] && [ -f "/tmp/ss_ping.lock" ]; then
	while [ -n "$(pidof ping)" ]
	do
		usleep 500000
	done
	sleep 2
	response_text=$(cat /tmp/ping.txt|sort -t '>' -nk1|sed 's/^/["/g'|sed 's/>/","/g'|sed 's/$/"],/g'|sed 's/failed//g'|sed ':a;N;$!ba;s#\n##g'|sed 's/,$/]/g'|sed 's/^/[/g'|base64|sed ':a;N;$!ba;s#\n##g')
	http_response "$response_text"
	rm -rf /tmp/ss_ping.lock
else
	rm -rf /tmp/ping.txt
	start_ping
fi
