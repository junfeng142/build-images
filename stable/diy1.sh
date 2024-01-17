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

# clone ssr
git clone -b ssr https://github.com/junfeng142/packages.git package/ssr

# clone bypass
#git clone -b bypass https://github.com/junfeng142/packages.git package/bypass

# clone helloworld
git clone -b master https://github.com/fw876/helloworld.git package/helloworld

# clone alist
git clone https://github.com/sbwml/luci-app-alist.git package/alist

# fit for bypass
#mv package/bypass/luci-app-bypass package/bypass/smartdns package/bypass/lua-maxminddb package/bypass/trojan-plus package/my && rm -rf package/bypass

# Modify image size
sed -i 's/tplink-8mlzma/tplink-16mlzma/g' target/linux/ar71xx/image/tiny-tp-link.mk

# usbphy mac
sed -i 's/rootwait/rootwait g_ether.dev_addr=f8:dc:7a:5e:32:02 g_ether.host_addr=f8:dc:7a:5e:32:01/g' package/boot/uboot-sunxi/uEnv-default.txt

# add sfe-flowoffload
patch -p1 < package/own/patches/add-sfe-flowoffload-for-stable.patch
chmod +x package/own/luci-app-flowoffload/root/etc/init.d/flowoffload && chmod +x package/own/luci-app-flowoffload/root/etc/uci-defaults/flowoffload
chmod +x package/own/luci-app-sfe/root/etc/init.d/sfe && chmod +x package/own/luci-app-sfe/root/etc/uci-defaults/sfe

# add cputemp/wifi/usb for orangepizero
#patch -p1 < package/own/patches/fit-for-mac80211.patch
patch -p1 < package/own/patches/add-patch_dts_file-wifi-xradio.patch
patch -p1 < package/own/patches/add-patch_sun8i-h3-ths.patch
patch -p1 < package/own/patches/add-patch_sun8i-spi0flash_16M-usb2-usb3-uart1-uart2.patch
