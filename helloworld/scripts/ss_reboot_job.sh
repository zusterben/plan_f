#!/bin/sh

source /jffs/softcenter/scripts/ss_base.sh
ISP_DNS1=$(nvram get wan0_dns|sed 's/ /\n/g'|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 1p)
ISP_DNS2=$(nvram get wan0_dns|sed 's/ /\n/g'|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 2p)
IFIP_DNS1=`echo $ISP_DNS1|grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}|:"`
IFIP_DNS2=`echo $ISP_DNS2|grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}|:"`

remove_ss_reboot_job(){
	if [ -n "`cru l|grep ss_reboot`" ]; then
		echo_date "【科学上网】：删除插件自动重启定时任务..."
		sed -i '/ss_reboot/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
}

set_ss_reboot_job(){
	if [[ "${ssconf_reboot_check}" == "0" ]]; then
		remove_ss_reboot_job
	elif [[ "${ssconf_reboot_check}" == "1" ]]; then
		echo_date "【科学上网】：设置每天${ssconf_basic_time_hour}时${ssconf_basic_time_min}分重启插件..."
		cru a ss_reboot ${ssconf_basic_time_min} ${ssconf_basic_time_hour}" * * * /bin/sh /jffs/softcenter/ss/ssconfig.sh restart"
	elif [[ "${ssconf_reboot_check}" == "2" ]]; then
		echo_date "【科学上网】：设置每周${ssconf_basic_week}的${ssconf_basic_time_hour}时${ssconf_basic_time_min}分重启插件..."
		cru a ss_reboot ${ssconf_basic_time_min} ${ssconf_basic_time_hour}" * * "${ssconf_basic_week}" /bin/sh /jffs/softcenter/ss/ssconfig.sh restart"
	elif [[ "${ssconf_reboot_check}" == "3" ]]; then
		echo_date "【科学上网】：设置每月${ssconf_basic_day}日${ssconf_basic_time_hour}时${ssconf_basic_time_min}分重启插件..."
		cru a ss_reboot ${ssconf_basic_time_min} ${ssconf_basic_time_hour} ${ssconf_basic_day}" * * /bin/sh /jffs/softcenter/ss/ssconfig.sh restart"
	elif [[ "${ssconf_reboot_check}" == "4" ]]; then
		if [[ "${ssconf_basic_inter_pre}" == "1" ]]; then
			echo_date "【科学上网】：设置每隔${ssconf_basic_inter_min}分钟重启插件..."
			cru a ss_reboot "*/"${ssconf_basic_inter_min}" * * * * /bin/sh /jffs/softcenter/ss/ssconfig.sh restart"
		elif [[ "${ssconf_basic_inter_pre}" == "2" ]]; then
			echo_date "【科学上网】：设置每隔${ssconf_basic_inter_hour}小时重启插件..."
			cru a ss_reboot "0 */"${ssconf_basic_inter_hour}" * * * /bin/sh /jffs/softcenter/ss/ssconfig.sh restart"
		elif [[ "${ssconf_basic_inter_pre}" == "3" ]]; then
			echo_date "【科学上网】：设置每隔${ssconf_basic_inter_day}天${ssconf_basic_inter_hour}小时${ssconf_basic_time_min}分钟重启插件..."
			cru a ss_reboot ${ssconf_basic_time_min} ${ssconf_basic_time_hour}" */"${ssconf_basic_inter_day} " * * /bin/sh /jffs/softcenter/ss/ssconfig.sh restart"
		fi
	elif [[ "${ssconf_reboot_check}" == "5" ]]; then
		check_custom_time=`dbus get ssconf_basic_custom | base64_decode`
		echo_date "【科学上网】：设置每天${check_custom_time}时的${ssconf_basic_time_min}分重启插件..."
		cru a ss_reboot ${ssconf_basic_time_min} ${check_custom_time}" * * * /bin/sh /jffs/softcenter/ss/ssconfig.sh restart"
	fi
}

remove_ss_trigger_job(){
	if [ -n "`cru l|grep ss_tri_check`" ]; then
		echo_date "删除插件触发重启定时任务..."
		sed -i '/ss_tri_check/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	else
		echo_date "插件触发重启定时任务已经删除..."
	fi
}

set_ss_trigger_job(){
	if [ "$ssconf_basic_tri_reboot_time" == "0" ];then
		remove_ss_trigger_job
	else
		echo_date "设置每隔$ssconf_basic_tri_reboot_time分钟检查服务器IP地址，如果IP发生变化，则重启科学上网插件..."
		echo_date "科学上网插件触发重启功能的日志将显示再系统日志内。"
		cru d ss_tri_check  >/dev/null 2>&1
		cru a ss_tri_check "*/$ssconf_basic_tri_reboot_time * * * * /jffs/softcenter/scripts/ss_reboot_job.sh check_ip"
	fi
}

__get_type_abbr_name() {
	case "$ssconf_basic_type" in
		0)
			echo "ss"
		;;
		1)
			echo "ssr"
		;;
		2)
			echo "v2ray"
		;;
		3)
			echo "trojan"
		;;
	esac
}

check_ip_now(){
	local HOST OLD_IP NEW_IP SERVER_INFO ADDR_INFO INFO_LINE tmp1
		logger "【科学上网插件触发重启功能】========================================================"
		logger "【科学上网插件触发重启功能】：使用DNS:$(__get_server_resolver):$(__get_server_resolver_port)检查$(__get_type_abbr_name)服务器IP是否更换..."
		if [ -f "/tmp/ss_host.conf" ];then
			HOST=`cat /tmp/ss_host.conf | cut -d "/" -f2`
			OLD_IP=`cat /tmp/ss_host.conf | cut -d "/" -f3`
			if [ -n "$HOST" ] && [ -n "$OLD_IP" ];then
				NEW_IP=$(__resolve_ip "$HOST")
				case $? in
				0)
					# server is domain format and success resolved.
					if [ "$OLD_IP"x == "$NEW_IP"x ];then
						logger "【科学上网插件触发重启功能】：$(__get_type_abbr_name)服务器：【$HOST】的ip地址：【$OLD_IP】未发生变化，不进行任何操作！"
					else
						logger "【科学上网插件触发重启功能】：$(__get_type_abbr_name)服务器：【$HOST】的ip地址发生变化，旧ip：【$OLD_IP】，新ip：【$NEW_IP】"
						#写入新的解析文件，用于下次比较
						echo "address=/$HOST/$NEW_IP" > /tmp/ss_host.conf
						logger "【科学上网插件触发重启功能】：重启插件，以应用新的ip"
						start-stop-daemon -S -q -x /jffs/softcenter/ss/ssconfig.sh -- restart
					fi
					;;
				1)
					# server is domain format and failed to resolve.
					logger "【科学上网插件触发重启功能】：$(__get_type_abbr_name)服务器域名解析失败！！不进行任何进一步操作！"
					;;
				2)
					# server is not ip either domain!
					logger "【科学上网插件触发重启功能】：$(__get_type_abbr_name)服务器域名服务器：【$HOST】无法解析！因为它不是IP格式也不是域名格式！"
					;;
				esac
			else
				logger "【科学上网插件触发重启功能】：未找到你当前节点的$(__get_type_abbr_name)服务器地址，可能插件提交时未正确解析！"
				logger "【科学上网插件触发重启功能】：请尝试直接使用ip地址作为$(__get_type_abbr_name)服务器地址！"
			fi
		else
			if [ -n "$ssconf_basic_server_ip" ];then
				temp2=$(__valid_ip "$ssconf_basic_server_ip")
				logger "【科学上网插件触发重启功能】：当前$(__get_type_abbr_name)服务器地址已经是IP格式：$temp2！不进行任何操作！"
			else
				logger "【科学上网插件触发重启功能】：未找到你当前节点的$(__get_type_abbr_name)服务器地址，可能已是IP格式！不进行任何操作！"
			fi
		fi
		logger "【科学上网插件触发重启功能】========================================================"
}
# -------------------

case "$1" in
	check_ip)
		check_ip_now
	;;
esac

case "$2" in
	1)
		echo " " > /tmp/upload/ss_log.txt
		http_response "$1"
		set_ss_reboot_job >> /tmp/upload/ss_log.txt
		echo XU6J03M6 >> /tmp/upload/ss_log.txt
	;;
	2)
		echo " " > /tmp/upload/ss_log.txt
		http_response "$1"
		set_ss_trigger_job >> /tmp/upload/ss_log.txt
		echo XU6J03M6 >> /tmp/upload/ss_log.txt
	;;
esac
