#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval $(dbus export ssconf_basic_)
mkdir -p /tmp/upload
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'

softcenter_arch=`dbus get softcenter_arch`
ARCH_SUFFIX=$softcenter_arch
if [ "$ARCH_SUFFIX" == "armv7l" ]; then
	ARCH_SUFFIX="arm"
elif [ "$ARCH_SUFFIX" == "aarch64" ]; then
	ARCH_SUFFIX="arm64"
fi
main_url="https://raw.githubusercontent.com/zusterben/plan_f/master/bin"
PLATFORM=$(cat /jffs/softcenter/webs/Module_helloworld.asp | tr -d '\r' | grep -Eo "PKG_ARCH=.+"|awk -F "=" '{print $2}'|sed 's/"//g')
PKGTYPE=$(cat /jffs/softcenter/webs/Module_helloworld.asp | tr -d '\r' | grep -Eo "PKG_TYPE=.+"|awk -F "=" '{print $2}'|sed 's/"//g'|sed 's/;//g')
MD5NAME=md5_${PLATFORM}_${PKGTYPE}
PACKAGE=helloworld_${PLATFORM}_${PKGTYPE}
VERSION=version.json.js

run(){
	env -i PATH=${PATH} "$@"
}

install_ss(){
	echo_date 开始解压压缩包...
	tar -zxf helloworld.tar.gz
	chmod a+x /tmp/helloworld/install.sh
	echo_date 开始安装更新文件...
	sh /tmp/helloworld/install.sh
	rm -rf /tmp/helloworld*
}

update_ss(){
	local version_online md5_online size_download md5_download
	local hsts=""
	if [ "$(wget --help|grep hsts)" != "" ];then
		hsts="--no-hsts"
	fi
	echo_date "更新过程中请不要刷新本页面或者关闭路由等，不然可能导致问题！"
	echo_date "开启SS检查更新：使用主服务器：github"
	echo_date "检测主服务器在线版本号..."
	echo_date "地址：${main_url}/${VERSION}"
	curl -4sk --connect-timeout 10 ${main_url}/${VERSION} >/tmp/version.json.js
	if [ "$?" != "0" ];then
		echo_date "没有检测到主服务器在线版本号，访问github服务器可能有点问题！"
		echo "XU6J03M6"
		exit
	fi
	run jq --tab . /tmp/version.json.js >/dev/null 2>&1
	if [ "$?" != "0" ];then
		echo_date "在线版本号获取错误！请检测你的网络！"
		echo "XU6J03M6"
		exit
	fi
	version_online=$(cat /tmp/version.json.js | run jq -r '.version')
	echo_date "检测到主服务器在线版本号：${version_online}"
	dbus set ssconf_basic_version_web="${version_online}"
	if [ "${ssconf_basic_version_local}" != "${version_online}" ];then
		echo_date "主服务器在线版本号：${version_online} 和本地版本号：${ssconf_basic_version_local} 不同！"
		cd /tmp
		md5_online=$(cat /tmp/version.json.js | run jq -r .$MD5NAME)
		echo_date "开启下载进程，从主服务器上下载更新包..."
		echo_date "下载链接：${main_url}/${PLATFORM}/${PACKAGE}.tar.gz"
		wget -4 --no-check-certificate --timeout=5 $hsts ${main_url}/${PLATFORM}/${PACKAGE}.tar.gz
		if [ "$?" != "0" ];then
			echo_date "下载失败！请检查你的网络！"
			echo "XU6J03M6"
			exit
		fi
		echo_date "${PACKAGE}.tar.gz 下载成功！"
		mv ${PACKAGE}.tar.gz helloworld.tar.gz
		size_download=$(ls -lh /tmp/helloworld.tar.gz |awk '{print $5}')
		md5_download=$(md5sum /tmp/helloworld.tar.gz | sed 's/ /\n/g'| sed -n 1p)
		echo_date "安装包大小：${size_download}"
		echo_date "安装包md5校验值：${md5_download}"
		echo_date "安装包在线md5：${md5_online}"
		if [ "${md5_download}" != "${md5_online}" ]; then
			echo_date "更新包md5校验不一致！估计是下载的时候出了什么状况，请等待一会儿再试..."
			rm -rf /tmp/helloworld* >/dev/null 2>&1
		else
			echo_date "更新包md5校验一致！ 开始安装！..."
			install_ss
		fi
	else
		echo_date "主服务器在线版本号：${version_online} 和本地版本号：${ssconf_basic_version_local} 相同！"
		echo_date "退出插件更新!"
	fi
}


case $2 in
update)
	echo "" > /tmp/upload/ss_log.txt
	http_response "$1"
	update_ss >> /tmp/upload/ss_log.txt 2>&1
	echo XU6J03M6 >> /tmp/upload/ss_log.txt
	;;
esac

