#!/bin/bash
CurrentDate=$(TZ=CST-8 date +%Y-%m-%d\ %H:%M)
CURR_PATH="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"
RULE_PATH=${CURR_PATH%\/*}
RULE_FILE=${RULE_PATH}/rules.json.js
OBJECT_1='{}'

prepare(){
	if ! type -p sponge &>/dev/null; then
	    printf '%s\n' "error: sponge is not installed, exiting..."
	    exit 1
	fi
	cd ${CURR_PATH}
}

generate_china_banned() {
cat $1 | base64 -d > gfwlist_tmp.txt
sed -i '/^@@|/d' gfwlist_tmp.txt
cat gfwlist_tmp.txt gfwlist_tmp.conf | sort -u |
sed 's#!.\+##; s#|##g; s#@##g; s#http:\/\/##; s#https:\/\/##;' |
sed '/\*/d; /apple\.com/d; /sina\.cn/d; /sina\.com\.cn/d; /baidu\.com/d; /byr\.cn/d; /jlike\.com/d; /weibo\.com/d; /zhongsou\.com/d; /youdao\.com/d; /sogou\.com/d; /so\.com/d; /soso\.com/d; /aliyun\.com/d; /taobao\.com/d; /jd\.com/d; /qq\.com/d; /windowsupdate/d' |
sed '/^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+$/d' |
grep '^[0-9a-zA-Z\.-]\+$' | grep '\.' | sed 's#^\.\+##' | sort -u |
awk 'BEGIN { prev = "________"; } {
cur = $0;
if (index(cur, prev) == 1 && substr(cur, 1 + length(prev) ,1) == ".") {
} else {
print cur;
prev = cur;
}
}' | sort -u
rm gfwlist_tmp.txt
}

get_gfwlist(){
	# get gfwlist for shadowsocks ipset mode
	curl https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt > gfwlist_download.conf
	if [ ! -f "gfwlist_download.conf" ]; then
		echo "gfwlist download faild!"
		exit 1
	fi
	echo "dmhy.org" >> gfwlist_tmp.conf
	echo "gab.com" >> gfwlist_tmp.conf
	echo "safechat.com" >> gfwlist_tmp.conf
	echo "clubhouseapi.com" >> gfwlist_tmp.conf
	echo "api.mega.co.nz" >> gfwlist_tmp.conf
	echo "github.com" >> gfwlist_tmp.conf
	echo "gettr.com" >> gfwlist_tmp.conf
	echo "google.com.hk" >> gfwlist_tmp.conf
	echo "coinbase.com" >> gfwlist_tmp.conf
	echo "truthsocial.com" >> gfwlist_tmp.conf
	echo "openai.com" >> gfwlist_tmp.conf
	echo "ai.com" >> gfwlist_tmp.conf
	echo "linksysinfo.org" >> gfwlist_tmp.conf
	echo "nxboom.com" >> gfwlist_tmp.conf
	#tiktok
	echo "bytedapm.com" >> gfwlist_tmp.conf
	echo "bytegecko-i18n.com" >> gfwlist_tmp.conf
	echo "bytegecko.com" >> gfwlist_tmp.conf
	echo "byteoversea.com" >> gfwlist_tmp.conf
	echo "capcut.com" >> gfwlist_tmp.conf
	echo "ibytedtos" >> gfwlist_tmp.conf
	echo "ibyteimg.com" >> gfwlist_tmp.conf
	echo "ipstatp.com" >> gfwlist_tmp.conf
	echo "isnssdk.com" >> gfwlist_tmp.conf
	echo "muscdn.com" >> gfwlist_tmp.conf
	echo "musical.ly" >> gfwlist_tmp.conf
	echo "sgpstatp.com" >> gfwlist_tmp.conf
	echo "snssdk.com" >> gfwlist_tmp.conf
	echo "tik-tokapi.com" >> gfwlist_tmp.conf
	echo "tiktok.com" >> gfwlist_tmp.conf
	echo "tiktokcdn-us.com" >> gfwlist_tmp.conf
	echo "tiktokcdn.com" >> gfwlist_tmp.conf
	echo "tiktokd.net" >> gfwlist_tmp.conf
	echo "tiktokd.org" >> gfwlist_tmp.conf
	echo "tiktokmusic.app" >> gfwlist_tmp.conf
	echo "tiktokv.com" >> gfwlist_tmp.conf
	echo "p16-tiktokcdn-com.akamaized.net" >> gfwlist_tmp.conf
	echo "lf16-pkgcdn.pitaya-clientai.com" >> gfwlist_tmp.conf
	echo "lf16-effectcdn.byteeffecttos-g.com" >> gfwlist_tmp.conf
	generate_china_banned gfwlist_download.conf > gfwlist_download_tmp.conf

	sed '/.*/s/.*/server=\/&\/127.0.0.1#7913\nipset=\/&\/gfwlist/' gfwlist_download_tmp.conf > gfwlist1.conf


	local md5sum1=$(md5sum ${CURR_PATH}/gfwlist1.conf | awk '{print $1}')
	local md5sum2=$(md5sum ${RULE_PATH}/gfwlist.conf | awk '{print $1}')
	echo "---------------------------------"
	if [ "$md5sum1"x = "$md5sum2"x ]; then
		echo "gfwlist same md5!"
		return
	fi
	echo "update gfwlist!"
	mv -f ${CURR_PATH}/gfwlist1.conf ${RULE_PATH}/gfwlist.conf
	local CURR_DATE=$(TZ=CST-8 date +%Y-%m-%d\ %H:%M)
	local MD5_VALUE=${md5sum1}
	local LINE_COUN=$(cat ${RULE_PATH}/gfwlist.conf|grep -E "^server="|wc -l)
	jq --arg variable "${CURR_DATE}" '.gfwlist.date = $variable' ${RULE_FILE} | sponge ${RULE_FILE}
	jq --arg variable "${MD5_VALUE}" '.gfwlist.md5 = $variable' ${RULE_FILE} | sponge ${RULE_FILE}
	jq --arg variable "${LINE_COUN}" '.gfwlist.count = $variable' ${RULE_FILE} | sponge ${RULE_FILE}
}
get_chnroute(){
# ======================================
# get chnroute for shadowsocks chn and game mode
	wget -4 https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/ipip_country/ipip_country_cn.netset -qO ${CURR_PATH}/chnroute_tmp.txt
	if [ ! -f "chnroute_tmp.txt" ]; then
		echo "chnroute download faild!"
		exit 1
	fi
	sed -i '/^#/d' chnroute_tmp.txt
	local md5sum1=$(md5sum ${CURR_PATH}/chnroute_tmp.txt | awk '{print $1}')
	local md5sum2=$(md5sum ${RULE_PATH}/chnroute.txt 2>/dev/null | awk '{print $1}')
	echo "---------------------------------"
	if [ "$md5sum1"x = "$md5sum2"x ]; then
		echo "chnroute same md5!"
		return
	fi
	local SOURCE="ipip"
	local URL="https://github.com/firehol/blocklist-ipsets/blob/master/ipip_country/ipip_country_cn.netset"
	local CURR_DATE=$(TZ=CST-8 date +%Y-%m-%d\ %H:%M)
	local MD5_VALUE=${md5sum1}
	local LINE_COUN=$(cat ${CURR_PATH}/chnroute_tmp.txt | wc -l)
	local IP_COUNT=$(awk -F "/" '{sum += 2^(32-$2)-2};END {print sum}' ${CURR_PATH}/chnroute_tmp.txt)
	jq --arg variable "${SOURCE}" '.chnroute.source = $variable' ${RULE_FILE} | sponge ${RULE_FILE}
	jq --arg variable "${URL}" '.chnroute.url = $variable' ${RULE_FILE} | sponge ${RULE_FILE}
	jq --arg variable "${CURR_DATE}" '.chnroute.date = $variable' ${RULE_FILE} | sponge ${RULE_FILE}
	jq --arg variable "${MD5_VALUE}" '.chnroute.md5 = $variable' ${RULE_FILE} | sponge ${RULE_FILE}
	jq --arg variable "${LINE_COUN}" '.chnroute.count = $variable' ${RULE_FILE} | sponge ${RULE_FILE}
	jq --arg variable "${IP_COUNT}" '.chnroute.count_ip = $variable' ${RULE_FILE} | sponge ${RULE_FILE}
	echo "update chnroute from ${SOURCE}, total ${LINE_COUN} subnets, ${IP_COUNT} unique IPs !"
	mv -f ${CURR_PATH}/chnroute_tmp.txt ${RULE_PATH}/chnroute.txt
}

get_cdn(){
# ======================================
# get cdn list for shadowsocks chn and game mode

	wget -4 https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf -qO ${CURR_PATH}/accelerated-domains.china.conf
	wget -4 https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/apple.china.conf -qO ${CURR_PATH}/apple.china.conf
	wget -4 https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/google.china.conf -qO ${CURR_PATH}/google.china.conf
	if [ ! -f "accelerated-domains.china.conf" -o ! -f "apple.china.conf" -o ! -f "google.china.conf" ]; then
		echo "cdn download faild!"
		exit 1
	fi
	cat accelerated-domains.china.conf apple.china.conf google.china.conf | sed '/^#/d' | sed "s/server=\/\.//g" | sed "s/server=\///g" | sed -r "s/\/\S{1,30}//g" | sed -r "s/\/\S{1,30}//g" >cdn_download.txt
	cat cdn_download.txt | sort -u >cdn1.txt

	local md5sum1=$(md5sum cdn1.txt | sed 's/ /\n/g' | sed -n 1p)
	local md5sum2=$(md5sum ../cdn.txt | sed 's/ /\n/g' | sed -n 1p)
	echo "---------------------------------"
	if [ "$md5sum1"x = "$md5sum2"x ]; then
		echo "cdn list same md5!"
		return
	fi
	echo "update cdn!"
	mv -f ${CURR_PATH}/cdn1.txt ${RULE_PATH}/cdn.txt
	local CURR_DATE=$(TZ=CST-8 date +%Y-%m-%d\ %H:%M)
	local MD5_VALUE=${md5sum1}
	local LINE_COUN=$(cat ${RULE_PATH}/cdn.txt | wc -l)
	jq --arg variable "${CURR_DATE}" '.cdn_china.date = $variable' ${RULE_FILE} | sponge ${RULE_FILE}
	jq --arg variable "${MD5_VALUE}" '.cdn_china.md5 = $variable' ${RULE_FILE} | sponge ${RULE_FILE}
	jq --arg variable "${LINE_COUN}" '.cdn_china.count = $variable' ${RULE_FILE} | sponge ${RULE_FILE}
}
#curl https://cdn.jsdelivr.net/gh/QiuSimons/Netflix_IP/getflix.txt > netflix_download.txt
# ======================================
finish(){
	rm google.china.conf
	rm apple.china.conf
	rm gfwlist_download.conf gfwlist_download_tmp.conf gfwlist_tmp.conf
	rm accelerated-domains.china.conf cdn_download.txt
}

get_rules(){
	prepare
	get_gfwlist
	get_chnroute
	get_cdn
	finish
}

get_rules
