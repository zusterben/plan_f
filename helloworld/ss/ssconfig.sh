#!/bin/sh

eval `dbus export ssconf`
source /jffs/softcenter/scripts/ss_base.sh
# Variable definitions
THREAD=$(grep -c '^processor' /proc/cpuinfo)
dbus set ssconf_basic_version_local=`cat /jffs/softcenter/ss/version`
mkdir -p /tmp/upload
LOG_FILE=/tmp/upload/ss_log.txt
CONFIG_FILE_TMP=/tmp/helloworld.json
CONFIG_FILE="/jffs/softcenter/ss/helloworld.json"
CONFIG_NETFLIX_FILE="/jffs/softcenter/ss/v2ray_n.json"
LOCK_FILE=/var/lock/helloworld.lock
DNSF_PORT=7913
DNSC_PORT=53
ISP_DNS1=$(nvram get wan0_dns | sed 's/ /\n/g' | grep -v 0.0.0.0 | grep -v 127.0.0.1 | sed -n 1p)
ISP_DNS2=$(nvram get wan0_dns | sed 's/ /\n/g' | grep -v 0.0.0.0 | grep -v 127.0.0.1 | sed -n 2p)
IFIP_DNS1=$(echo $ISP_DNS1 | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}|:")
IFIP_DNS2=$(echo $ISP_DNS2 | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}|:")
lan_ipaddr=$(nvram get lan_ipaddr)
ip_prefix_hex=$(nvram get lan_ipaddr | awk -F "." '{printf ("0x%02x", $1)} {printf ("%02x", $2)} {printf ("%02x", $3)} {printf ("00/0xffffff00\n")}')
OUTBOUNDS="[]"
NODE_JSON=""
NODE_TYPE=0
NODE_MODE="tcp,udp"
KVER=$(uname -r)
#if [ "$(/jffs/softcenter/bin/versioncmp 3.10 $KVER)" == "1" ];then
#	FASTOPEN=0
#else
	FASTOPEN=0
#fi
if [ "$(dbus get softcenter_arch)" == "armv7l" ];then
THREAD=1
fi
#-----------------------------------------------

cmd() {
	echo_date "$*" 2>&1
	"$@"
}

set_lock() {
	exec 1000>"$LOCK_FILE"
	flock -x 1000
}

unset_lock() {
	flock -u 1000
	rm -rf "$LOCK_FILE"
}

get_lan_cidr() {
	local netmask=$(nvram get lan_netmask)
	local x=${netmask##*255.}
	set -- 0^^^128^192^224^240^248^252^254^ $(((${#netmask} - ${#x}) * 2)) ${x%%.*}
	x=${1%%$3*}
	suffix=$(($2 + (${#x} / 4)))
	#prefix=`nvram get lan_ipaddr | cut -d "." -f1,2,3`
	echo $lan_ipaddr/$suffix
}

get_wan0_cidr() {
	local netmask=$(nvram get wan0_netmask)
	local x=${netmask##*255.}
	set -- 0^^^128^192^224^240^248^252^254^ $(((${#netmask} - ${#x}) * 2)) ${x%%.*}
	x=${1%%$3*}
	suffix=$(($2 + (${#x} / 4)))
	prefix=$(nvram get wan0_ipaddr)
	if [ -n "$prefix" -a -n "$netmask" ]; then
		echo $prefix/$suffix
	else
		echo ""
	fi
}

close_in_five() {
	echo_date "插件将在5秒后自动关闭！！"
	local i=5
	while [ $i -ge 0 ]; do
		sleep 1
		echo_date $i
		let i--
	done
	dbus set ssconf_basic_enable="0"
	disable_ss >/dev/null
	echo_date "插件已关闭！！"
	echo_date ======================= 梅林固件 - 【科学上网】 ========================
	unset_lock
	exit
}

__get_type_abbr_name() {
	case "$NODE_TYPE" in
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
	4)
		echo "hysteria"
		;;
	esac
}

# ================================= ss stop ===============================
restore_conf() {
	echo_date 删除ss相关的名单配置文件.
	rm -rf /tmp/etc/dnsmasq.user/gfwlist.conf
	rm -rf /tmp/etc/dnsmasq.user/cdn.conf
	rm -rf /tmp/etc/dnsmasq.user/custom.conf
	rm -rf /tmp/etc/dnsmasq.user/wblist.conf
	rm -rf /tmp/etc/dnsmasq.user/ss_host.conf
	rm -rf /tmp/etc/dnsmasq.user/ss_server.conf
	rm -rf /jffs/configs/dnsmasq.conf.add
	rm -rf /jffs/scripts/dnsmasq.postconf
	rm -rf /tmp/sscdn.conf
	rm -rf /tmp/custom.conf
	rm -rf /tmp/wblist.conf
	rm -rf /tmp/ss_host.conf
	rm -rf /etc/seconddns.conf
	rm -rf /tmp/gfwlist.txt
}

kill_process() {
	xray_process=$(pidof xray)
	if [ -n "$xray_process" ]; then
		echo_date 关闭xray进程...
		killall xray >/dev/null 2>&1
		kill -9 "$xray_process" >/dev/null 2>&1
	fi
	chinadnsNG_process=$(pidof chinadns-ng)
	if [ -n "$chinadnsNG_process" ]; then
		echo_date 关闭chinadns-ng进程...
		killall chinadns-ng >/dev/null 2>&1
	fi
	pdnsd_process=$(pidof pdnsd)
	if [ -n "$pdnsd_process" ]; then
		echo_date 关闭pdnsd进程...
		killall pdnsd >/dev/null 2>&1
	fi
	dns2socks_process=$(pidof dns2socks)
	if [ -n "$dns2socks_process" ]; then
		echo_date 关闭dns2socks进程...
		killall dns2socks >/dev/null 2>&1
	fi
	redsocks2_process=$(pidof redsocks2)
	if [ -n "$redsocks2_process" ];then 
		echo_date 关闭redsocks2进程...
		killall redsocks2 >/dev/null 2>&1
	fi
	client_linux_process=$(pidof client_linux)
	if [ -n "$client_linux_process" ];then 
		echo_date 关闭kcp协议进程...
		killall client_linux >/dev/null 2>&1
	fi
	if [ "$FASTOPEN" == "1" ];then
		echo 1 >/proc/sys/net/ipv4/tcp_fastopen
	fi
}

# ================================= ss start ==============================

resolv_server_ip() {
#任何情况下代理服务器都不能走代理
	local tmp server_ip
	tmp=$(dbus get ssconf_basic_json_$ssconf_basic_node | base64 -d | jq -r .server)
	server_ip=$(__resolve_ip "$tmp")
	case $? in
	0)
		echo_date "服务器【$tmp】的ip地址解析成功：$server_ip"
		echo "server=/$tmp/$(__get_server_resolver)#$(__get_server_resolver_port)" >/etc/dnsmasq.user/ss_server.conf
		ssconf_basic_server_ip="$server_ip"
		dbus set ssconf_basic_server_ip="$server_ip"
		;;
	*)
		echo_date "服务器的ip地址解析失败... "
		unset ssconf_basic_server_ip
		dbus remvoe ssconf_basic_server_ip
		close_in_five
		;;
	esac
}

# create shadowsocks config file...
create_ss_json(){
	echo_date "创建$(__get_type_abbr_name)配置文件到$CONFIG_FILE"

	/jffs/softcenter/bin/lua /jffs/softcenter/scripts/ss_genconfig.lua "$ssconf_basic_node" "$NODE_MODE" 3333 23456 > $CONFIG_FILE_TMP
	cat "$CONFIG_FILE_TMP" | jq --tab . > $CONFIG_FILE
	if [ "$ssconf_basic_netflix_enable" == "1" ]; then
		rm -rf $CONFIG_FILE_TMP
		/jffs/softcenter/bin/lua /jffs/softcenter/scripts/ss_genconfig.lua "$ssconf_basic_node" "$NODE_MODE" 4321 1088 > $CONFIG_FILE_TMP
		cat "$CONFIG_FILE_TMP" | jq --tab . > $CONFIG_NETFLIX_FILE
	fi
	rm -rf $CONFIG_FILE_TMP
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
	esac
}


start_dns() {
	# 判断使用何种DNS优先方案
	if [ "$ssconf_basic_mode" == "1" -a -z "$chn_on" -a -z "$all_on" ] || [ "$ssconf_basic_mode" == "6" ];then
		# gfwlist模式的时候，且访问控制主机中不存在 大陆白名单模式 游戏模式 全局模式，则使用国内优先模式
		# 回国模式下自动判断使用国内优先
		local DNS_PLAN=1
	else
		# 其它情况，均使用国外优先模式
		local DNS_PLAN=2
	fi
	
	# 回国模式下强制改国外DNS为直连方式
	if [ "$ssconf_basic_mode" == "6" -a "$ssconf_foreign_dns" != "8" ]; then
		ssconf_foreign_dns="8"
		dbus set ssconf_foreign_dns="8"
	fi
	if [ "$NODE_TYPE" == "3" -a "$ssconf_foreign_dns" == "1" ]; then
		ssconf_foreign_dns=3
		dbus set ssconf_foreign_dns=3
	fi
	# Start pdnsd
	if [ "$ssconf_foreign_dns" == "1" ]; then
		[ "$DNS_PLAN" == "1" ] && echo_date "开启pdnsd，用于【国外gfwlist站点】的DNS解析..."
		[ "$DNS_PLAN" == "2" ] && echo_date "开启pdnsd，用于【国外所有网站】的DNS解析..."
		if [ ! -f "/var/pdnsd/pdnsd.cache" ]; then
			mkdir -p /var/pdnsd
			touch /var/pdnsd/pdnsd.cache
		fi
		cat <<-EOF >/etc/pdnsd.conf
			global{
			perm_cache=1024;
			cache_dir="/var/pdnsd";
			pid_file="/var/run/pdnsd.pid";
			run_as="nobody";
			server_ip=127.0.0.1;
			server_port=$DNSF_PORT;
			status_ctl=on;
			query_method=tcp_only;
			min_ttl=1h;
			max_ttl=1w;
			timeout=10;
			neg_domain_pol=on;
			proc_limit=2;
			procq_limit=8;
			par_queries=1;
			}
			server{
			label="ssr-usrdns";
			ip=8.8.8.8;
			port=53;
			timeout=6;
			uptest=none;
			interval=10m;
			purge_cache=off;
			}
		EOF
		chmod 644 /etc/pdnsd.conf
		/jffs/softcenter/bin/pdnsd -c /etc/pdnsd.conf >/dev/null 2>&1 &
	fi

	# Start chinadns-ng
	if [ "$ssconf_foreign_dns" == "2" ]; then
		echo_date 开启dns2socks，用于chinadns-ng的国外上游...
		dns2socks 127.0.0.1:23456 8.8.8.8:53 127.0.0.1:1055 >/dev/null 2>&1 &
		[ "$DNS_PLAN" == "1" ] && echo_date "开启chinadns-ng，用于【国内所有网站 + 国外gfwlist站点】的DNS解析..."
		[ "$DNS_PLAN" == "2" ] && echo_date "开启chinadns-ng，用于【国内所有网站 + 国外所有网站】的DNS解析..."
		cat /jffs/softcenter/ss/rules/gfwlist.conf|sed '/^server=/d'|sed 's/ipset=\/.//g'|sed 's/\/gfwlist//g' > /tmp/gfwlist.txt
		chinadns-ng -l ${DNSF_PORT} -c ${CDN}#${DNSC_PORT} -t 127.0.0.1#1055 -g /tmp/gfwlist.txt -m /jffs/softcenter/ss/rules/cdn.txt -M >/dev/null 2>&1 &
	fi

	# Start DNS2SOCKS (default)
	if [ "$ssconf_foreign_dns" == "3" ] || [ -z "$ssconf_foreign_dns" ]; then
		[ -z "$ssconf_foreign_dns" ] && dbus set ssconf_foreign_dns="3"
		[ "$DNS_PLAN" == "1" ] && echo_date "开启dns2socks，用于【国外gfwlist站点】的DNS解析..."
		[ "$DNS_PLAN" == "2" ] && echo_date "开启dns2socks，用于【国外所有网站】的DNS解析..."
		dns2socks 127.0.0.1:23456 8.8.8.8:53 127.0.0.1:$DNSF_PORT >/dev/null 2>&1 &
	fi

	# Start smartdns
	if [ "$ssconf_foreign_dns" == "4" ]; then
		[ "$DNS_PLAN" == "1" ] && echo_date "开启smartdns，用于【国外gfwlist站点】的DNS解析..."
		[ "$DNS_PLAN" == "2" ] && echo_date "开启smartdns，用于【国外所有网站】的DNS解析..."
		echo "bind [::]:$DNSF_PORT -group foreign" >> /etc/seconddns.conf
		echo "bind-tcp [::]:$DNSF_PORT -group foreign" >> /etc/seconddns.conf
		echo "force-AAAA-SOA yes" >> /etc/seconddns.conf
		echo "server-tcp 8.8.8.8:53 -group foreign" >> /etc/seconddns.conf
		service restart_smartdns
	fi
	# direct
	if [ "$ssconf_foreign_dns" == "8" ]; then
		if [ "$ssconf_basic_mode" == "6" ]; then
			echo_date 回国模式，国外DNS采用直连方案。
		else
			echo_date 非回国模式，国外DNS直连解析不能使用，自动切换到dns2socks方案。
			dbus set ssconf_foreign_dns=3
			[ "$DNS_PLAN" == "1" ] && echo_date "开启dns2socks，用于【国外gfwlist站点】的DNS解析..."
			[ "$DNS_PLAN" == "2" ] && echo_date "开启dns2socks，用于【国外所有网站】的DNS解析..."
			dns2socks 127.0.0.1:23456 8.8.8.8:53 127.0.0.1:$DNSF_PORT >/dev/null 2>&1 &
		fi
	fi
}
#--------------------------------------------------------------------------------------

detect_domain() {
	domain1=$(echo $1 | grep -E "^https://|^http://|www|/")
	domain2=$(echo $1 | grep -E "\.")
	if [ -n "$domain1" ] || [ -z "$domain2" ]; then
		return 1
	else
		return 0
	fi
}

create_dnsmasq_conf() {
	if [ "$ssconf_dns_china" == "1" ]; then
		if [ "$ssconf_basic_mode" == "6" ]; then
			# 使用回国模式的时候，ISP dns是国外的，所以这里直接用114取代
			CDN="114.114.114.114"
		else
			if [ -n "$IFIP_DNS1" ]; then
				# 用chnroute去判断运营商DNS是否为局域网(国外)ip地址，有些二级路由的是局域网ip地址，会被ChinaDNS 判断为国外dns服务器，这个时候用114取代之
				ipset test chnroute $IFIP_DNS1 >/dev/null 2>&1
				if [ "$?" != "0" ]; then
					# 运营商DNS：ISP_DNS1是局域网(国外)ip
					CDN="114.114.114.114"
				else
					# 运营商DNS：ISP_DNS1是国内ip
					CDN="$ISP_DNS1"
				fi
			else
				# 运营商DNS：ISP_DNS1不是ip格式，用114取代之
				CDN="114.114.114.114"
			fi
		fi
	fi
	[ "$ssconf_dns_china" == "2" ] && CDN="223.5.5.5"
	[ "$ssconf_dns_china" == "3" ] && CDN="223.6.6.6"
	[ "$ssconf_dns_china" == "4" ] && CDN="114.114.114.114"
	[ "$ssconf_dns_china" == "5" ] && CDN="114.114.115.115"
	[ "$ssconf_dns_china" == "6" ] && CDN="1.2.4.8"
	[ "$ssconf_dns_china" == "7" ] && CDN="210.2.4.8"
	[ "$ssconf_dns_china" == "8" ] && CDN="117.50.11.11"
	[ "$ssconf_dns_china" == "9" ] && CDN="117.50.22.22"
	[ "$ssconf_dns_china" == "10" ] && CDN="180.76.76.76"
	[ "$ssconf_dns_china" == "11" ] && CDN="119.29.29.29"

	# delete pre settings
	rm -rf /tmp/sscdn.conf
	rm -rf /tmp/custom.conf
	rm -rf /tmp/wblist.conf
	rm -rf /tmp/gfwlist.conf
	rm -rf /tmp/gfwlist.txt
	rm -rf /etc/dnsmasq.user/custom.conf
	rm -rf /etc/dnsmasq.user/wblist.conf
	rm -rf /etc/dnsmasq.user/cdn.conf
	rm -rf /etc/dnsmasq.user/gfwlist.conf
	rm -rf /etc/dnsmasq.user/netflix_forward.conf
	rm -rf /jffs/scripts/dnsmasq.postconf
	rm -rf /etc/seconddns.conf

	# custom dnsmasq settings by user
	if [ -n "$ssconf_dnsmasq" ]; then
		echo_date 添加自定义dnsmasq设置到/tmp/custom.conf
		echo "$ssconf_dnsmasq" | base64_decode | sort -u >>/tmp/custom.conf
	fi

	# these sites need to go ss inside router
	if [ "$ssconf_basic_mode" != "6" ]; then
		echo "#for router itself" >>/tmp/wblist.conf
		echo "server=/.google.com.tw/127.0.0.1#$DNSF_PORT" >>/tmp/wblist.conf
		echo "ipset=/.google.com.tw/router" >>/tmp/wblist.conf
		#echo "server=/dns.google.com/127.0.0.1#$DNSF_PORT" >>/tmp/wblist.conf
		echo "ipset=/dns.google.com/router" >>/tmp/wblist.conf
		#echo "server=/.github.com/127.0.0.1#$DNSF_PORT" >>/tmp/wblist.conf
		echo "ipset=/github.com/router" >>/tmp/wblist.conf
		#echo "server=/.github.io/127.0.0.1#$DNSF_PORT" >>/tmp/wblist.conf
		echo "ipset=/github.io/router" >>/tmp/wblist.conf
		#echo "server=/.raw.githubusercontent.com/127.0.0.1#$DNSF_PORT" >>/tmp/wblist.conf
		echo "ipset=/githubusercontent.com/router" >>/tmp/wblist.conf
		echo "server=/.adblockplus.org/127.0.0.1#$DNSF_PORT" >>/tmp/wblist.conf
		echo "ipset=/.adblockplus.org/router" >>/tmp/wblist.conf
		echo "server=/.entware.net/127.0.0.1#$DNSF_PORT" >>/tmp/wblist.conf
		echo "ipset=/.entware.net/router" >>/tmp/wblist.conf
		echo "server=/.apnic.net/127.0.0.1#$DNSF_PORT" >>/tmp/wblist.conf
		echo "ipset=/.apnic.net/router" >>/tmp/wblist.conf
	fi

	# append white domain list, not through ss
	wanwhitedomain=$(echo $ssconf_wan_white_domain | base64_decode)
	if [ -n "$ssconf_wan_white_domain" ]; then
		echo_date 应用域名白名单
		echo "#for white_domain" >>/tmp/wblist.conf
		for wan_white_domain in $wanwhitedomain; do
			detect_domain "$wan_white_domain"
			if [ "$?" == "0" ]; then
				# 回国模式下，用外国DNS，否则用中国DNS。
				if [ "$ssconf_basic_mode" != "6" ]; then
					echo "$wan_white_domain" | sed "s/^/server=&\/./g" | sed "s/$/\/$CDN#$DNSC_PORT/g" >>/tmp/wblist.conf
					echo "$wan_white_domain" | sed "s/^/ipset=&\/./g" | sed "s/$/\/white_list/g" >>/tmp/wblist.conf
				else
					echo "$wan_white_domain" | sed "s/^/server=&\/./g" | sed "s/$/\/8.8.8.8#53/g" >>/tmp/wblist.conf
					echo "$wan_white_domain" | sed "s/^/ipset=&\/./g" | sed "s/$/\/white_list/g" >>/tmp/wblist.conf
				fi
			else
				echo_date ！！检测到域名白名单内的【"$wan_white_domain"】不是域名格式！！此条将不会添加！！
			fi
		done
	fi

	# 非回国模式下，apple 和 microsoft需要中国cdn；
	# 另外：dns.msftncsi.com是asuswrt/merlin固件里，用以判断网络是否畅通的地址，固件后台会通过解析dns.msftncsi.com （nvram get dns_probe_content），并检查其解析结果是否和`nvram get dns_probe_content`匹配
	# 此地址在非回国模式下用国内DNS解析，以免SS/SSR/V2RAY线路挂掉，导致一些走远端解析的情况下，无法获取到dns.msftncsi.com的解析结果，从而使得【网络地图】中网络显示断开。
	if [ "$ssconf_basic_mode" != "6" ]; then
		echo "#for special site (Mandatory China DNS)" >>/tmp/wblist.conf
		for wan_white_domain2 in "apple.com" "microsoft.com" "dns.msftncsi.com bilibili.com bilibili.cn bilivideo.com  bilivideo.cn  biliapi.com  biliapi.net"; do
			echo "$wan_white_domain2" | sed "s/^/server=&\/./g" | sed "s/$/\/$CDN#$DNSC_PORT/g" >>/tmp/wblist.conf
			echo "$wan_white_domain2" | sed "s/^/ipset=&\/./g" | sed "s/$/\/white_list/g" >>/tmp/wblist.conf
		done
	fi

	# append black domain list, through ss
	wanblackdomain=$(echo $ssconf_wan_black_domain | base64_decode)
	if [ -n "$ssconf_wan_black_domain" ]; then
		echo_date 应用域名黑名单
		echo "#for black_domain" >>/tmp/wblist.conf
		for wan_black_domain in $wanblackdomain; do
			detect_domain "$wan_black_domain"
			if [ "$?" == "0" ]; then
				if [ "$ssconf_basic_mode" != "6" ]; then
					echo "$wan_black_domain" | sed "s/^/server=&\/./g" | sed "s/$/\/127.0.0.1#$DNSF_PORT/g" >>/tmp/wblist.conf
					echo "$wan_black_domain" | sed "s/^/ipset=&\/./g" | sed "s/$/\/black_list/g" >>/tmp/wblist.conf
				else
					echo "$wan_black_domain" | sed "s/^/server=&\/./g" | sed "s/$/\/$CDN#$DNSC_PORT/g" >>/tmp/wblist.conf
					echo "$wan_black_domain" | sed "s/^/ipset=&\/./g" | sed "s/$/\/black_list/g" >>/tmp/wblist.conf
				fi
			else
				echo_date ！！检测到域名黑名单内的【"$wan_black_domain"】不是域名格式！！此条将不会添加！！
			fi
		done
	fi
	# 此处决定何时使用cdn.txt
	if [ "$ssconf_basic_mode" == "6" ]; then
		# 回国模式中，因为国外DNS无论如何都不会污染的，所以采取的策略是直连就行，默认国内优先即可
		echo_date 自动判断在回国模式中使用国内优先模式，不加载cdn.conf
	else
		if [ "$ssconf_basic_mode" == "1" -a -z "$chn_on" -a -z "$all_on" ] || [ "$ssconf_basic_mode" == "6" ]; then
			# gfwlist模式的时候，且访问控制主机中不存在 大陆白名单模式 游戏模式 全局模式，则使用国内优先模式
			# 回国模式下自动判断使用国内优先
			echo_date 自动判断使用国内优先模式，不加载cdn.conf
		elif [ "$ssconf_basic_mode" == "5" ];then
				echo_date 国外解析方案【$(get_dns_name $ssconf_foreign_dns)】，需要加载cdn.conf提供国内cdn...
				echo_date 生成cdn加速列表到/tmp/sscdn.conf，加速用的dns：$CDN
				echo "#for china site CDN acclerate" >>/tmp/sscdn.conf
				cat /jffs/softcenter/ss/rules/cdn.txt | sed "s/^/server=&\/./g" | sed "s/$/\/&127.0.0.1#9053/g" | sort | awk '{if ($0!=line) print;line=$0}' >>/tmp/sscdn.conf
		else
			# 其它情况，均使用国外优先模式，以下区分是否加载cdn.conf
			if [ "$ssconf_foreign_dns" == "2" ]; then
				# 因为chinadns1 chinadns2自带国内cdn，所以也不需要cdn.conf
				echo_date 自动判断dns解析使用国外优先模式...
				echo_date 国外解析方案【$(get_dns_name $ssconf_foreign_dns)】自带国内cdn，无需加载cdn.conf，路由器开销小...
			else
				echo_date 自动判断dns解析使用国外优先模式...
				echo_date 国外解析方案【$(get_dns_name $ssconf_foreign_dns)】，需要加载cdn.conf提供国内cdn...
				echo_date 生成cdn加速列表到/tmp/sscdn.conf，加速用的dns：$CDN
				echo "#for china site CDN acclerate" >>/tmp/sscdn.conf
				cat /jffs/softcenter/ss/rules/cdn.txt | sed "s/^/server=&\/./g" | sed "s/$/\/&127.0.0.1#9053/g" | sort | awk '{if ($0!=line) print;line=$0}' >>/tmp/sscdn.conf
			fi
		fi
	fi
	#ln_conf
	if [ -f /tmp/custom.conf ]; then
		#echo_date 创建域自定义dnsmasq配置文件软链接到/etc/dnsmasq.user/custom.conf
		ln -sf /tmp/custom.conf /etc/dnsmasq.user/custom.conf
	fi
	if [ -f /tmp/wblist.conf ]; then
		#echo_date 创建域名黑/白名单软链接到/etc/dnsmasq.user/wblist.conf
		ln -sf /tmp/wblist.conf /etc/dnsmasq.user/wblist.conf
	fi

	if [ -f /tmp/sscdn.conf ]; then
		echo_date 创建cdn加速列表软链接/etc/dnsmasq.user/cdn.conf
		ln -sf /tmp/sscdn.conf /etc/dnsmasq.user/cdn.conf
	fi

	# 此处决定何时使用gfwlist.txt
	if [ "$ssconf_basic_mode" == "1" ]; then
		echo_date 创建gfwlist的软连接到/etc/dnsmasq.user/文件夹.
		ln -sf /jffs/softcenter/ss/rules/gfwlist.conf /etc/dnsmasq.user/gfwlist.conf
	elif [ "$ssconf_basic_mode" == "2" ] || [ "$ssconf_basic_mode" == "3" ]; then
		if [ -n "$gfw_on" ]; then
			echo_date 创建gfwlist的软连接到/etc/dnsmasq.user/文件夹.
			ln -sf /jffs/softcenter/ss/rules/gfwlist.conf /etc/dnsmasq.user/gfwlist.conf
		fi
	elif [ "$ssconf_basic_mode" == "6" ]; then
		# 回国模式下默认方案是国内优先，所以gfwlist里的网站不能由127.0.0.1#7913来解析了，应该是国外当地直连
		echo_date 创建回国模式专用gfwlist的软连接到/etc/dnsmasq.user/文件夹.
		cat /jffs/softcenter/ss/rules/gfwlist.conf|sed "s/127.0.0.1#$DNSF_PORT/8.8.8.8#53/g" > /tmp/gfwlist.conf
		ln -sf /tmp/gfwlist.conf /etc/dnsmasq.user/gfwlist.conf
	fi
	if [ "$ssconf_basic_netflix_enable" == "1" ];then
		if [ -f "/etc/dnsmasq.user/gfwlist.conf" ]; then
			for line in $(cat /jffs/softcenter/ss/rules/netflix.list); do sed -i "/$line/d" /etc/dnsmasq.user/gfwlist.conf; done
			for line in $(cat /jffs/softcenter/ss/rules/netflix.list); do sed -i "/$line/d" /etc/dnsmasq.user/gfwlist.conf; done
		fi
		awk '!/^$/&&!/^#/{printf("ipset=/%s/'"netflix"'\n",$0)}' /jffs/softcenter/ss/rules/netflix.list >/etc/dnsmasq.user/netflix_forward.conf
		awk '!/^$/&&!/^#/{printf("server=/%s/'"127.0.0.1#5555"'\n",$0)}' /jffs/softcenter/ss/rules/netflix.list >>/etc/dnsmasq.user/netflix_forward.conf
	fi
	#echo_date 创建dnsmasq.postconf软连接到/jffs/scripts/文件夹.
	[ ! -L "/jffs/scripts/dnsmasq.postconf" ] && ln -sf /jffs/softcenter/ss/rules/dnsmasq.postconf /jffs/scripts/dnsmasq.postconf
}

auto_start() {
	[ ! -L "/jffs/softcenter/init.d/S99helloworld.sh" ] && ln -sf /jffs/softcenter/ss/ssconfig.sh /jffs/softcenter/init.d/S99helloworld.sh
	[ ! -L "/jffs/softcenter/init.d/N99helloworld.sh" ] && ln -sf /jffs/softcenter/ss/ssconfig.sh /jffs/softcenter/init.d/N99helloworld.sh
}

start_kcp() {
	# Start kcp

	if [ "$ssconf_basic_use_kcp" == "1" ]; then
		echo_date 当前插件不支持kcp，请取消.
#		local key=""
#		if [ "$ssconf_basic_kcp_password" != "" ]; then
#			key="--key $ssconf_basic_kcp_password"
#		fi
#		echo_date 启动KCP协议进程，为了更好的体验，建议在路由器上创建虚拟内存.
#		export GOGC=30
#		
#		[ -z "$ssconf_basic_kcp_server" ] && ssconf_basic_kcp_server="$ssconf_basic_server"
#		start-stop-daemon -S -q -b -m -p /tmp/var/kcp.pid -x /jffs/softcenter/bin/client_linux  -- -l  $ssconf_basic_kcp_lserver:$ssconf_basic_kcp_lport \
#				-r $ssconf_basic_kcp_server:$ssconf_basic_kcp_port $key $ssconf_basic_kcp_parameter
	fi
}

create_v2ray_json(){
	echo_date "创建$(__get_type_abbr_name)配置文件到$CONFIG_FILE"
	local tmp v2ray_server_ip
	rm -rf "$CONFIG_FILE_TMP"
	rm -rf "$CONFIG_FILE"
	echo_date 生成V2Ray配置文件...
	/jffs/softcenter/bin/lua /jffs/softcenter/scripts/ss_genconfig.lua "$ssconf_basic_node" "$NODE_MODE" 3333 23456 > $CONFIG_FILE_TMP

	echo_date 解析V2Ray配置文件...
	cat "$CONFIG_FILE_TMP" | jq --tab . >"$CONFIG_FILE"
	echo_date V2Ray配置文件写入成功到"$CONFIG_FILE"

	echo_date 测试V2Ray配置文件.....
	cd /jffs/softcenter/bin
	result=$(xray test -config="$CONFIG_FILE" | grep "Configuration OK.")
	if [ -n "$result" ]; then
		echo_date V2Ray配置文件通过测试!!!
	else
		echo_date V2Ray配置文件没有通过测试，请检查设置!!!
		result=$(xray test -config="$CONFIG_FILE")
		echo_date "$result"
		rm -rf "$CONFIG_FILE_TMP"
		rm -rf "$CONFIG_FILE"
		close_in_five
	fi
}

create_v2ray_netflix(){
	echo_date "创建$(__get_type_abbr_name)配置文件到$CONFIG_NETFLIX_FILE"
	local tmp v2ray_server_ip
	rm -rf "$CONFIG_FILE_TMP"
	rm -rf "$CONFIG_NETFLIX_FILE"

	echo_date 生成V2Ray配置文件...
	/jffs/softcenter/bin/lua /jffs/softcenter/scripts/ss_genconfig.lua "$ssconf_basic_node" "$NODE_MODE" 4321 1088 > $CONFIG_FILE_TMP
	echo_date 解析V2Ray配置文件...
	cat "$CONFIG_FILE_TMP" | jq --tab . >"$CONFIG_NETFLIX_FILE"
	echo_date V2Ray配置文件写入成功到"$CONFIG_NETFLIX_FILE"

	echo_date 测试V2Ray配置文件.....
	cd /jffs/softcenter/bin
	result=$(xray test -config="$CONFIG_NETFLIX_FILE" | grep "Configuration OK.")
	if [ -n "$result" ]; then
		echo_date V2Ray配置文件通过测试!!!
	else
		echo_date V2Ray配置文件没有通过测试，请检查设置!!!
		result=$(xray test -config="$CONFIG_NETFLIX_FILE")
		echo_date "$result"
		rm -rf "$CONFIG_FILE_TMP"
		rm -rf "$CONFIG_NETFLIX_FILE"
		close_in_five
	fi
}


start_v2ray() {
	# tfo start
	if [ "$ssconf_basic_tfo" == "1" ] && [ "$FASTOPEN" == "1" ]; then
		echo_date 开启tcp fast open支持.
		echo 3 >/proc/sys/net/ipv4/tcp_fastopen
	fi

	# v2ray start
	cd /jffs/softcenter/bin
	export GOGC=30
	xray run -config=${CONFIG_FILE} >/dev/null 2>&1 &
	local V2PID
	local i=10
	until [ -n "$V2PID" ]; do
		i=$(($i - 1))
		V2PID=$(pidof xray)
		if [ "$i" -lt 1 ]; then
			echo_date "v2ray进程启动失败！"
			close_in_five
		fi
		usleep 250000
	done
	echo_date v2ray启动成功，pid：$V2PID
}

create_hysteria_json(){
	echo_date "创建$(__get_type_abbr_name)配置文件到$CONFIG_FILE"
	rm -rf "$CONFIG_FILE_TMP"
	rm -rf "$CONFIG_FILE"
	echo_date 生成hysteria配置文件...
	/jffs/softcenter/bin/gen_conf "$ssconf_basic_type" $CONFIG_FILE_TMP 3333 23456 "tcp,udp"
	if [ "$(cat $CONFIG_FILE_TMP)" != "" ];then 
		echo_date 解析hysteria配置文件...
		cat "$CONFIG_FILE_TMP" | jq --tab . >"$CONFIG_FILE"
		echo_date hysteria配置文件写入成功到"$CONFIG_FILE"
	else
		echo_date hysteria配置文件生成失败，请检查设置!!!
		rm -rf "$CONFIG_FILE_TMP"
		rm -rf "$CONFIG_FILE"
		close_in_five
	fi
}

start_hysteria(){
	cd /jffs/softcenter/bin
	hysteria -c "$CONFIG_FILE" --no-check client >/dev/null 2>&1 &
	local pid
	local i=10
	until [ -n "$pid" ]; do
		i=$(($i - 1))
		pid=$(pidof hysteria)
		if [ "$i" -lt 1 ]; then
			echo_date "hysteria进程启动失败！"
			close_in_five
		fi
		usleep 250000
	done
	echo_date "hysteria启动成功，pid：$pid"
}

write_cron_job() {
	sed -i '/ssupdate/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	if [ "1" == "$ssconf_basic_rule_update" ]; then
		echo_date 添加ss规则定时更新任务，每天"$ssconf_basic_rule_update_time"自动检测更新规则.
		cru a ssupdate "0 $ssconf_basic_rule_update_time * * * /bin/sh /jffs/softcenter/scripts/ss_rule_update.sh"
	else
		echo_date ss规则定时更新任务未启用！
	fi
	sed -i '/ssnodeupdate/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	if [ "$ssconf_basic_node_update" = "1" ]; then
		if [ "$ssconf_basic_node_update_day" = "7" ]; then
			cru a ssnodeupdate "0 $ssconf_basic_node_update_hr * * * /jffs/softcenter/scripts/ss_online_update.sh 3"
			echo_date "设置订阅服务器自动更新订阅服务器在每天 $ssconf_basic_node_update_hr 点。"
		else
			cru a ssnodeupdate "0 $ssconf_basic_node_update_hr * * $ssconf_basic_node_update_day /jffs/softcenter/scripts/ss_online_update.sh 3"
			echo_date "设置订阅服务器自动更新订阅服务器在星期 $ssconf_basic_node_update_day 的 $ssconf_basic_node_update_hr 点。"
		fi
	fi
}

kill_cron_job() {
	if [ -n "$(cru l | grep ssupdate)" ]; then
		echo_date 删除ss规则定时更新任务...
		sed -i '/ssupdate/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
	if [ -n "$(cru l | grep ssnodeupdate)" ]; then
		echo_date 删除SSR定时订阅任务...
		sed -i '/ssnodeupdate/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
}
#--------------------------------------nat part begin------------------------------------------------
load_tproxy() {
	MODULES="xt_comment"
	OS=$(uname -r)
	# load Kernel Modules
	echo_date 加载TPROXY模块，用于udp转发...
	checkmoduleisloaded() {
		if lsmod | grep $MODULE &>/dev/null; then return 0; else return 1; fi
	}

	if checkmoduleisloaded; then
		insmod $MODULES
	fi

	if checkmoduleisloaded; then
		echo "One or more modules are missing. Can't start."
		close_in_five
	fi
}

flush_nat() {
	echo_date 清除iptables规则和ipset...
	# flush rules and set if any
	nat_indexs=$(iptables -nvL PREROUTING -t nat | sed 1,2d | sed -n '/SHADOWSOCKS/=' | sort -r)
	for nat_index in $nat_indexs; do
		iptables -t nat -D PREROUTING $nat_index >/dev/null 2>&1
	done
	#iptables -t nat -D PREROUTING -p tcp -j SHADOWSOCKS >/dev/null 2>&1

	iptables -t nat -F SHADOWSOCKS >/dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS >/dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_EXT >/dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_GFW >/dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_GFW >/dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_CHN >/dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_CHN >/dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_GAM >/dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_GAM >/dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_GLO >/dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_GLO >/dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_HOM >/dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_HOM >/dev/null 2>&1
	iptables -t nat -F SHADOWSOCKS_NETFLIX >/dev/null 2>&1 && iptables -t nat -X SHADOWSOCKS_NETFLIX >/dev/null 2>&1

	mangle_indexs=$(iptables -nvL PREROUTING -t mangle | sed 1,2d | sed -n '/SHADOWSOCKS/=' | sort -r)
	for mangle_index in $mangle_indexs; do
		iptables -t mangle -D PREROUTING $mangle_index >/dev/null 2>&1
	done
	#iptables -t mangle -D PREROUTING -p udp -j SHADOWSOCKS >/dev/null 2>&1

	iptables -t mangle -F SHADOWSOCKS >/dev/null 2>&1 && iptables -t mangle -X SHADOWSOCKS >/dev/null 2>&1
	iptables -t mangle -F SHADOWSOCKS_GAM >/dev/null 2>&1 && iptables -t mangle -X SHADOWSOCKS_GAM >/dev/null 2>&1
	iptables -t nat -D OUTPUT -p tcp -m set --match-set router dst -j REDIRECT --to-ports 3333 >/dev/null 2>&1
	iptables -t nat -F OUTPUT >/dev/null 2>&1
	iptables -t nat -X SHADOWSOCKS_EXT >/dev/null 2>&1
	#iptables -t nat -D PREROUTING -p udp -s $(get_lan_cidr) --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
	chromecast_nu=$(iptables -t nat -L PREROUTING -v -n --line-numbers | grep "dpt:53" | awk '{print $1}')
	[ -n "$chromecast_nu" ] && iptables -t nat -D PREROUTING $chromecast_nu >/dev/null 2>&1
	iptables -t mangle -D QOSO0 -m mark --mark "$ip_prefix_hex" -j RETURN >/dev/null 2>&1
	# flush ipset
	ipset -F chnroute >/dev/null 2>&1 && ipset -X chnroute >/dev/null 2>&1
	ipset -F white_list >/dev/null 2>&1 && ipset -X white_list >/dev/null 2>&1
	ipset -F black_list >/dev/null 2>&1 && ipset -X black_list >/dev/null 2>&1
	ipset -F gfwlist >/dev/null 2>&1 && ipset -X gfwlist >/dev/null 2>&1
	ipset -F netflix >/dev/null 2>&1 && ipset -X netflix >/dev/null 2>&1
	ipset -F router >/dev/null 2>&1 && ipset -X router >/dev/null 2>&1
	#remove_redundant_rule
	ip_rule_exist=$(ip rule show | grep "lookup 310" | grep -c 310)
	if [ -n "$ip_rule_exist" ]; then
		#echo_date 清除重复的ip rule规则.
		until [ "$ip_rule_exist" == "0" ]; do
			IP_ARG=$(ip rule show | grep "lookup 310" | head -n 1 | cut -d " " -f3,4,5,6)
			ip rule del $IP_ARG
			ip_rule_exist=$(expr $ip_rule_exist - 1)
		done
	fi
	#remove_route_table
	#echo_date 删除ip route规则.
	ip route del local 0.0.0.0/0 dev lo table 310 >/dev/null 2>&1
}

# create ipset rules
create_ipset(){
	echo_date 创建ipset名单
	ipset -! create white_list nethash && ipset flush white_list
	ipset -! create black_list nethash && ipset flush black_list
	ipset -! create gfwlist nethash && ipset flush gfwlist
	ipset -! create router nethash && ipset flush router
	ipset -! create chnroute nethash && ipset flush chnroute
	ipset -! create netflix nethash && ipset flush netflix
	sed -e "s/^/add chnroute &/g" /jffs/softcenter/ss/rules/chnroute.txt | awk '{print $0} END{print "COMMIT"}' | ipset -R
	if [ "$ssconf_basic_netflix_enalbe" == "1" ]; then
		for ip in $(cat /jffs/softcenter/ss/rules/netflixip.list); do ipset -! add netflix $ip; done
	fi
	#for router
	ipset add router 8.8.8.8
}

add_white_black_ip() {
	# black ip/cidr
	if [ "$ssconf_basic_mode" != "6" ]; then
		ip_tg="149.154.0.0/16 91.108.4.0/22 91.108.56.0/24 109.239.140.0/24 67.198.55.0/24 8.8.8.8"
		for ip in $ip_tg; do
			ipset -! add black_list $ip >/dev/null 2>&1
		done
	fi

	if [ -n "$ssconf_wan_black_ip" ]; then
		ssconf_wan_black_ip=$(echo $ssconf_wan_black_ip | base64_decode | sed '/\#/d')
		echo_date 应用IP/CIDR黑名单
		for ip in $ssconf_wan_black_ip; do
			ipset -! add black_list $ip >/dev/null 2>&1
		done
	fi

	# white ip/cidr
	[ -n "$ssconf_basic_server_ip" ] && SERVER_IP="$ssconf_basic_server_ip" || SERVER_IP=""
	[ -n "$IFIP_DNS1" ] && ISP_DNS_a="$ISP_DNS1" || ISP_DNS_a=""
	[ -n "$IFIP_DNS2" ] && ISP_DNS_b="$ISP_DNS2" || ISP_DNS_a=""
	ip_lan="0.0.0.0/8 10.0.0.0/8 100.64.0.0/10 127.0.0.0/8 169.254.0.0/16 172.16.0.0/12 192.168.0.0/16 224.0.0.0/4 240.0.0.0/4 223.5.5.5 223.6.6.6 114.114.114.114 114.114.115.115 1.2.4.8 210.2.4.8 117.50.11.11 117.50.22.22 180.76.76.76 119.29.29.29 $ISP_DNS_a $ISP_DNS_b $SERVER_IP $(get_wan0_cidr)"
	for ip in $ip_lan; do
		ipset -! add white_list $ip >/dev/null 2>&1
	done

	if [ -n "$ssconf_wan_white_ip" ]; then
		ssconf_wan_white_ip=$(echo $ssconf_wan_white_ip | base64_decode | sed '/\#/d')
		echo_date 应用IP/CIDR白名单
		for ip in $ssconf_wan_white_ip; do
			ipset -! add white_list $ip >/dev/null 2>&1
		done
	fi
}

get_action_chain() {
	case "$1" in
	0)
		echo "RETURN"
		;;
	1)
		echo "SHADOWSOCKS_GFW"
		;;
	2)
		echo "SHADOWSOCKS_CHN"
		;;
	3)
		echo "SHADOWSOCKS_GAM"
		;;
	5)
		echo "SHADOWSOCKS_GLO"
		;;
	6)
		echo "SHADOWSOCKS_HOM"
		;;
	7)
		echo "SHADOWSOCKS_NETFLIX"
		;;
	esac
}

get_mode_name() {
	case "$1" in
	0)
		echo "不通过SS"
		;;
	1)
		echo "gfwlist模式"
		;;
	2)
		echo "大陆白名单模式"
		;;
	3)
		echo "游戏模式"
		;;
	5)
		echo "全局模式"
		;;
	6)
		echo "回国模式"
		;;
	esac
}

factor() {
	if [ -z "$1" ] || [ -z "$2" ]; then
		echo ""
	else
		echo "$2 $1"
	fi
}

get_jump_mode() {
	case "$1" in
	0)
		echo "j"
		;;
	*)
		echo "g"
		;;
	esac
}

lan_acess_control() {
	# lan access control
	acl_nu=$(dbus list ssconf_acl_mode_ | cut -d "=" -f 1 | cut -d "_" -f 4 | sort -n)
	if [ -n "$acl_nu" ]; then
		for acl in $acl_nu; do
			ipaddr=$(eval echo \$ssconf_acl_ip_$acl)
			ipaddr_hex=$(echo $ipaddr | awk -F "." '{printf ("0x%02x", $1)} {printf ("%02x", $2)} {printf ("%02x", $3)} {printf ("%02x\n", $4)}')
			ports=$(eval echo \$ssconf_acl_port_$acl)
			proxy_mode=$(eval echo \$ssconf_acl_mode_$acl)
			proxy_name=$(eval echo \$ssconf_acl_name_$acl)
			if [ "$ports" == "all" ]; then
				ports=""
				echo_date 加载ACL规则：【$ipaddr】【全部端口】模式为：$(get_mode_name $proxy_mode)
			else
				echo_date 加载ACL规则：【$ipaddr】【$ports】模式为：$(get_mode_name $proxy_mode)
			fi
			# 1 acl in SHADOWSOCKS for nat
			iptables -t nat -A SHADOWSOCKS $(factor $ipaddr "-s") -p tcp $(factor $ports "-m multiport --dport") -$(get_jump_mode $proxy_mode) $(get_action_chain $proxy_mode)
			# 2 acl in OUTPUT（used by koolproxy）
			iptables -t nat -A SHADOWSOCKS_EXT -p tcp $(factor $ports "-m multiport --dport") -m mark --mark "$ipaddr_hex" -$(get_jump_mode $proxy_mode) $(get_action_chain $proxy_mode)
			# 3 acl in SHADOWSOCKS for mangle
			if [ "$proxy_mode" == "3" ]; then
				iptables -t mangle -A SHADOWSOCKS $(factor $ipaddr "-s") -p udp $(factor $ports "-m multiport --dport") -$(get_jump_mode $proxy_mode) $(get_action_chain $proxy_mode)
			else
				[ "$mangle" == "1" ] && iptables -t mangle -A SHADOWSOCKS $(factor $ipaddr "-s") -p udp -j RETURN
			fi
		done

		if [ "$ssconf_acl_default_port" == "all" ]; then
			ssconf_acl_default_port=""
			[ -z "$ssconf_acl_default_mode" ] && dbus set ssconf_acl_default_mode="$ssconf_basic_mode" && ssconf_acl_default_mode="$ssconf_basic_mode"
			echo_date 加载ACL规则：【剩余主机】【全部端口】模式为：$(get_mode_name $ssconf_acl_default_mode)
		else
			echo_date 加载ACL规则：【剩余主机】【$ssconf_acl_default_port】模式为：$(get_mode_name $ssconf_acl_default_mode)
		fi
	else
		ssconf_acl_default_mode="$ssconf_basic_mode"
		if [ "$ssconf_acl_default_port" == "all" ]; then
			ssconf_acl_default_port=""
			echo_date 加载ACL规则：【全部主机】【全部端口】模式为：$(get_mode_name $ssconf_acl_default_mode)
		else
			echo_date 加载ACL规则：【全部主机】【$ssconf_acl_default_port】模式为：$(get_mode_name $ssconf_acl_default_mode)
		fi
	fi
	dbus remove ssconf_acl_ip
	dbus remove ssconf_acl_name
	dbus remove ssconf_acl_mode
	dbus remove ssconf_acl_port
}

apply_nat_rules() {
	#----------------------BASIC RULES---------------------
	echo_date 写入iptables规则到nat表中...
	# 创建SHADOWSOCKS nat rule
	iptables -t nat -N SHADOWSOCKS
	# 扩展
	iptables -t nat -N SHADOWSOCKS_EXT
	# IP/cidr/白域名 白名单控制（不走ss）
	iptables -t nat -A SHADOWSOCKS -p tcp -m set --match-set white_list dst -j RETURN
	iptables -t nat -A SHADOWSOCKS_EXT -p tcp -m set --match-set white_list dst -j RETURN
	#-----------------------FOR GLOABLE---------------------
	# 创建gfwlist模式nat rule
	iptables -t nat -N SHADOWSOCKS_GLO
	# IP黑名单控制-gfwlist（走ss）
	iptables -t nat -A SHADOWSOCKS_GLO -p tcp -j REDIRECT --to-ports 3333
	#-----------------------FOR GFWLIST---------------------
	# 创建gfwlist模式nat rule
	iptables -t nat -N SHADOWSOCKS_GFW
	# IP/CIDR/黑域名 黑名单控制（走ss）
	iptables -t nat -A SHADOWSOCKS_GFW -p tcp -m set --match-set black_list dst -j REDIRECT --to-ports 3333
	# IP黑名单控制-gfwlist（走ss）
	iptables -t nat -A SHADOWSOCKS_GFW -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-ports 3333
	[ "$ssconf_basic_netflix_enable" == "1" ] && iptables -t nat -A SHADOWSOCKS_GFW -p tcp -m set --match-set netflix dst -j REDIRECT --to-ports 4321
	#-----------------------FOR CHNMODE---------------------
	# 创建大陆白名单模式nat rule
	iptables -t nat -N SHADOWSOCKS_CHN
	# IP/CIDR/域名 黑名单控制（走ss）
	iptables -t nat -A SHADOWSOCKS_CHN -p tcp -m set --match-set black_list dst -j REDIRECT --to-ports 3333
	# cidr黑名单控制-chnroute（走ss）
	iptables -t nat -A SHADOWSOCKS_CHN -p tcp -m set ! --match-set chnroute dst -j REDIRECT --to-ports 3333
	[ "$ssconf_basic_netflix_enable" == "1" ] && iptables -t nat -A SHADOWSOCKS_CHN -p tcp -m set --match-set netflix dst -j REDIRECT --to-ports 4321
	#-----------------------FOR GAMEMODE---------------------
	# 创建游戏模式nat rule
	iptables -t nat -N SHADOWSOCKS_GAM
	# IP/CIDR/域名 黑名单控制（走ss）
	iptables -t nat -A SHADOWSOCKS_GAM -p tcp -m set --match-set black_list dst -j REDIRECT --to-ports 3333
	# cidr黑名单控制-chnroute（走ss）
	iptables -t nat -A SHADOWSOCKS_GAM -p tcp -m set ! --match-set chnroute dst -j REDIRECT --to-ports 3333
	[ "$ssconf_basic_netflix_enable" == "1" ] && iptables -t nat -A SHADOWSOCKS_GAM -p tcp -m set --match-set netflix dst -j REDIRECT --to-ports 4321
	#-----------------------FOR HOMEMODE---------------------
	# 创建回国模式nat rule
	iptables -t nat -N SHADOWSOCKS_HOM
	# IP/CIDR/域名 黑名单控制（走ss）
	iptables -t nat -A SHADOWSOCKS_HOM -p tcp -m set --match-set black_list dst -j REDIRECT --to-ports 3333
	# cidr黑名单控制-chnroute（走ss）
	iptables -t nat -A SHADOWSOCKS_HOM -p tcp -m set --match-set chnroute dst -j REDIRECT --to-ports 3333
	#iptables -t nat -N SHADOWSOCKS_NETFLIX
	#iptables -t nat -A SHADOWSOCKS_NETFLIX -p tcp -m set --match-set netflix dst -j REDIRECT --to-ports 4321
	[ "$mangle" == "1" ] && load_tproxy
	[ "$mangle" == "1" ] && ip rule add fwmark 0x07 table 310
	[ "$mangle" == "1" ] && ip route add local 0.0.0.0/0 dev lo table 310
	# 创建游戏模式udp rule
	[ "$mangle" == "1" ] && iptables -t mangle -N SHADOWSOCKS
	# IP/cidr/白域名 白名单控制（不走ss）
	[ "$mangle" == "1" ] && iptables -t mangle -A SHADOWSOCKS -p udp -m set --match-set white_list dst -j RETURN
	# 创建游戏模式udp rule
	[ "$mangle" == "1" ] && iptables -t mangle -N SHADOWSOCKS_GAM
	# IP/CIDR/域名 黑名单控制（走ss）
	[ "$mangle" == "1" ] && iptables -t mangle -A SHADOWSOCKS_GAM -p udp -m set --match-set black_list dst -j TPROXY --on-port 3333 --tproxy-mark 0x07
	# cidr黑名单控制-chnroute（走ss）
	[ "$mangle" == "1" ] && iptables -t mangle -A SHADOWSOCKS_GAM -p udp -m set ! --match-set chnroute dst -j TPROXY --on-port 3333 --tproxy-mark 0x07
	[ "$ssconf_basic_netflix_enable" == "1" ] && iptables -t mangle -N SHADOWSOCKS_NETFLIX
	[ "$ssconf_basic_netflix_enable" == "1" ] && iptables -t mangle -A SHADOWSOCKS_NETFLIX -j TPROXY --to-ports 4321 --tproxy-mark 0x07
	#-------------------------------------------------------
	# 局域网黑名单（不走ss）/局域网黑名单（走ss）
	lan_acess_control
	#-----------------------FOR ROUTER---------------------
	# router itself
	[ "$ssconf_basic_mode" != "6" ] && iptables -t nat -A OUTPUT -p tcp -m set --match-set router dst -j REDIRECT --to-ports 3333
	iptables -t nat -A OUTPUT -p tcp -m mark --mark "$ip_prefix_hex" -j SHADOWSOCKS_EXT

	# 把最后剩余流量重定向到相应模式的nat表中对应的主模式的链
	iptables -t nat -A SHADOWSOCKS -p tcp $(factor $ssconf_acl_default_port "-m multiport --dport") -j $(get_action_chain $ssconf_acl_default_mode)
	iptables -t nat -A SHADOWSOCKS_EXT -p tcp $(factor $ssconf_acl_default_port "-m multiport --dport") -j $(get_action_chain $ssconf_acl_default_mode)

	# 如果是主模式游戏模式，则把SHADOWSOCKS链中剩余udp流量转发给SHADOWSOCKS_GAM链
	# 如果主模式不是游戏模式，则不需要把SHADOWSOCKS链中剩余udp流量转发给SHADOWSOCKS_GAM，不然会造成其他模式主机的udp也走游戏模式
	###[ "$mangle" == "1" ] && ssconf_acl_default_mode=3
	[ "$ssconf_acl_default_mode" != "0" ] && [ "$ssconf_acl_default_mode" != "3" ] && ssconf_acl_default_mode=0
	[ "$ssconf_basic_mode" == "3" ] && iptables -t mangle -A SHADOWSOCKS -p udp -j $(get_action_chain $ssconf_acl_default_mode)
	[ "$ssconf_basic_netflix_enable" == "1" ] && iptables -t mangle -A SHADOWSOCKS -p udp -m set --match-set netflix dst -j SHADOWSOCKS_NETFLIX
	# 重定所有流量到 SHADOWSOCKS
	KP_NU=$(iptables -nvL PREROUTING -t nat | sed 1,2d | sed -n '/KOOLPROXY/=' | head -n1)
	[ "$KP_NU" == "" ] && KP_NU=0
	INSET_NU=$(expr "$KP_NU" + 1)
	iptables -t nat -I PREROUTING "$INSET_NU" -p tcp -j SHADOWSOCKS
	[ "$mangle" == "1" ] && iptables -t mangle -A PREROUTING -p udp -j SHADOWSOCKS
	# QOS开启的情况下
	QOSO=$(iptables -t mangle -S | grep -o QOSO | wc -l)
	RRULE=$(iptables -t mangle -S | grep "A QOSO" | head -n1 | grep RETURN)
	if [ "$QOSO" -gt "1" ] && [ -z "$RRULE" ]; then
		iptables -t mangle -I QOSO0 -m mark --mark "$ip_prefix_hex" -j RETURN
	fi
}

chromecast() {
	chromecast_nu=$(iptables -t nat -L PREROUTING -v -n --line-numbers | grep "dpt:53" | awk '{print $1}')
	if [ "$ssconf_basic_dns_hijack" == "1" ]; then
		if [ -z "$chromecast_nu" ]; then
			iptables -t nat -A PREROUTING -p udp -s $(get_lan_cidr) --dport 53 -j DNAT --to $lan_ipaddr >/dev/null 2>&1
			echo_date 开启DNS劫持功能功能，防止DNS污染...
		else
			echo_date DNS劫持规则已经添加，跳过~
		fi
	else
		echo_date DNS劫持功能未开启，建议开启！
	fi
}
# -----------------------------------nat part end--------------------------------------------------------

restart_dnsmasq(){
	if [ -f "/tmp/resolv.dnsmasq.bak" ];then
		#bug!关闭全局模式后且没有开启smartdns需要恢复
		if [ "$ssconf_basic_enable" == "0" ] || [ "$all_on" == "" -a "$ssconf_basic_mode" != "5" ];then
			rm -rf /tmp/resolv.dnsmasq
			mv /tmp/resolv.dnsmasq.bak /tmp/resolv.dnsmasq
		fi
	fi
	if [ "$ssconf_basic_enable" == "1" ];then
		echo "nameserver 127.0.0.1" > /etc/resolv.conf
	fi
	# Restart dnsmasq
	echo_date 重启dnsmasq服务...
	service restart_dnsmasq >/dev/null 2>&1
}

# write number into nvram with no commit
write_numbers(){
	nvram set update_ipset="$(cat /jffs/softcenter/ss/rules/version | sed -n 1p | sed 's/#/\n/g'| sed -n 1p)"
	nvram set update_chnroute="$(cat /jffs/softcenter/ss/rules/version | sed -n 2p | sed 's/#/\n/g'| sed -n 1p)"
	nvram set update_cdn="$(cat /jffs/softcenter/ss/rules/version | sed -n 3p | sed 's/#/\n/g'| sed -n 1p)"
	nvram set ipset_numbers=$(cat /jffs/softcenter/ss/rules/gfwlist.conf | grep -c ipset)
	nvram set chnroute_numbers=$(cat /jffs/softcenter/ss/rules/chnroute.txt | grep -c .)
	nvram set chnroute_ips=$(awk -F "/" '{sum += 2^(32-$2)};END {print sum}' /jffs/softcenter/ss/rules/chnroute.txt)
	nvram set cdn_numbers=$(cat /jffs/softcenter/ss/rules/cdn.txt | grep -c .)
}

set_sys() {
	# set_ulimit
	ulimit -n 16384
	echo 1 >/proc/sys/vm/overcommit_memory

}

remove_ssconf_reboot_job() {
	if [ -n "$(cru l | grep ssconf_reboot)" ]; then
		echo_date "【科学上网】：删除插件自动重启定时任务..."
		sed -i '/ssconf_reboot/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
}

set_ssconf_reboot_job() {
	if [[ "${ssconf_reboot_check}" == "0" ]]; then
		remove_ssconf_reboot_job
	elif [[	"${ssconf_reboot_check}" ==	"1"	]];	then
		echo_date 设置每天${ssconf_basic_time_hour}时${ssconf_basic_time_min}分重启插件...
		cru a ssconf_reboot	${ssconf_basic_time_min} ${ssconf_basic_time_hour}" * *	* /bin/sh /jffs/softcenter/ss/ssconfig.sh restart"
	elif [[	"${ssconf_reboot_check}" ==	"2"	]];	then
		echo_date 设置每周${ssconf_basic_week}的${ssconf_basic_time_hour}时${ssconf_basic_time_min}分重启插件...
		cru a ssconf_reboot	${ssconf_basic_time_min} ${ssconf_basic_time_hour}" * *	"${ssconf_basic_week}" /bin/sh /jffs/softcenter/ss/ssconfig.sh restart"
	elif [[	"${ssconf_reboot_check}" ==	"3"	]];	then
		echo_date 设置每月${ssconf_basic_day}日${ssconf_basic_time_hour}时${ssconf_basic_time_min}分重启插件...
		cru a ssconf_reboot	${ssconf_basic_time_min} ${ssconf_basic_time_hour} ${ssconf_basic_day}" * *	/bin/sh /jffs/softcenter/ss/ssconfig.sh restart"
	elif [[	"${ssconf_reboot_check}" ==	"4"	]];	then
		if [[ "${ssconf_basic_inter_pre}" == "1" ]]; then
			echo_date 设置每隔${ssconf_basic_inter_min}分钟重启插件...
			cru a ssconf_reboot	"*/"${ssconf_basic_inter_min}" * * * * /bin/sh /jffs/softcenter/ss/ssconfig.sh restart"
		elif [[	"${ssconf_basic_inter_pre}"	== "2" ]]; then
			echo_date 设置每隔${ssconf_basic_inter_hour}小时重启插件...
			cru a ssconf_reboot	"0 */"${ssconf_basic_inter_hour}" *	* * /bin/sh /jffs/softcenter/ss/ssconfig.sh restart"
		elif [[	"${ssconf_basic_inter_pre}"	== "3" ]]; then
			echo_date 设置每隔${ssconf_basic_inter_day}天${ssconf_basic_inter_hour}小时${ssconf_basic_time_min}分钟重启插件...
			cru a ssconf_reboot	${ssconf_basic_time_min} ${ssconf_basic_time_hour}" */"${ssconf_basic_inter_day} " * * /bin/sh /jffs/softcenter/ss/ssconfig.sh restart"
		fi
	elif [[	"${ssconf_reboot_check}" ==	"5"	]];	then
		check_custom_time=$(echo ssconf_basic_custom | base64_decode)
		echo_date 设置每天${check_custom_time}时的${ssconf_basic_time_min}分重启插件...
		cru a ssconf_reboot	${ssconf_basic_time_min} ${check_custom_time}" * * * /bin/sh /jffs/softcenter/ss/ssconfig.sh restart"
	fi
}

remove_ss_trigger_job() {
	if [ -n "$(cru l | grep ss_tri_check)" ]; then
		echo_date "删除插件触发重启定时任务..."
		sed -i '/ss_tri_check/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	else
		echo_date "插件触发重启定时任务已经删除..."
	fi
}

set_ss_trigger_job() {
	if [ "$ssconf_basic_tri_reboot_time" == "0" ]; then
		remove_ss_trigger_job
	else
		if [ "$ssconf_basic_tri_reboot_policy" == "1" ]; then
			echo_date "设置每隔$ssconf_basic_tri_reboot_time分钟检查服务器IP地址，如果IP发生变化，则重启科学上网插件..."
		else
			echo_date "设置每隔$ssconf_basic_tri_reboot_time分钟检查服务器IP地址，如果IP发生变化，则重启dnsmasq..."
		fi
		echo_date "科学上网插件触发重启功能的日志将显示再系统日志内。"
		cru d ss_tri_check >/dev/null 2>&1
		cru a ss_tri_check "*/$ssconf_basic_tri_reboot_time * * * * /jffs/softcenter/scripts/ssconf_reboot_job.sh check_ip"
	fi
}

load_nat() {
	nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers | grep -v PREROUTING | grep -v destination)
	i=120
	until [ -n "$nat_ready" ]; do
		i=$(($i - 1))
		if [ "$i" -lt 1 ]; then
			echo_date "错误：不能正确加载nat规则!"
			close_in_five
		fi
		sleep 1
		nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers | grep -v PREROUTING | grep -v destination)
	done
	echo_date "加载nat规则!"
	#create_ipset
	add_white_black_ip
	apply_nat_rules
	chromecast
}

ss_post_start() {
	# 在SS插件启动成功后触发脚本
	local i
	mkdir -p /jffs/softcenter/ss/postscripts && cd /jffs/softcenter/ss/postscripts
	for i in $(find ./ -name 'P*' | sort); do
		trap "" INT QUIT TSTP EXIT
		echo_date ------------- 【科学上网】 启动后触发脚本: $i -------------
		if [ -r "$i" ]; then
			$i start
		fi
		echo_date ----------------- 触发脚本: $i 运行完毕 -----------------
	done
}

ss_pre_stop() {
	# 在SS插件关闭前触发脚本
	local i
	mkdir -p /jffs/softcenter/ss/postscripts && cd /jffs/softcenter/ss/postscripts
	for i in $(find ./ -name 'P*' | sort -r); do
		trap "" INT QUIT TSTP EXIT
		echo_date ------------- 【科学上网】 关闭前触发脚本: $i ------------
		if [ -r "$i" ]; then
			$i stop
		fi
		echo_date ----------------- 触发脚本: $i 运行完毕 -----------------
	done
}

start_netflix() {
	if [ "$ssconf_basic_netflix_enable" == "1" ]; then

		case "$NODE_TYPE" in
		0|1)
			xray run -config $CONFIG_NETFLIX_FILE -f /var/run/ssr-netflix.pid >/dev/null 2>&1
			dns2socks 127.0.0.1:1088 8.8.8.8:53 127.0.0.1:5555 -q >/dev/null 2>&1 &
			;;
		2|3)
			create_v2ray_netflix
			xray run -config $CONFIG_NETFLIX_FILE >/dev/null 2>&1 &
			dns2socks 127.0.0.1:1088 8.8.8.8:53 127.0.0.1:5555 -q >/dev/null 2>&1 &
			;;
		esac
	fi
}

detect(){
	
	# 检测是否在lan设置中是否自定义过dns,如果有给干掉
	if [ -n "$(nvram get dhcp_dns1_x)" ]; then
		nvram unset dhcp_dns1_x
		nvram commit
	fi
	if [ -n "$(nvram get dhcp_dns2_x)" ]; then
		nvram unset dhcp_dns2_x
		nvram commit
	fi
}


httping_check() {
	[ "$ssconf_basic_check" != "1" ] && return
	echo "--------------------------------------------------------------------------------------"
	echo "检查国内可用性..."
	httping www.baidu.com -s -Z -r --ts -c 10 -i 0.5 -t 5 | tee /tmp/upload/china.txt
	if [ "$?" != "0" ]; then
		ehco 当前节点无法访问国内网络！
		#dbus set ssconf_basic_node=$
	fi
	echo "--------------------------------------------------------------------------------------"
	echo "检查国外可用性..."
	#httping www.google.com.tw -s -Z --proxy 127.0.0.1:23456 -5 -r --ts -c 5
	httping www.google.com.tw -s -Z -5 -r --ts -c 10 -i 0.5 -t 2
	if [ "$?" != "0" ]; then
		echo "当前节点无法访问国外网络！"
		echo "自动切换到下一个节点..."
		ssconf_basic_node=$(($ssconf_basic_node + 1))
		dbus set ssconf_basic_node=$ssconf_basic_node
		apply_ss
		return 1
		#start-stop-daemon -S -q -x /jffs/softcenter/ss/ssconfig.sh 2>&1
	fi
	echo "--------------------------------------------------------------------------------------"
}

stop_status() {
	kill -9 $(pidof ss_status_main.sh) >/dev/null 2>&1
	kill -9 $(pidof ss_status.sh) >/dev/null 2>&1
	killall curl >/dev/null 2>&1
	killall httping >/dev/null 2>&1
	rm -rf /tmp/upload/ss_status.txt
}

check_status() {
	if [ "$ssconf_failover_enable" == "1" ]; then
		echo "=========================================== start/restart ==========================================" >>/tmp/upload/ssf_status.txt
		echo "=========================================== start/restart ==========================================" >>/tmp/upload/ssc_status.txt
		start-stop-daemon -S -q -b -x /jffs/softcenter/scripts/ss_status_main.sh
	fi
}

disable_ss() {
	ss_pre_stop
	echo_date ======================= 梅林固件 - 【科学上网】 ========================
	echo_date
	echo_date ------------------------- 关闭【科学上网】 -----------------------------
	dbus remove ssconf_basic_server_ip
	stop_status
	kill_process
	remove_ss_trigger_job
	remove_ssconf_reboot_job
	restore_conf
	restart_dnsmasq
	flush_nat
	kill_cron_job
	echo_date ------------------------ 【科学上网】已关闭 ----------------------------
}

gen_conf(){
	local type
#	local udpnode=$(dbus get ssconf_basic_udpnode)
	NODE_JSON=$(eval dbus get ssconf_basic_json_$ssconf_basic_node | base64 -d)
	type=$(echo $NODE_JSON |jq -r .v2ray_protocol)
	case $type in
	shadowsocks)
		NODE_TYPE=0
		create_ss_json
		;;
	shadowsocksr)
		NODE_TYPE=1
		create_ss_json
		;;
	vmess|vless)
		NODE_TYPE=2
		create_v2ray_json
		;;
	trojan)
		NODE_TYPE=3
		create_v2ray_json
		;;
	hysteria)
		NODE_TYPE=4
		create_hysteria_json
		;;
	esac
}

start_shunt(){
	case $NODE_TYPE in
	0|1)
		start_v2ray
		start_kcp
		;;
	2|3)
		start_v2ray
		;;
	4)
		start_hysteria
		;;
	esac
	start_netflix
}

apply_ss() {
	ss_pre_stop
	# now stop first
	echo_date ======================= 梅林固件 - 【科学上网】 ========================
	echo_date
	echo_date ------------------------- 启动【科学上网】 -----------------------------
	stop_status
	kill_process
	remove_ss_trigger_job
	remove_ssconf_reboot_job
	restore_conf
	# restart dnsmasq when ss server is not ip or on router boot
	restart_dnsmasq
	flush_nat
	kill_cron_job
	#echo_date ------------------------ 【科学上网】已关闭 ----------------------------
	# pre-start
	# start
	#echo_date ------------------------- 启动 【科学上网】 ----------------------------
	detect
	set_sys
	resolv_server_ip
	create_ipset
	create_dnsmasq_conf
	gen_conf
	start_shunt
	start_dns
	#===load nat start===
	load_nat
	#===load nat end===
	restart_dnsmasq
	auto_start
	write_cron_job
	set_ssconf_reboot_job
	set_ss_trigger_job
	write_numbers
	# post-start
	ss_post_start
	#httping_check
	#[ "$?" == "1" ] && return 1
	check_status
	echo_date ------------------------ 【科学上网】 启动完毕 ------------------------
}

# =========================================================================

case $ACTION in
start)
	set_lock
	if [ "$ssconf_basic_enable" == "1" ]; then
		logger "[软件中心]: 启动科学上网插件！"
		apply_ss >>"$LOG_FILE"
	else
		logger "[软件中心]: 科学上网插件未开启，不启动！"
	fi
	unset_lock
	;;
stop)
	set_lock
	disable_ss
	echo_date
	echo_date 你已经成功关闭科学上网服务~
	echo_date See you again!
	echo_date
	echo_date ======================= 梅林固件 - 【科学上网】 ========================
	unset_lock
	;;
restart)
	set_lock
	apply_ss
	echo_date
	echo_date "Across the Great Wall we can reach every corner in the world!"
	echo_date
	echo_date ======================= 梅林固件 - 【科学上网】 ========================
	unset_lock
	;;
flush_nat)
	set_lock
	flush_nat
	unset_lock
	;;
start_nat)
	set_lock
	[ "$ssconf_basic_enable" == "1" ] && apply_ss
	unset_lock
	;;
esac

