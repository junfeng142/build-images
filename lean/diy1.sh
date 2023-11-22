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
#git clone https://github.com/xiaorouji/openwrt-passwall-packages.git package/passwall
#git clone https://github.com/xiaorouji/openwrt-passwall.git package/passwall/luci

# clone helloworld
git clone -b main https://github.com/fw876/helloworld.git package/helloworld

# Uncomment password
sed -i '/shadow/s/^/#/g' package/lean/default-settings/files/zzz-default-settings

# clone N1HK1dabao
git clone https://github.com/Netflixxp/N1HK1dabao.git N1HK1dabao

# kernel version
sed -i 's/6.1/5.15/g' target/linux/x86/Makefile
