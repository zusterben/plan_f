#!/bin/sh

MODULE=helloworld
VERSION=0.9.8
TITLE="helloworld"
DESCRIPTION="helloworld"
HOME_URL=Module_helloworld.asp
CURR_PATH="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

cp_rules(){
	cp -rf ./rules/gfwlist.conf plan_f/ss/rules/
	cp -rf ./rules/chnroute.txt plan_f/ss/rules/
	cp -rf ./rules/cdn.txt plan_f/ss/rules/
	cp -rf ./rules/rules.json.js plan_f/ss/rules/rules.json.js
}

gen_folder(){
	local platform=$1
	local pkgtype=$2
	local release_type=$3
	cd ${CURR_PATH}
	if [ "$VERSION" = "" ]; then
		echo "version not found"
		exit 3
	fi
	rm -rf helloworld
	cp -rf plan_f helloworld
	mkdir -p helloworld/bin
	rm -rf  helloworld/bin/*
	cp -rf ./bin_arch/$platform/* helloworld/bin/
	echo $VERSION > helloworld/ss/version
	echo $platform > helloworld/.arch
	if [ "${pkgtype}" == "lite" ];then
		sed -i 's/PKG_TYPE=full/PKG_TYPE=lite/g' helloworld/install.sh
		sed -i 's/var PKG_TYPE=\"full\"/var PKG_TYPE=\"lite\"/g' helloworld/webs/Module_helloworld.asp
		sed -i '/helloworld-full/d' helloworld/webs/Module_helloworld.asp
		sed -i '/helloworld-full/d' helloworld/res/ss-menu.js
		sed -i '/hysteria/d' helloworld/res/ss-menu.js
		sed -i 's/六种客户端/五种客户端/g' helloworld/webs/Module_helloworld.asp
		rm -rf helloworld/bin/hysteria
		rm -rf helloworld/bin/ipt2socks
		rm -rf helloworld/bin/tuic-client
		rm -rf helloworld/bin/websocketd
	fi
	sed -i 's/PKG_NAME=\"helloworld_arm_full\"/PKG_NAME=\"helloworld_'${platform}'_'${pkgtype}'\"/g' helloworld/install.sh
	sed -i 's/var PKG_ARCH=\"unknown\"/var PKG_ARCH=\"'${platform}'\"/g' helloworld/webs/Module_helloworld.asp
	sed -i 's/[ \t]*<!--helloworld-full-->//g' helloworld/webs/Module_helloworld.asp
	sed -i 's/[ \t]*<!--helloworld-full-->//g' helloworld/res/ss-menu.js
}

build_pkg() {
	local platform=$1
	local pkgtype=$2
	local release_type=$3
	# different platform
	if [ ${release_type} == "release" ];then
		echo "打包：helloworld_${platform}_${pkgtype}.tar.gz"
		tar -zcvf ${CURR_PATH}/helloworld_${platform}_${pkgtype}.tar.gz helloworld >/dev/null
		md5value=`md5sum helloworld_${platform}_${pkgtype}.tar.gz|tr " " "\n"|sed -n 1p`
		cat >>${CURR_PATH}/bin/version_tmp.json.js <<-EOF
			,"md5_${platform}_${pkgtype}":"${md5value}"
		EOF
		mkdir -p ./bin/$platform
		cp -rf helloworld_${platform}_${pkgtype}.tar.gz ./bin/$1/helloworld_${platform}_${pkgtype}.tar.gz
	elif [ ${release_type} == "debug" ];then
		echo "打包：helloworld_${platform}_${pkgtype}_${release_type}.tar.gz"
		tar -zcf ${CURR_PATH}/helloworld_${platform}_${pkgtype}_${release_type}.tar.gz helloworld >/dev/null
	fi
}

do_backup(){
	if [ "${CURR_PATH}/../history_package" ];then
		local platform=$1
		local pkgtype=$2
		local HISTORY_DIR="${CURR_PATH}/../history_package/$platform"
		mkdir -p $HISTORY_DIR
		# backup latested package after pack
		local backup_version=${VERSION}
		local backup_tar_md5=${md5value}
		echo "备份：helloworld_${platform}_${pkgtype}_${backup_version}.tar.gz"
			cp ${CURR_PATH}/helloworld_${platform}_${pkgtype}.tar.gz ${HISTORY_DIR}/helloworld_${platform}_${pkgtype}_${backup_version}.tar.gz
			sed -i "/helloworld_${platform}_${pkgtype}_${backup_version}/d" ${HISTORY_DIR}/md5sum.txt
			if [ ! -f ${HISTORY_DIR}/md5sum.txt ];then
				touch ${HISTORY_DIR}/md5sum.txt
			fi
			echo ${backup_tar_md5} helloworld_${platform}_${pkgtype}_${backup_version}.tar.gz >> ${HISTORY_DIR}/md5sum.txt
	fi
}

pack(){
	gen_folder $1 $2 $3
	build_pkg $1 $2 $3
	if [ "$3" == "release" ];then
		do_backup  $1 $2
	fi
	rm -rf ${CURR_PATH}/helloworld
	rm -rf ${CURR_PATH}/helloworld_*.tar.gz
}

papare(){
	rm -f ${CURR_PATH}/bin/*/*
	cp_rules
	cat >${CURR_PATH}/bin/version_tmp.json.js <<-EOF
	{
	"name":"helloworld"
	,"version":"${VERSION}"
	EOF
}

finish(){
	echo "}" >>${CURR_PATH}/bin/version_tmp.json.js
	cat ${CURR_PATH}/bin/version_tmp.json.js | jq '.' >${CURR_PATH}/bin/version.json.js
	rm -rf ${CURR_PATH}/bin/version_tmp.json.js
}

build(){
	papare
	# --- for release ---
	pack arm full release
	pack arm lite release
	pack armng full release
	pack armng lite release
	pack arm64 full release
	pack arm64 lite release
	#pack mips full release
	pack mips lite release
	#pack mipsle full release
	pack mipsle lite release
	finish
}

build
