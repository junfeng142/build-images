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
# fix immortalwrt passwall2
rm -rf ../feeds/packages/net/{chinadns*,hysteria,geoview,trojan*,xray*,v2ray*,sing*}

# fix natmap version
rm -rf feeds/packages/net/natmap
wget -r --no-parent https://cdn.jsdelivr.net/gh/immortalwrt/packages@master/net/natmap/
cp -rf cdn.jsdelivr.net/gh/immortalwrt/packages@master/net/natmap feeds/packages/net/natmap/
rm -rf cdn.jsdelivr.net
find feeds/packages/net/natmap -name index.html -exec rm {} \;

# fix golang version
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang

# Modify default IP
sed -i 's/192.168.1.1/192.168.1.5/g' package/base-files/files/bin/config_generate

# fix ddns/firewall
patch -p1 < package/own/patches/fit-for_ddns_firewall.patch

# fix hwnat for kernel5.10
patch -p1 < package/own/patches/fit-hwnat-for-kernel510.patch

# add dhcp/kvr/temp for luci21.02
sed -i 's/thermal\/thermal_zone0\/temp/hwmon\/hwmon1\/temp1_input/g' package/own/patches/add-dhcp_kvr_temp_luci21.patch
patch -p1 < package/own/patches/add-dhcp_kvr_temp_luci21.patch

# Modify
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-ksmbd/root/usr/share/luci/menu.d/luci-app-ksmbd.json
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i "4i \       \       \"order\": 10," feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json

# fix dhcp/kvr and cgi-io
#patch -p1 < package/own/patches/add-dhcp-kvr-for-luci19.patch
#patch -p1 < package/own/patches/add-support-for-lucihttp.patch

# add cpu_temp for luci19.07
#sed -i 's/thermal\/thermal_zone0\/temp/hwmon\/hwmon1\/temp1_input/g' package/own/patches/add-cputemp_for_arm_luci19.patch
#patch -p1 < package/own/patches/add-cputemp_for_arm_luci19.patch

# Modify
#sed -i 's/\"services\"/\"system\"/g' feeds/luci/applications/luci-app-ttyd/luasrc/controller/ttyd.lua
#sed -i 's#("ttyd")#("ttyd"), 10#g' feeds/luci/applications/luci-app-ttyd/luasrc/controller/ttyd.lua
