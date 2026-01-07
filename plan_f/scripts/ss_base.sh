#!/bin/sh

source /jffs/softcenter/scripts/base.sh
source helper.sh
eval `dbus export ssconf`
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
ssconf_basic_mode=$(dbus get ssconf_basic_mode_$ssconf_basic_node)
[ -n "$mode" ] || mode=1
gfw_on=`dbus list ssconf_acl_mode_|cut -d "=" -f 2 | grep -E "1"`
chn_on=`dbus list ssconf_acl_mode_|cut -d "=" -f 2 | grep -E "2|3|4"`
all_on=`dbus list ssconf_acl_mode_|cut -d "=" -f 2 | grep -E "5"`
game_on=`dbus list ssconf_acl_mode_|cut -d "=" -f 2 | grep 3`
[ -n "$game_on" ] || [ "$ssconf_basic_mode" == "3" ] && mangle=1

__valid_ip() {
	# 验证是否为ipv4或者ipv6地址，是则正确返回，不是返回空值
	local format_4=$(echo "$1" | grep -Eo "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
	local format_6=$(echo "$1" | grep -Eo '^[[:space:]]*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?[[:space:]]*')
	if [ -n "$format_4" ] && [ -z "$format_6" ]; then
		echo "$format_4"
		return 0
	elif [ -z "$format_4" ] && [ -n "$format_6" ]; then
		echo "$format_6"
		return 0
	else
		echo ""
		return 1
	fi
}

__get_server_resolver() {
	local value_1="$ssconf_basic_server_resolver"
	local value_2="$ssconf_basic_server_resolver_user"
	local res
	if [ "$value_1" == "1" ]; then
		if [ -n "$IFIP_DNS1" ]; then
			res="$ISP_DNS1"
		else
			res="114.114.114.114"
		fi
	fi
	[ "$value_1" == "2" ] && res="223.5.5.5"
	[ "$value_1" == "3" ] && res="223.6.6.6"
	[ "$value_1" == "4" ] && res="114.114.114.114"
	[ "$value_1" == "5" ] && res="114.114.115.115"
	[ "$value_1" == "6" ] && res="1.2.4.8"
	[ "$value_1" == "7" ] && res="210.2.4.8"
	[ "$value_1" == "8" ] && res="117.50.11.11"
	[ "$value_1" == "9" ] && res="117.50.22.22"
	[ "$value_1" == "10" ] && res="180.76.76.76"
	[ "$value_1" == "11" ] && res="119.29.29.29"
	[ "$value_1" == "13" ] && res="8.8.8.8"
	[ "$value_1" == "14" ] && res="8.8.4.4"
	[ "$value_1" == "15" ] && res="9.9.9.9"
	if [ "$value_1" == "12" ]; then
		if [ -n "$value_2" ]; then
			res=$(__valid_ip "$value_2")
			[ -z "$res" ] && res="114.114.114.114"
		else
			res="114.114.114.114"
		fi
	fi
	echo $res
}

__get_server_resolver_port() {
	local port
	if [ "$ssconf_basic_server_resolver" == "12" ]; then
		if [ -n "$ssconf_basic_server_resolver_user" ]; then
			port=$(echo "$ssconf_basic_server_resolver_user" | awk -F"#|:" '{print $2}')
			[ -z "$port" ] && port="53"
		else
			port="53"
		fi
	else
		port="53"
	fi
	echo $port
}

__resolve_ip() {
	local domain1=$(echo "$1" | grep -E "^https://|^http://|/")
	local domain2=$(echo "$1" | grep -E "\.|\:")
	if [ -n "$domain1" ] || [ -z "$domain2" ]; then
		# not ip, not domain
		echo ""
		return 2
	else
		# domain format
		SERVER_IP=$(resolveip "$1" $(__get_server_resolver):$(__get_server_resolver_port) 2>/dev/null)
		SERVER_IP=$(__valid_ip $SERVER_IP)
		if [ -n "$SERVER_IP" ]; then
			# success resolved
			echo "$SERVER_IP"
			return 0
		else
			# resolve failed
			echo ""
			return 1
		fi
	fi
}
