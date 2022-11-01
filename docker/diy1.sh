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

# clone bypass
git clone https://github.com/kiddin9/openwrt-bypass.git package/bypass
patch -p1 < package/own/patches/add-packages-for-bypass.patch
patch -p1 < package/own/patches/add-Hans-for-bypass.patch

# clone aliyun
git clone https://github.com/messense/aliyundrive-webdav.git package/aliyunwebd
git clone https://github.com/messense/aliyundrive-fuse.git package/aliyunfuse
