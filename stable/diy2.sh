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
sed -i 's/192.168.1.1/192.168.1.4/g' package/base-files/files/bin/config_generate

# add upx
#mv ./upx ./staging_dir/host/bin && chmod +x ./staging_dir/host/bin/upx

# fix dhcp/kvr and cgi-io
patch -p1 < package/own/patches/add-dhcp-kvr-for-luci19.patch
patch -p1 < package/own/patches/add-support-for-lucihttp.patch

# add cpu_temp for luci19.07
sed -i 's/thermal\/thermal_zone0\/temp/hwmon\/hwmon1\/temp1_input/g' package/own/patches/add-cputemp_for_arm_luci19.patch
patch -p1 < package/own/patches/add-cputemp_for_arm_luci19.patch

# Modify
sed -i 's/\"services\"/\"system\"/g' feeds/luci/applications/luci-app-ttyd/luasrc/controller/ttyd.lua
sed -i 's#("ttyd")#("ttyd"), 10#g' feeds/luci/applications/luci-app-ttyd/luasrc/controller/ttyd.lua

# fit batman-adv for easymesh
#rm feeds/routing/batman-adv/patches/0004-Revert-batman-adv-genetlink-make-policy-common-to-fa.patch
#rm feeds/routing/batman-adv/patches/0037-batman-adv-allow-netlink-usage-in-unprivileged-conta.patch
