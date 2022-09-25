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
#git clone -b ssr https://github.com/junfeng142/packages.git package/ssr

# clone passwall
#git clone -b packages https://github.com/xiaorouji/openwrt-passwall.git package/passwall
#git clone -b luci https://github.com/xiaorouji/openwrt-passwall.git package/passwall/luci

# clone helloworld
git clone https://github.com/fw876/helloworld.git package/helloworld
patch -p1 < package/own/patches/add-packages-for-helloworld.patch

# clone aliyun
git clone https://github.com/messense/aliyundrive-webdav.git package/aliyunwebd
git clone https://github.com/messense/aliyundrive-fuse.git package/aliyunfuse

# Modify image size
#sed -i 's/tplink-8mlzma/tplink-16mlzma/g' target/linux/ar71xx/image/tiny-tp-link.mk

# fit mypackages
#patch -p1 <  package/own/patches/fit-for-mac80211.patch
patch -p1 < package/own/patches/add-sfe-flowoffload-for-stable.patch
