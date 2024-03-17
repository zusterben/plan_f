#!/bin/sh

source /jffs/softcenter/scripts/ss_base.sh

get_mode_name() {
	case "$1" in
	1)
		echo "【gfwlist模式】"
		;;
	2)
		echo "【大陆白名单模式】"
		;;
	3)
		echo "【游戏模式】"
		;;
	5)
		echo "【全局模式】"
		;;
	esac
}

get_dns_name() {
	case "$1" in
	1)
		echo "pdnsd"
		;;
	2)
		echo "chinadns-ng"
		;;
	3)
		echo "dns2socks"
		;;
	4)
		echo "smartdns"
		;;
	8)
		echo "直连"
		;;
	esac
}

check_status() {
	#echo
	XRAY=$(pidof xray)
	game_on=$(dbus list ssconf_acl_mode | cut -d "=" -f 2 | grep 3)
	echo
	echo 检测当前相关进程工作状态：（你正在使用xray,选择的模式是$(get_mode_name $ssconf_basic_mode),国外DNS解析方案是：$(get_dns_name $ssconf_foreign_dns)）
	echo -----------------------------------------------------------
	echo "程序		状态	PID"
	[ -n "$XRAY" ] && echo "xray		工作中	pid：$XRAY" || echo "xray	未运行"

	echo -----------------------------------------------------------
	echo
	echo
	echo ③ 检测iptbales工作状态：
	echo ----------------------------------------------------- nat表 PREROUTING 链 --------------------------------------------------------
	iptables -nvL PREROUTING -t nat
	echo
	echo ----------------------------------------------------- nat表 OUTPUT 链 ------------------------------------------------------------
	iptables -nvL OUTPUT -t nat
	echo
	echo ----------------------------------------------------- nat表 SHADOWSOCKS 链 --------------------------------------------------------
	iptables -nvL SHADOWSOCKS -t nat
	echo
	echo ----------------------------------------------------- nat表 SHADOWSOCKS_EXT 链 --------------------------------------------------------
	iptables -nvL SHADOWSOCKS_EXT -t nat
	echo
	echo ----------------------------------------------------- nat表 SHADOWSOCKS_GFW 链 ----------------------------------------------------
	iptables -nvL SHADOWSOCKS_GFW -t nat
	echo
	echo ----------------------------------------------------- nat表 SHADOWSOCKS_CHN 链 -----------------------------------------------------
	iptables -nvL SHADOWSOCKS_CHN -t nat
	echo
	echo ----------------------------------------------------- nat表 SHADOWSOCKS_GAM 链 -----------------------------------------------------
	iptables -nvL SHADOWSOCKS_GAM -t nat
	echo
	echo ----------------------------------------------------- nat表 SHADOWSOCKS_GLO 链 -----------------------------------------------------
	iptables -nvL SHADOWSOCKS_GLO -t nat
	echo
	echo ----------------------------------------------------- nat表 SHADOWSOCKS_HOM 链 -----------------------------------------------------
	iptables -nvL SHADOWSOCKS_HOM -t nat
	echo -----------------------------------------------------------------------------------------------------------------------------------
	echo
	[ -n "$game_on" ] || [ "$ssconf_basic_mode" == "3" ] && echo ------------------------------------------------------ mangle表 PREROUTING 链 -------------------------------------------------------
	[ -n "$game_on" ] || [ "$ssconf_basic_mode" == "3" ] && iptables -nvL PREROUTING -t mangle
	[ -n "$game_on" ] || [ "$ssconf_basic_mode" == "3" ] && echo
	[ -n "$game_on" ] || [ "$ssconf_basic_mode" == "3" ] && echo ------------------------------------------------------ mangle表 SHADOWSOCKS 链 -------------------------------------------------------
	[ -n "$game_on" ] || [ "$ssconf_basic_mode" == "3" ] && iptables -nvL SHADOWSOCKS -t mangle
	[ -n "$game_on" ] || [ "$ssconf_basic_mode" == "3" ] && echo
	[ -n "$game_on" ] || [ "$ssconf_basic_mode" == "3" ] && echo ------------------------------------------------------ mangle表 SHADOWSOCKS_GAM 链 -------------------------------------------------------
	[ -n "$game_on" ] || [ "$ssconf_basic_mode" == "3" ] && iptables -nvL SHADOWSOCKS_GAM -t mangle
	echo -----------------------------------------------------------------------------------------------------------------------------------
	echo
}

if [ "$ssconf_basic_enable" == "1" ]; then
	check_status >/tmp/upload/ss_proc_status.txt 2>&1
	#echo XU6J03M6 >> /tmp/upload/ss_proc_status.txt
else
	echo 插件尚未启用！ >/tmp/upload/ss_proc_status.txt 2>&1
fi

http_response $1
