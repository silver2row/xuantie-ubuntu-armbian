#!/bin/bash

if ! id | grep -q root; then
	echo "./06_generate_ubuntu_root.sh must be run as root:"
	echo "sudo ./06_generate_ubuntu_root.sh"
	exit
fi

wdir=`pwd`

image="2023-02-12"

if [ ! -f ./deploy/ubuntu-23.04-console-riscv64-${image}/riscv64-rootfs-ubuntu-lunar.tar ] ; then
	wget -c --directory-prefix=./deploy https://rcn-ee.net/rootfs/ubuntu-riscv64-lunar-minimal/${image}/ubuntu-23.04-console-riscv64-${image}.tar.xz
	cd ./deploy/
	tar xf ubuntu-23.04-console-riscv64-${image}.tar.xz
	cd ../
fi

if [ -d ./ignore/.root ] ; then
	rm -rf ./ignore/.root || true
fi
mkdir -p ./ignore/.root

tar xfp ./deploy/ubuntu-23.04-console-riscv64-${image}/riscv64-rootfs-ubuntu-lunar.tar -C ./ignore/.root
sync

mkdir -p ./ignore/.root/boot/firmware/ || true

echo '/dev/mmcblk0p2  /boot/firmware/ auto  defaults  0  2' >> ./ignore/.root/etc/fstab
echo '/dev/mmcblk0p3  /  auto  errors=remount-ro  0  1' >> ./ignore/.root/etc/fstab
echo 'debugfs  /sys/kernel/debug  debugfs  mode=755,uid=root,gid=gpio,defaults  0  0' >> ./ignore/.root/etc/fstab

rm -rf ./ignore/.root/usr/lib/systemd/system/grow_partition.service || true

cp -v ./ignore/.root/etc/bbb.io/templates/eth0-DHCP.network ./ignore/.root/etc/systemd/network/eth0.network || true

#Cleanup large firmware's..
rm -rf ./ignore/.root/usr/lib/firmware/amdgpu/ || true
rm -rf ./ignore/.root/usr/lib/firmware/dpaa2/ || true
rm -rf ./ignore/.root/usr/lib/firmware/i915/ || true
rm -rf ./ignore/.root/usr/lib/firmware/intel/ || true
rm -rf ./ignore/.root/usr/lib/firmware/liquidio/ || true
rm -rf ./ignore/.root/usr/lib/firmware/mediatek/ || true
rm -rf ./ignore/.root/usr/lib/firmware/mellanox/ || true
rm -rf ./ignore/.root/usr/lib/firmware/mrvl/ || true
rm -rf ./ignore/.root/usr/lib/firmware/netronome/ || true
rm -rf ./ignore/.root/usr/lib/firmware/nvidia/ || true
rm -rf ./ignore/.root/usr/lib/firmware/qcom/ || true
rm -rf ./ignore/.root/usr/lib/firmware/qed/ || true
rm -rf ./ignore/.root/usr/lib/firmware/radeon/ || true
rm -rf ./ignore/.root/usr/lib/firmware/ueagle-atm/ || true
rm -rf ./ignore/.root/usr/lib/firmware/vsc/ || true

rm -rf ./ignore/.root/usr/lib/firmware/iwlwifi-* || true
rm -rf ./ignore/.root/usr/lib/firmware/ipw* || true

cp -v ./bins/ap6203/* ./ignore/.root/usr/lib/firmware/ || true

# setuid root ping+ping6
chmod u+s ./ignore/.root/usr/bin/ping ./ignore/.root/usr/bin/ping6

if [ -f ./deploy/.modules ] ; then
	version=$(cat ./deploy/.modules || true)
	if [ -f ./deploy/${version}.tar.gz ] ; then
		tar xfv ./deploy/${version}.tar.gz -C ./ignore/.root/usr/
	fi
fi

echo '---------------------'
echo 'File Size'
du -sh ignore/.root/ || true
echo '---------------------'

dd if=/dev/zero of=./deploy/root.ext4 bs=1 count=0 seek=4000M
mkfs.ext4 -F ./deploy/root.ext4 -d ./ignore/.root

if [ -f ./.06_generate_root.sh ] ; then
	rm -f ./.06_generate_root.sh || true
fi
