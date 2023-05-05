#!/bin/bash

UBOOT_BRANCH="beaglev-v2020.01-1.1.2"
LINUX_BRANCH="beaglev-v5.10.113-1.1.2"

if [ ! -f ./mirror/Xuantie-900-gcc-linux-5.10.4-glibc-x86_64-V2.6.1-20220906.tar.gz ] ; then
	###FIXME, move to public when released...
	echo "wget -c --directory-prefix=./mirror/ https://occ-oss-prod.oss-cn-hangzhou.aliyuncs.com/resource//1663142514282/Xuantie-900-gcc-linux-5.10.4-glibc-x86_64-V2.6.1-20220906.tar.gz"
	wget -c --directory-prefix=./mirror/ https://occ-oss-prod.oss-cn-hangzhou.aliyuncs.com/resource//1663142514282/Xuantie-900-gcc-linux-5.10.4-glibc-x86_64-V2.6.1-20220906.tar.gz
fi

if [ ! -f ./riscv-toolchain/bin/riscv64-unknown-linux-gnu-gcc-10.2.0 ] ; then
	echo "tar xf ./mirror/Xuantie-900-gcc-linux-5.10.4-glibc-x86_64-V2.6.1-20220906.tar.gz --strip-components=1 -C ./riscv-toolchain/"
	tar xf ./mirror/Xuantie-900-gcc-linux-5.10.4-glibc-x86_64-V2.6.1-20220906.tar.gz --strip-components=1 -C ./riscv-toolchain/
fi

if [ -f ./.gitlab-runner ] ; then
	echo "git clone --reference-if-able /mnt/yocto-cache/git/opensbi/ git@git.beagleboard.org:beaglev-ahead/opensbi.git --depth=1"
	git clone --reference-if-able /mnt/yocto-cache/git/opensbi/ git@git.beagleboard.org:beaglev-ahead/opensbi.git --depth=1
else
	if [ ! -d ./opensbi ] ; then
		echo "Log opensbi: [git clone git@git.beagleboard.org:beaglev-ahead/opensbi.git --depth=10]"
		git clone git@git.beagleboard.org:beaglev-ahead/opensbi.git --depth=10
	else
		cd ./opensbi/
		echo "Log opensbi: [git pull --rebase]"
		git pull --rebase
		cd -
	fi
fi

if [ -d ./u-boot ] ; then
	rm -rf ./u-boot || true
fi

if [ -f ./.gitlab-runner ] ; then
	echo "git clone --reference-if-able /mnt/yocto-cache/git/beaglev-ahead-u-boot/ -b ${UBOOT_BRANCH} git@git.beagleboard.org:beaglev-ahead/beaglev-ahead-u-boot.git ./u-boot/ --depth=1"
	git clone --reference-if-able /mnt/yocto-cache/git/beaglev-ahead-u-boot/ -b ${UBOOT_BRANCH} git@git.beagleboard.org:beaglev-ahead/beaglev-ahead-u-boot.git ./u-boot/ --depth=1
else
	echo "git clone -b ${UBOOT_BRANCH} git@git.beagleboard.org:beaglev-ahead/beaglev-ahead-u-boot.git ./u-boot/ --depth=10"
	git clone -b ${UBOOT_BRANCH} git@git.beagleboard.org:beaglev-ahead/beaglev-ahead-u-boot.git ./u-boot/ --depth=10
fi

if [ -d ./BeagleBoard-DeviceTrees ] ; then
	rm -rf ./BeagleBoard-DeviceTrees || true
fi

echo "git clone -b v5.10.x-ti-unified git@git.beagleboard.org:beaglev-ahead/BeagleBoard-DeviceTrees.git"
git clone -b v5.10.x-ti-unified git@git.beagleboard.org:beaglev-ahead/BeagleBoard-DeviceTrees.git

if [ -d ./linux ] ; then
	rm -rf ./linux || true
fi

if [ -f ./.gitlab-runner ] ; then
	echo "git clone --reference-if-able /mnt/yocto-cache/git/beaglev-ahead-linux/ -b ${LINUX_BRANCH} git@git.beagleboard.org:beaglev-ahead/beaglev-ahead-linux.git ./linux/ --depth=1"
	git clone --reference-if-able /mnt/yocto-cache/git/beaglev-ahead-linux/ -b ${LINUX_BRANCH} git@git.beagleboard.org:beaglev-ahead/beaglev-ahead-linux.git ./linux/ --depth=1
else
	echo "git clone -b ${LINUX_BRANCH} git@git.beagleboard.org:beaglev-ahead/beaglev-ahead-linux.git ./linux/ --depth=10"
	git clone -b ${LINUX_BRANCH} git@git.beagleboard.org:beaglev-ahead/beaglev-ahead-linux.git ./linux/ --depth=10
fi

if [ -f ./.gitlab-runner ] ; then
	rm -f ./.gitlab-runner || true
fi

#
