#!/bin/sh

install -d -m755 ${DESTDIR}/etc/{rc.d,conf.d} || exit 1

for i in inittab rc.conf; do
  install -D -m644 $i ${DESTDIR}/etc/$i || exit 1
done
for i in rc.local rc.local.shutdown rc.multi rc.shutdown rc.single rc.sysinit; do
  install -D -m755 $i ${DESTDIR}/etc/$i || exit 1
done

install -D -m644 functions ${DESTDIR}/etc/rc.d/functions || exit 1
for i in network netfs; do
  install -D -m755 $i ${DESTDIR}/etc/rc.d/$i || exit 1
done

gcc $CFLAGS -o minilogd minilogd.c || exit 1
install -D -m755 minilogd ${DESTDIR}/sbin/minilogd || exit 1

install -D -m755 netcfg ${DESTDIR}/usr/bin/netcfg || exit 1
install -D -m644 profile-template ${DESTDIR}/etc/network-profiles/template || exit 1

install -D -m755 makedevs ${DESTDIR}/sbin/makedevs || exit 1