#!/bin/sh

MODULE=helloworld
VERSION=0.8.3
TITLE="ShadowSocksR lite"
DESCRIPTION="ShadowSocksR lite"
HOME_URL=Module_helloworld.asp
arch_list="mips arm armng arm64 mipsle"

cp_rules(){
	cp -rf ./rules/gfwlist.conf helloworld/ss/rules/
	cp -rf ./rules/chnroute.txt helloworld/ss/rules/
	cp -rf ./rules/cdn.txt helloworld/ss/rules/
	cp -rf ./rules/version1 helloworld/ss/rules/version
}

do_build() {
	if [ "$VERSION" = "" ]; then
		echo "version not found"
		exit 3
	fi
	
	rm -f ${MODULE}.tar.gz
	rm -f $MODULE/.DS_Store
	rm -f $MODULE/*/.DS_Store
	rm -rf $MODULE/bin/*
	cp -rf ./bin_arch/$1/* $MODULE/bin/
	echo $VERSION > helloworld/ss/version
	echo $1 > helloworld/.arch
	tar -zcvf ${MODULE}.tar.gz $MODULE
	cat > $MODULE/version <<-EOF
	$VERSION
	EOF
	md5value=`md5sum ${MODULE}.tar.gz|tr " " "\n"|sed -n 1p`
	cat > ./version <<-EOF
	$VERSION
	$md5value
	EOF
	cat version
	
	DATE=`date +%Y-%m-%d_%H:%M:%S`
	cat > ./config.json.js <<-EOF
	{
	"build_date":"$DATE",
	"description":"$DESCRIPTION",
	"home_url":"$HOME_URL",
	"md5":"$md5value",
	"name":"$MODULE",
	"arch":"$1",
	"tar_url": "https://raw.githubusercontent.com/zusterben/plan_f/master/bin/$1/helloworld.tar.gz", 
	"title":"$TITLE",
	"version":"$VERSION"
	}
	EOF
	mkdir -p ./bin/$1
	cp -rf version ./bin/$1/version
	cp -rf config.json.js ./bin/$1/config.json.js
	cp -rf helloworld.tar.gz ./bin/$1/helloworld.tar.gz
}

do_backup(){
	mkdir -p ./history_package/$1
	HISTORY_DIR="./history_package/$1"
	# backup latested package after pack
	backup_version=`cat version | sed -n 1p`
	backup_tar_md5=`cat version | sed -n 2p`
	echo backup VERSION $backup_version
	cp ${MODULE}.tar.gz $HISTORY_DIR/${MODULE}_$backup_version.tar.gz
	sed -i "/$backup_version/d" "$HISTORY_DIR"/md5sum.txt
	echo $backup_tar_md5 ${MODULE}_$backup_version.tar.gz >> "$HISTORY_DIR"/md5sum.txt
}

cp_rules
for arch in $arch_list
do
do_build $arch
do_backup $arch
done
rm version config.json.js helloworld.tar.gz
rm -rf $MODULE/bin/*
rm -rf helloworld/.arch

