#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# clone own
git clone https://github.com/junfeng142/packages.git package/own

# clone bypass
git clone -b bypass https://github.com/junfeng142/packages.git package/bypass

# clone aliyun
git clone https://github.com/messense/aliyundrive-webdav.git package/aliyunwebd
git clone https://github.com/messense/aliyundrive-fuse.git package/aliyunfuse

# add usb_gadget kernel5.4
cat package/own/configs/sunxi-config >> target/linux/sunxi/config-5.4

# usbphy mac
sed -i 's/rootwait/rootwait g_ether.dev_addr=f8:dc:7a:5e:32:02 g_ether.host_addr=f8:dc:7a:5e:32:01/g' package/boot/uboot-sunxi/uEnv-default.txt

# Uncomment password
sed -i '/shadow/s/^/#/g' package/emortal/default-settings/files/99-default-settings

# add usbpower for hc5761
patch -p1 < package/own/patches/fit_usb_dts_for_hc5761.patch
