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

# clone passwall
#git clone -b packages https://github.com/xiaorouji/openwrt-passwall.git package/passwall
#git clone -b luci https://github.com/xiaorouji/openwrt-passwall.git package/passwall/luci

# clone helloworld
git clone https://github.com/fw876/helloworld.git package/helloworld
patch -p1 < package/own/patches/add-packages-for-helloworld.patch
sed -i '/PACKAGE_libustream/d' package/helloworld/luci-app-ssr-plus/Makefile

# clone aliyun
git clone https://github.com/messense/aliyundrive-webdav.git package/aliyunwebd
git clone https://github.com/messense/aliyundrive-fuse.git package/aliyunfuse

# add wifi/cputemp/usb/uart
#patch -p1 < package/own/patches/add-patch_dts_file-wifi-xradio.patch
#patch -p1 < package/own/patches/add-patch_sun8i-h3-ths.patch
#patch -p1 < package/own/patches/add-patch_sun8i-spi0flash_16M-usb2-usb3-uart1-uart2.patch
#patch -p1 < package/own/patches/fit-mac80211.patch

# usbphy mac
sed -i 's/rootwait/rootwait g_ether.dev_addr=f8:dc:7a:5e:32:02 g_ether.host_addr=f8:dc:7a:5e:32:01/g' package/boot/uboot-sunxi/uEnv-default.txt
