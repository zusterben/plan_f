#!/bin/sh

source /jffs/softcenter/scripts/base.sh
mkdir -p /tmp/upload
LOCK_FILE=/var/lock/helloworld2.lock

set_lock(){
	exec 1000>${LOCK_FILE}
	flock -n 1000 || {
		# bring back to original log
		http_response "$ACTION"
		# echo_date "$BASH $ARGS" | tee -a ${LOG_FILE}
		exit 1
	}
}

unset_lock() {
	flock -u 1000
	rm -rf ${LOCK_FILE}
}


pre_stop(){
	local current_pid=$$
	local ss_config_pids=$(ps|grep -E "ss_config\.sh"|awk '{print $1}'|grep -v ${current_pid})
	if [ -n "${ss_config_pids}" ];then
		for ss_config_pid in ${ss_config_pids}; do
			echo kill ${ss_config_pid}
			kill -9 ${ss_config_pid} >/dev/null 2>&1
		done
	fi

	local ssconfig_pids=$(ps|grep ssconfig.sh|grep -v grep|awk '{print $1}')
	if [ -n "${ssconfig_pids}" ];then
		for ssconfig_pid in ${ssconfig_pids}; do
			kill -9 ${ssconfig_pid} >/dev/null 2>&1
		done
	fi
	
	if [ -f "${LOCK_FILE}" ];then
		rm -rf ${LOCK_FILE}
	fi
}

stop_helloworld(){
	sh /jffs/softcenter/ss/ssconfig.sh stop
	echo XU6J03M6
}

pre_start(){
	# 主脚本开启前，进行检查，看是否有ssconfig.sh进程卡住的
	local ssconfig_pids=$(ps|grep ssconfig.sh|grep -v grep|awk '{print $1}')
	if [ -n "${ssconfig_pids}" ];then
		echo "${ssconfig_pids}"
		for ssconfig_pid in ${ssconfig_pids}; do
			kill -9 ${ssconfig_pid} >/dev/null 2>&1
		done
	fi
}

start_helloworld(){
	# start fancyss
	sh /jffs/softcenter/ss/ssconfig.sh restart
	echo XU6J03M6
}


# call by ws
case $1 in
start)
	set_lock
	echo "" > /tmp/upload/ss_log.txt
	pre_start
	start_helloworld | tee -a /tmp/upload/ss_log.txt 2>&1
	unset_lock
	;;
start_by_ws)
	set_lock
	pre_start
	start_helloworld
	unset_lock
	;;
stop)
	# 为了避免ss_config.sh本身也卡住，所以stop过程不使用文件锁，强行关闭
	echo "" > /tmp/upload/ss_log.txt
	pre_stop
	stop_helloworld | tee -a /tmp/upload/ss_log.txt 2>&1
	;;
test)
	sleep 100
	;;
esac

# call by httpd
case $2 in
start)
	set_lock
	echo "" > /tmp/upload/ss_log.txt
	http_response "$1"
	pre_start
	start_helloworld | tee -a /tmp/upload/ss_log.txt 2>&1
	unset_lock
	;;
start_by_ws)
	set_lock
	pre_start
	start_helloworld
	unset_lock
	;;
stop)
	# 为了避免ss_config.sh本身也卡住，所以stop过程不使用文件锁，强行关闭
	echo "" > /tmp/upload/ss_log.txt
	http_response "$1"
	pre_stop
	stop_helloworld | tee -a /tmp/upload/ss_log.txt 2>&1
	;;
test)
	sleep 100
	;;
esac

