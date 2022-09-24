#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.0.5/g' package/base-files/files/bin/config_generate

# Modify
sed -i 's/\"services\"/\"nas\"/g' package/aliyunwebd/openwrt/luci-app-aliyundrive-webdav/luasrc/controller/aliyundrive-webdav.lua
sed -i 's/services/nas/g' package/aliyunwebd/openwrt/luci-app-aliyundrive-webdav/luasrc/view/aliyundrive-webdav/aliyundrive-webdav_log.htm
sed -i 's/services/nas/g' package/aliyunwebd/openwrt/luci-app-aliyundrive-webdav/luasrc/view/aliyundrive-webdav/aliyundrive-webdav_qrcode.htm
sed -i 's/services/nas/g' package/aliyunwebd/openwrt/luci-app-aliyundrive-webdav/luasrc/view/aliyundrive-webdav/aliyundrive-webdav_status.htm

sed -i 's/\"services\"/\"nas\"/g' package/aliyunfuse/openwrt/luci-app-aliyundrive-fuse/luasrc/controller/aliyundrive-fuse.lua
sed -i 's/services/nas/g' package/aliyunfuse/openwrt/luci-app-aliyundrive-fuse/luasrc/view/aliyundrive-fuse/aliyundrive-fuse_log.htm
sed -i 's/services/nas/g' package/aliyunfuse/openwrt/luci-app-aliyundrive-fuse/luasrc/view/aliyundrive-fuse/aliyundrive-fuse_status.htm

sed -i 's/system/services/g' feeds/luci/applications/luci-app-cpufreq/luasrc/controller/cpufreq.lua

sed -i 's/TTYD 终端/终端/g' feeds/luci/applications/luci-app-ttyd/po/zh-cn/terminal.po

sed -i 's/Turbo ACC 网络加速/网络加速/g' feeds/luci/applications/luci-app-turboacc/po/zh-cn/turboacc.po
