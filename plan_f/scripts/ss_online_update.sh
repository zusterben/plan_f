#!/bin/sh

source /jffs/softcenter/scripts/ss_base.sh

LOCK_FILE=/tmp/online_update.lock
LOG_FILE=/tmp/upload/ss_log.txt
CONFIG_FILE=/jffs/softcenter/ss/ss.json
BACKUP_FILE_TMP=/tmp/ss_conf_tmp.sh
BACKUP_FILE=/tmp/ss_conf.sh
NODES_SEQ=$(export -p | grep ssconf_basic_json_ | cut -d "=" -f1 | cut -d "_" -f4 | sort -n)
NODE_INDEX=$(echo "${NODES_SEQ}" | sort -rn | head -n1)

set_lock(){
	exec 233>"$LOCK_FILE"
	flock -n 233 || {
		local PID1=$$
		local PID2=$(ps|grep -w "ss_online_update.sh"|grep -vw "grep"|grep -vw ${PID1})
		if [ -n "${PID2}" ];then
			echo_date "订阅脚本已经在运行，请稍候再试！"
			exit 1			
		else
			rm -rf $LOCK_FILE
		fi

	}
}

unset_lock(){
	flock -u 233
	rm -rf "$LOCK_FILE"
}

# 清除已有的所有节点配置
remove_all_node(){
	echo_date "删除所有节点信息！"
	confs=$(export -p | grep ssconf_basic_json_ | cut -d "=" -f1)
	for conf in $confs
	do
		echo_date "移除$conf"
		dbus remove $conf
	done
}

# 删除所有订阅节点
remove_sub_node(){
	echo_date "删除所有订阅节点信息...自添加的节点不受影响！"
	remove_nus=$(export -p | grep ssconf_basic_jsontype_ | grep "='1'" | cut -d "=" -f1 | cut -d "_" -f4 | sort -n)
	if [ -z "$remove_nus" ]; then
		echo_date "节点列表内不存在任何订阅来源节点，退出！"
		return 1
	fi
	for remove_nu in $remove_nus
	do
		echo_date "移除第$remove_nu节点"
		dbus remove ssconf_basic_json_${remove_nu}
		dbus remove ssconf_basic_jsontype_${remove_nu}
		dbus remove ssconf_basic_mode_${remove_nu}

	done
	echo_date "所有订阅节点信息已经成功删除！"
}

prepare(){
	echo_date "开始节点数据检查..."
	local REASON=0
	local SEQ_NU=$(echo ${NODES_SEQ} | tr ' ' '\n' | wc -l)
	local MAX_NU=${NODE_INDEX}
	local KEY_NU=$(export -p | grep ssconf_basic_json_ | cut -d "=" -f1 | sed '/^$/d' | wc -l)
	local VAL_NU=$(export -p | grep ssconf_basic_json_ | cut -d "=" -f2 | sed '/^$/d' | wc -l)

	echo_date "最大节点序号：$MAX_NU"
	echo_date "共有节点数量：$SEQ_NU"

	# 如果[节点数量 ${SEQ_NU}]不等于[最大节点序号 ${MAX_NU}]，说明节点排序是不正确的。
	if [ ${SEQ_NU} -ne ${MAX_NU} ]; then
		let REASON+=1
		echo_date "节点顺序不正确，需要调整！"
	fi

	# 如果key的数量不等于value的数量，说明有些key储存了空值，需要清理一下。
	if [ ${KEY_NU} -ne ${VAL_NU} ]; then
		let REASON+=2
		echo_date "节点配置有残余值，需要清理！"
	fi

	if [ $REASON != "0" ]; then
		# 提取干净的节点配置，并重新排序，现在web界面里添加/删除节点后会自动排序，所以以下基本不会运行到
		echo_date "备份所有节点信息并重新排序..."
		echo_date "如果节点数量过多，此处可能需要等待较长时间，请耐心等待..."
		rm -rf $BACKUP_FILE_TMP
		rm -rf $BACKUP_FILE

		cat > $BACKUP_FILE <<-EOF
			#!/bin/sh
			source /jffs/softcenter/scripts/base.sh
			#------------------------
			confs=\$(dbus list ssconf_basic_json_ | cut -d "=" -f1)
			for conf in \$confs
			do
			    dbus remove \$conf
			done
			usleep 300000
			#------------------------
		EOF
		local i=1
		export -p | grep ssconf_basic_json_ | awk -F"=" '{print $1}' | awk -F"_" '{print $NF}' | sort -n | while read nu
		do
			local tnode = $(eval echo '$'"ssconf_basic_json_$nu")
			local ttype = $(eval echo '$'"ssconf_basic_jsontype_$nu")
			if [ -n "$tnode" ];then
				echo "dbus set ssconf_basic_json_${i}=\"${tnode}\"" >> $BACKUP_FILE
			elif [ -n "$ttype" ];then
				echo "dbus set ssconf_basic_jsontype_${i}=\"${ttype}\"" >> $BACKUP_FILE
			else
				echo_date "节点信息不正确，退出！"
			fi
			let i+=1
		done
		
		echo_date "备份完毕，开始调整..."
		# 2 应用提取的干净的节点配置
		chmod +x $BACKUP_FILE
		sh $BACKUP_FILE
		echo_date "节点调整完毕！"
	else
		echo_date "节点顺序正确，节点配置信息OK！无需调整！"
	fi
}

remove_node_gap(){
	# 虽然web上已经可以自动化无缝重排序了，但是考虑到有的用户设置了插件自动化，长期不进入web，而后台更新节点持续一段时间后，节点顺序还是会很乱，所以保留此功能
	SEQ=$(dbus list ssconf_basic_json_ | cut -d "_" -f4 | cut -d "=" -f1 | sort -n)
	MAX=$(dbus list ssconf_basic_json_ | cut -d "_" -f4 | cut -d "=" -f1 | sort -rn | head -n1)
	NODES_NU=$(export -p | grep "ssconf_basic_json_" | wc -l)
	
	echo_date "最大节点序号：$MAX"
	echo_date "共有节点数量：$NODES_NU"
	if [ "$MAX" != "$NODES_NU" ]; then
		echo_date "节点排序需要调整!"
		local y=1
		for nu in $SEQ
		do
			if [ "$y" == "$nu" ]; then
				echo_date "节点$y不需要调整！"
			else
				echo_date "调整节点$nu到节点$y！"
				local tnode = $(eval echo '$'"ssconf_basic_json_$nu")
				local ttype = $(eval echo '$'"ssconf_basic_jsontype_$nu")
				if [ -n "$tnode" ];then
					dbus set ssconf_basic_json_${y}="${tnode}"
				elif [ -n "$ttype" ];then
					dbus set ssconf_basic_jsontype_${y}="${ttype}"
				fi
			fi
			let y+=1
		done
	else
		echo_date "节点排序正确!"
	fi
}

# 使用订阅链接订阅ssr/v2ray/trojan节点节点
start_online_update(){
	prepare
	
	#删除所有订阅节点
	remove_sub_node
	
	echo_date "==================================================================="
	echo_date "                服务器订阅程序(Shell by zusterben)"
	echo_date "==================================================================="

	echo_date "开始更新在线订阅列表..." 
	cd /jffs/softcenter/scripts
	/jffs/softcenter/bin/lua /jffs/softcenter/scripts/ss_subscribe.lua
	#等待订阅完成
	while [ -n "$(pidof lua)" ]; do
		sleep 2s
	done


	# 节点重新排序
	remove_node_gap

	# 结束
	echo_date "-------------------------------------------------------------------"

	echo_date "一点点清理工作..."
	echo_date "==================================================================="
	echo_date "所有订阅任务完成，请等待6秒，或者手动关闭本窗口！"
	echo_date "==================================================================="
}

# 添加ss:// ssr:// vmess://离线节点
start_offline_update() {
	echo_date "==================================================================="
	usleep 100000
	echo_date "通过SS/SSR/v2ray/Trojan链接添加节点..."
	/jffs/softcenter/bin/lua /jffs/softcenter/scripts/ss_subscribe_off.lua
	#等待订阅完成
	while [ -n "$(pidof lua)" ]; do
		sleep 2s
	done
	echo_date "==================================================================="
}

case $2 in
0)
	# 删除所有节点
	set_lock
	echo " " > $LOG_FILE
	http_response "$1"
	remove_all_node | tee -a $LOG_FILE
	echo XU6J03M6 | tee -a $LOG_FILE
	unset_lock
	;;
1)
	# 删除所有订阅节点
	set_lock
	echo " " > $LOG_FILE
	http_response "$1"
	remove_sub_node | tee -a $LOG_FILE
	echo XU6J03M6 | tee -a $LOG_FILE
	unset_lock
	;;
2)
	# 保存订阅设置但是不订阅
	set_lock
	echo " " > $LOG_FILE
	http_response "$1"
	local_groups=$(export -p | grep ssconf_basic_ | grep _group_ | cut -d "=" -f2 | sort -u | wc -l)
	online_group=$(echo $ss_online_links | base64_decode | sed 's/$/\n/' | sed '/^$/d' | wc -l)
	echo_date "保存订阅节点成功，现共有 $online_group 组订阅来源，当前节点列表内已经订阅了 $local_groups 组..." | tee -a $LOG_FILE
	sed -i '/ssnodeupdate/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	if [ "$ssconf_basic_node_update" = "1" ]; then
		if [ "$ssconf_basic_node_update_day" = "7" ]; then
			cru a ssnodeupdate "0 $ssconf_basic_node_update_hr * * * /jffs/softcenter/scripts/ss_online_update.sh helloworld 3"
			echo_date "设置自动更新订阅服务在每天 $ssconf_basic_node_update_hr 点。" | tee -a $LOG_FILE
		else
			cru a ssnodeupdate "0 $ssconf_basic_node_update_hr * * $ssconf_basic_node_update_day /jffs/softcenter/scripts/ss_online_update.sh helloworld 3"
			echo_date "设置自动更新订阅服务在星期 $ssconf_basic_node_update_day 的 $ssconf_basic_node_update_hr 点。" | tee -a $LOG_FILE
		fi
	else
		echo_date "关闭自动更新订阅服务！" | tee -a $LOG_FILE
		sed -i '/ssnodeupdate/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
	echo XU6J03M6 | tee -a $LOG_FILE
	unset_lock
	;;
3)
	# 使用订阅链接订阅ssr/v2ray/trojan节点
	set_lock
	echo " " > $LOG_FILE
	http_response "$1"
	echo_date "开始订阅" | tee -a $LOG_FILE
	start_online_update | tee -a $LOG_FILE
	echo XU6J03M6 | tee -a $LOG_FILE
	unset_lock
	;;
4)
	# 添加ss:// ssr:// vmess:// trojan://离线节点
	set_lock
	echo " " > $LOG_FILE
	http_response "$1"
	start_offline_update | tee -a $LOG_FILE
	echo XU6J03M6 | tee -a $LOG_FILE
	unset_lock
	;;
5)
	prepare
	;;
esac

