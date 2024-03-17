#! /bin/sh

source /jffs/softcenter/scripts/base.sh
eval $(dbus export ss)
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
DIR=$(cd $(dirname $0); pwd)
module=${DIR##*/}
LINUX_VER=$(uname -r|awk -F"." '{print $1$2}')
PKG_TYPE=full
PKG_NAME="helloworld_arm_full"
UI_TYPE=ASUSWRT
mkdir -p /jffs/softcenter/ss
mkdir -p /tmp/upload

exit_install(){
	local state=$1
	local PKG_ARCH=$(cat ${DIR}/.arch)
	case $state in
		1)
			echo_date "helloworld项目地址：https://github.com/zusterben/plan_f"
			echo_date "退出安装！"
			rm -rf /tmp/${module}* >/dev/null 2>&1
			exit 1
			;;
		0|*)
			rm -rf /tmp/${module}* >/dev/null 2>&1
			exit 0
			;;
	esac
}

get_model(){
	local ODMPID=$(nvram get odmpid)
	if [ -n "${ODMPID}" ];then
		MODEL="${ODMPID}"
	fi
}

platform_test(){
	local firmware_version=`dbus get softcenter_firmware_version`
	if [ ! -d "/jffs/softcenter" ];then
		echo_date "机型：${MODEL} $(nvram get firmver)_$(nvram get buildno)_$(nvram get extendno) 不符合安装要求，无法安装插件！"
		exit_install 1
	fi
	if [ "$(/jffs/softcenter/bin/versioncmp $firmware_version 5.1.2)" == "1" ];then
		echo_date "1.5代api最低固件版本为5.1.2,固件版本过低，无法安装"
		exit_install 0
	fi
	# 继续判断各个固件的内核和架构
	local PKG_ARCH=$(cat ${DIR}/.arch)
	local ROT_ARCH=$(dbus get softcenter_arch)
	local KEL_VERS=$(uname -r)
	if [ "$ROT_ARCH" == "" ]; then
		/jffs/softcenter/bin/sc_auth arch
		ROT_ARCH=$(dbus get softcenter_arch)
	fi
	if [ "$ROT_ARCH" == "armv7l" ]; then
		ROT_ARCH="arm"
	elif [ "$ROT_ARCH" == "aarch64" ]; then
		ROT_ARCH="arm64"
	fi
	if [ "${PKG_ARCH}" == "${ROT_ARCH}" ];then
		echo_date "内核：${KEL_VERS}，架构：${ROT_ARCH}，安装${PKG_NAME}！"
	else
		echo_date "内核：${KEL_VERS}，架构：${ROT_ARCH}，${PKG_NAME}不适用于该内核版本！"
		echo_date "建议使用helloworld_${ROT_ARCH}_full或者helloworld_${ROT_ARCH}_lite！"
		echo_date "下载地址：https://github.com/zusterben/plan_f/tree/master/bin/${ROT_ARCH}"
		exit_install 1
	fi
}

set_skin(){
	local UI_TYPE=ASUSWRT
	local SC_SKIN=$(nvram get sc_skin)
	local ROG_FLAG=$(grep -o "680516" /www/form_style.css 2>/dev/null|head -n1)
	local TUF_FLAG=$(grep -o "D0982C" /www/form_style.css 2>/dev/null|head -n1)
	local TS_FLAG=$(grep -o "2ED9C3" /www/css/difference.css 2>/dev/null|head -n1)
	if [ -n "${ROG_FLAG}" ];then
		UI_TYPE="ROG"
	fi
	if [ -n "${TUF_FLAG}" ];then
		UI_TYPE="TUF"
	fi
	if [ -n "${TS_FLAG}" ];then
		UI_TYPE="TS"
	fi
	if [ -z "${SC_SKIN}" -o "${SC_SKIN}" != "${UI_TYPE}" ];then
		echo_date "安装${UI_TYPE}皮肤！"
		nvram set sc_skin="${UI_TYPE}"
		nvram commit
	fi
}

node2json(){
	# 当从full版本切换到lite版本的时候，需要将tuic，hysteria节点进行备份后，从节点列表里删除相应节点
	# 1. 将所有不支持的节点数据储存到备份文件
	local node node_num
	local node_protocol
	local node_list=`dbus list ssconf_basic_json_`
	local node_json
	for node in $node_list;
	do
		node_num=`echo ${node} | awk -F"=" '{print $1}'| awk -F"_" '{print $4}'`
		node_json=`dbus get ssconf_basic_json_${node_num}|base64 -d`
		node_protocol=`echo ${node_json}|jq -r .v2ray_protocol`
		if [ "$node_protocol" == "hysteria" ] || [ "$node_protocol" == "tuic" ];then
			mkdir -p /jffs/softcenter/configs/helloworld
			echo_date "备份并从节点列表里移除第$node_num个${node_protocol}节点：【$(echo ${node_json}|jq -r .alias)】"
			echo ${node} >> /jffs/softcenter/configs/helloworld/helloworld_kv.txt
			dbus remove ssconf_basic_json_${node_num}
			dbus remove ssconf_basic_jsontype_${node_num}
			dbus remove ssconf_basic_mode_${node_num}
			dbus remove ssconf_basic_node_${node_num}
		fi
	done
	if [ -f "/jffs/softcenter/configs/helloworld/helloworld_kv.txt" ];then
		echo_date "📁lite版本不支持的节点成功备份到/jffs/softcenter/configs/helloworld/helloworld_kv.txt"
	fi
}

json2node(){
	if [ ! -f "/jffs/softcenter/configs/helloworld/helloworld_kv.txt" ];then
		return
	fi
	NODE_INDEX=$(dbus list ssconf_basic_json_ | sed -n 's/^.*_\([0-9]\+\)=.*/\1/p' | sort -rn | sed -n '1p')
	[ -z "${NODE_INDEX}" ] && NODE_INDEX="0"
	local count=$(($NODE_INDEX + 1))
	echo_date "检测到上次安装helloworld lite备份的不支持节点，准备恢复！"
	for node_json in $(cat /jffs/softcenter/configs/helloworld/helloworld_kv.txt); do
		dbus set ssconf_basic_json_${count}=${node_json}
		dbus set ssconf_basic_jsontype_${count}=0
		dbus set ssconf_basic_mode_${count}=1
		dbus set ssconf_basic_node_${count}=${count}
		let count+=1
	done
	echo_date "节点恢复成功！"
	rm -rf /jffs/softcenter/configs/helloworld/helloworld_kv.txt
}

install_now(){
	# default value
	local PLVER=$(cat ${DIR}/ss/version)
	local OLD_TYPE=""
	echo_date "安装版本：${PKG_NAME}_${PLVER}"
	# 先关闭ss
	if [ "$ssconf_basic_enable" == "1" ];then
		echo_date 先关闭helloworld插件，保证文件更新成功!
		sh /jffs/softcenter/ss/ssconfig.sh stop
	fi

	if [ -n "$(ls /jffs/softcenter/ss/postscripts/P*.sh 2>/dev/null)" ];then
		echo_date 备份触发脚本!
		find /jffs/softcenter/ss/postscripts -name "P*.sh" | xargs -i mv {} -f /tmp/ss_backup
	fi
	if [ -f "/jffs/softcenter/webs/Module_helloworld.asp" ];then
		local IS_LITE=$(cat /jffs/softcenter/webs/Module_helloworld.asp | grep "lite")
		# 已经安装，此次为升级
		if [ -n "${IS_LITE}" ];then
			OLD_TYPE="lite"
		else
			OLD_TYPE="full"
		fi
	fi
	# full → lite, backup nodes
	if [ "${PKG_TYPE}" == "lite" -a "${OLD_TYPE}" == "full" ];then
		node2json
		echo_date "lite版本不支持hysteria,tuic等协议"
	fi
	
	# lite → full, restore nodes
	if [ "${PKG_TYPE}" == "full" -a "${OLD_TYPE}" == "lite" ];then
		# only restore backup node when upgrade helloworld from lite to full
		json2node
	fi

	#升级前先删除无关文件
	echo_date 清理旧文件
	rm -rf /jffs/softcenter/ss/*
	rm -rf /jffs/softcenter/scripts/ss_*
	rm -rf /jffs/softcenter/webs/Module_helloworld*
	[ ! -f "/usr/sbin/lua" ] && rm -rf /jffs/softcenter/bin/lua
	[ ! -f "/rom/etc/softcenter/bin/websocketd" ] && rm -rf /jffs/softcenter/bin/websocketd
	rm -rf /jffs/softcenter/bin/pdnsd
	rm -rf /jffs/softcenter/bin/dns2socks
	rm -rf /jffs/softcenter/bin/chinadns-ng
	rm -rf /jffs/softcenter/bin/client_linux
	rm -rf /jffs/softcenter/bin/xray
	rm -rf /jffs/softcenter/bin/xray1
	rm -rf /jffs/softcenter/bin/xray2
	rm -rf /jffs/softcenter/bin/hw-curl
	rm -rf /jffs/softcenter/bin/httping
	rm -rf /jffs/softcenter/bin/hysteria
	rm -rf /jffs/softcenter/bin/ipt2socks
	rm -rf /jffs/softcenter/bin/tuic-client
	rm -rf /jffs/softcenter/res/icon-helloworld.png
	rm -rf /jffs/softcenter/res/ss-menu.js
	rm -rf /jffs/softcenter/res/tablednd.js
	rm -rf /jffs/softcenter/res/helloworld.css
	find /jffs/softcenter/init.d/ -name "*helloworld.sh" | xargs rm -rf
	find /jffs/softcenter/init.d/ -name "*socks5.sh" | xargs rm -rf

	echo_date 开始复制文件！
	cd /tmp

	echo_date 复制相关二进制文件！此步时间可能较长！
	if [ -f "/usr/sbin/lua" ];then
		rm -f /tmp/helloworld/bin/lua
		ln -sf /usr/sbin/lua /jffs/softcenter/bin/lua
	fi
	if [ -f "/rom/etc/softcenter/bin/websocketd" ];then
		rm -f /tmp/helloworld/bin/websocketd
		ln -sf /usr/sbin/websocketd /jffs/softcenter/bin/websocketd
	fi
	cp -rf /tmp/helloworld/bin/* /jffs/softcenter/bin/

	echo_date 复制相关的脚本文件！
	cp -rf /tmp/helloworld/ss /jffs/softcenter/
	cp -rf /tmp/helloworld/scripts/* /jffs/softcenter/scripts/
	cp -rf /tmp/helloworld/install.sh /jffs/softcenter/scripts/ss_install.sh
	cp -rf /tmp/helloworld/uninstall.sh /jffs/softcenter/scripts/uninstall_helloworld.sh

	echo_date 复制相关的网页文件！
	cp -rf /tmp/helloworld/webs/* /jffs/softcenter/webs/
	cp -rf /tmp/helloworld/res/* /jffs/softcenter/res/

	echo_date 为新安装文件赋予执行权限...
	chmod 755 /jffs/softcenter/ss/rules/*
	chmod 755 /jffs/softcenter/ss/*
	chmod 755 /jffs/softcenter/scripts/ss*
	chmod 755 /jffs/softcenter/bin/*

	if [ -x "/jffs/softcenter/bin/websocketd" -a -f "/jffs/softcenter/ss/websocket.sh" ];then
		if [ -z "$(pidof websocketd)" ];then
			cd /jffs/softcenter/bin
			./websocketd --port=8030 /bin/sh /jffs/softcenter/ss/websocket.sh >/dev/null 2>&1 &
		fi
	fi

	set_skin

	if [ -n "$(ls /tmp/ss_backup/P*.sh 2>/dev/null)" ];then
		echo_date 恢复触发脚本!
		mkdir -p /jffs/softcenter/ss/postscripts
		find /tmp/ss_backup -name "P*.sh" | xargs -i mv {} -f /jffs/softcenter/ss/postscripts
	fi

	echo_date 创建一些二进制文件的软链接！
	[ ! -L "/jffs/softcenter/init.d/S99helloworld.sh" ] && ln -sf /jffs/softcenter/ss/ssconfig.sh /jffs/softcenter/init.d/S99helloworld.sh
	[ ! -L "/jffs/softcenter/init.d/N99helloworld.sh" ] && ln -sf /jffs/softcenter/ss/ssconfig.sh /jffs/softcenter/init.d/N99helloworld.sh

	# 设置一些默认值
	echo_date 设置一些默认值
	[ -z "$ssconf_dns_china" ] && dbus set ssconf_dns_china=11
	[ -z "$ssconf_dns_foreign" ] && dbus set ssconf_dns_foreign=1
	[ -z "$ssconf_acl_default_mode" ] && dbus set ssconf_acl_default_mode=1
	[ -z "$ssconf_acl_default_port" ] && dbus set ssconf_acl_default_port=all
	[ -z "$ssconf_basic_interval" ] && dbus set ssconf_basic_interval=2

	# 离线安装时设置软件中心内储存的版本号和连接

	dbus set ssconf_basic_version_local="${PLVER}"
	dbus set softcenter_module_helloworld_install="1"
	dbus set softcenter_module_helloworld_version="${PLVER}"
	dbus set softcenter_module_helloworld_title="helloworld"
	dbus set softcenter_module_helloworld_description="helloworld"


	echo_date helloworld插件安装成功！

	if [ "$ssconf_basic_enable" == "1" ];then
		echo_date 重启helloworld插件！
		sh /jffs/softcenter/ss/ssconfig.sh restart
	fi

	echo_date 更新完毕，请等待网页自动刷新！
	echo_date 已放弃xtls支持，更新为reality支持，重新订阅以修复配置
	exit_install
}

install(){
	get_model
	platform_test
	install_now
}

install
