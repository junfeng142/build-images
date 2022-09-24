#!/bin/bash

TAG=armv7
if [ ! -z "$1" ];then
	TAG=$1
fi

TMPDIR=openwrt_rootfs
OUTDIR=dockerimgs/docker
IMG_NAME=javonca/openwrt

[ -d "$TMPDIR" ] && rm -rf "$TMPDIR"

mkdir -p "$TMPDIR"  && \
mkdir -p "$OUTDIR"  && \
gzip -dc openwrt-*-rootfs.tar.gz | ( cd "$TMPDIR" && tar xf - ) && \
cp -f rc.local "$TMPDIR/etc/" && \
cp -f dhcp "$TMPDIR/etc/config/" && \
rm -f "$TMPDIR/etc/bench.log" && \
echo "37 7 * * * /etc/coremark.sh" >> "$TMPDIR/etc/crontabs/root" && \
rm -rf "$TMPDIR/lib/firmware/*" "$TMPDIR/lib/modules/*" && \
(cd "$TMPDIR" && tar cf ../openwrt-default-rootfs-patched.tar .) && \
rm -f DockerImg-OpenwrtArmv7-${TAG}.gz && \
docker buildx build --no-cache --platform=linux/arm/v7 -o type=docker -t ${IMG_NAME}:${TAG} . && \
rm -f  openwrt-default-rootfs-patched.tar && \
rm -rf "$TMPDIR" && \
docker save ${IMG_NAME}:${TAG} | pigz -9 > $OUTDIR/docker-img-openwrt-${TAG}-${TAG}.gz
