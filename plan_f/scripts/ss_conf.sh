#!/bin/sh

source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'

download_ssf(){
	rm -rf /tmp/files
	rm -rf /jffs/softcenter/webs/files
	mkdir -p /tmp/files
	ln -sf /tmp/files /jffs/softcenter/webs/files
	if [ -f "/tmp/upload/ssf_status.txt" ];then
		cp -rf /tmp/upload/ssf_status.txt /tmp/files/ssf_status.txt
	else
		echo "日志为空" > /tmp/files/ssf_status.txt
	fi
}

download_ssc(){
	rm -rf /tmp/files
	rm -rf /jffs/softcenter/webs/files
	mkdir -p /tmp/files
	ln -sf /tmp/files /jffs/softcenter/webs/files
	if [ -f "/tmp/upload/ssc_status.txt" ];then
		cp -rf /tmp/upload/ssc_status.txt /tmp/files/ssc_status.txt
	else
		echo "日志为空" > /tmp/files/ssc_status.txt
	fi
}

case $2 in
1)
	echo " " > /tmp/upload/ss_log.txt
	backup_conf
	http_response "$1"
	;;
2)
	echo " " > /tmp/upload/ss_log.txt
	backup_tar >> /tmp/upload/ss_log.txt
	sleep 1
	http_response "$1"
	sleep 2	
	echo XU6J03M6 >> /tmp/upload/ss_log.txt
	;;
3)
	echo " " > /tmp/upload/ss_log.txt
	http_response "$1"
	remove_now >> /tmp/upload/ss_log.txt
	echo XU6J03M6 >> /tmp/upload/ss_log.txt
	;;
4)
	echo " " > /tmp/upload/ss_log.txt
	http_response "$1"
	remove_silent >> /tmp/upload/ss_log.txt
	restore_now >> /tmp/upload/ss_log.txt
	echo XU6J03M6 >> /tmp/upload/ss_log.txt
	;;
5)
	reomve_ping
	;;
6)
	echo " " > /tmp/upload/ss_log.txt
	download_ssf
	http_response "$1"
	;;
7)
	echo " " > /tmp/upload/ss_log.txt
	download_ssc
	http_response "$1"
	;;
esac
