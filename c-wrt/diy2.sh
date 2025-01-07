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

#Fix golang version
#rm -rf feeds/packages/lang/golang
#git clone https://github.com/kenzok8/golang feeds/packages/lang/golang

# Modify default IP
sed -i 's/192.168.1.1/192.168.1.4/g' package/base-files/files/bin/config_generate

# fix ddns/firewall
patch -p1 < package/own/patches/fit-for_ddns_firewall.patch

# fix hwnat for kernel5.10
patch -p1 < package/own/patches/fit-hwnat-for-kernel510.patch

# fix build for ipq50xx
patch -p1 < package/own/patches/fit-for-ipq50xx.patch

# add dhcp/kvr/temp for luci21.02
sed -i 's/thermal\/thermal_zone0\/temp/hwmon\/hwmon1\/temp1_input/g' package/own/patches/add-dhcp_kvr_temp_luci21.patch
patch -p1 < package/own/patches/add-dhcp_kvr_temp_luci21.patch

# Modify
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-ksmbd/root/usr/share/luci/menu.d/luci-app-ksmbd.json
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i "4i \       \       \"order\": 10," feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json

#Fix some download failed first
mkdir dl
wget "https://www.dropbox.com/scl/fi/9ts30p2csnlb9imaf8k68/backports-20210222-5.4-qsdk-11.5.0.5.tar.xz?rlkey=sntbyfjgg86gu2uoocgb9ggp1&st=7w81hl56&dl=1" -O dl/backports-20210222-5.4-qsdk-11.5.0.5.tar.xz
wget "https://www.dropbox.com/scl/fi/gu7ge6jmefn72ttuop1zs/linux-5.4-qsdk-11.5.0.5.tar.xz?rlkey=tdpq0ye35x290frbh7i8uqrm8&st=jjvegqrr&dl=1" -O dl/linux-5.4-qsdk-11.5.0.5.tar.xz
