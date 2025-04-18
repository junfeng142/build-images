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
#git clone -b bypass https://github.com/junfeng142/packages.git package/bypass

# clone helloworld
#git clone -b main https://github.com/fw876/helloworld.git package/helloworld
#sed -i 's/ +libopenssl-legacy//g' package/helloworld/shadowsocksr-libev/Makefile

# clone passwall
git clone https://github.com/xiaorouji/openwrt-passwall-packages.git package/passwall
#git clone https://github.com/xiaorouji/openwrt-passwall.git package/passwall
git clone https://github.com/xiaorouji/openwrt-passwall2.git package/passwall2

# clone cups
#git clone https://github.com/sirpdboy/luci-app-cupsd.git package/cups

# fit for packages
#mv package/bypass/luci-app-bypass package/bypass/smartdns package/bypass/lua-maxminddb package/bypass/trojan-plus package/my && rm -rf package/bypass
#mv package/passwall/v2ray-core package/passwall/v2ray-geodata package/passwall/v2ray-plugin package/passwall/geoview package/my && rm -rf package/passwall

# add usb_gadget kernel5.4
cat package/own/configs/sunxi-config >> target/linux/sunxi/cortexa7/config-5.4

# usbphy mac
sed -i 's/rootwait/rootwait g_ether.dev_addr=f8:dc:7a:5e:32:02 g_ether.host_addr=f8:dc:7a:5e:32:01/g' package/boot/uboot-sunxi/uEnv-default.txt

# add cputemp/usb for orangepizero
patch -p1 < package/own/patches/add-patch_sun8i-h3-ths.patch
