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
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang

rm -rf feeds/packages/net/natmap
wget -r --no-parent https://cdn.jsdelivr.net/gh/immortalwrt/packages@master/net/natmap/
cp -rf cdn.jsdelivr.net/gh/immortalwrt/packages@master/net/natmap feeds/packages/net/natmap/
rm -rf cdn.jsdelivr.net
find feeds/packages/net/natmap -name index.html -exec rm {} \;

wget "https://www.dropbox.com/scl/fi/uccikbibj772c4sekzbk7/luci-app-turboacc.zip?rlkey=yzhkk0lfzhrthn8hbl1qt8k5j&st=31820445&dl=1" -O luci-app-turboacc.zip
rm -rf feeds/luci/applications/luci-app-turboacc
unzip luci-app-turboacc.zip -d feeds/luci/applications/
rm -rf luci-app-turboacc.zip

#Fix some download failed first
mkdir dl
wget "https://www.dropbox.com/scl/fi/9ts30p2csnlb9imaf8k68/backports-20210222-5.4-qsdk-11.5.0.5.tar.xz?rlkey=sntbyfjgg86gu2uoocgb9ggp1&st=7w81hl56&dl=1" -O dl/backports-20210222-5.4-qsdk-11.5.0.5.tar.xz
wget "https://www.dropbox.com/scl/fi/gu7ge6jmefn72ttuop1zs/linux-5.4-qsdk-11.5.0.5.tar.xz?rlkey=tdpq0ye35x290frbh7i8uqrm8&st=jjvegqrr&dl=1" -O dl/linux-5.4-qsdk-11.5.0.5.tar.xz
