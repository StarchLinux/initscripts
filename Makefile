VER  := $(shell git describe)

DIRS := \
	/etc/rc.d \
	/etc/conf.d \
	/etc/rc.d/functions.d \
	/etc/logrotate.d \
	/etc/profile.d \
	/sbin \
	/etc/tmpfiles.d \
	/lib/tmpfiles.d \
	/etc/binfmt.d \
	/lib/binfmt.d \
	/etc/sysctl.d \
	/lib/sysctl.d \
	/lib/initscripts \
	/usr/share/bash-completion/completions \
	/usr/share/zsh/site-functions \
	/doc/man/man5 \
	/doc/man/man8

MAN_PAGES := \
	rc.d.8 \
	rc.conf.5 \
	locale.conf.5 \
	vconsole.conf.5 \
	hostname.5

all: doc

installdirs:
	install -dm755 $(foreach DIR, $(DIRS), $(DESTDIR)$(DIR))

install: installdirs doc
	install -m644 inittab rc.conf $(DESTDIR)/etc/
	install -m755 rc.local rc.local.shutdown rc.multi rc.shutdown rc.single rc.sysinit $(DESTDIR)/etc/
	install -m644 bootlog $(DESTDIR)/etc/logrotate.d/
	install -m644 functions $(DESTDIR)/etc/rc.d/
	install -m755 hwclock network netfs $(DESTDIR)/etc/rc.d/
	install -m755 locale.sh $(DESTDIR)/etc/profile.d/
	install -m755 rc.d $(DESTDIR)/sbin/
	install -m644 $$(ls $(MAN_PAGES) | grep '\.5$$') $(DESTDIR)/doc/man/man5/
	install -m644 $$(ls $(MAN_PAGES) | grep '\.8$$') $(DESTDIR)/doc/man/man8/
	install -m755 arch-tmpfiles arch-sysctl arch-binfmt $(DESTDIR)/lib/initscripts/
	install -m644 tmpfiles.conf $(DESTDIR)/lib/tmpfiles.d/arch.conf
	install -m644 -T bash-completion $(DESTDIR)/usr/share/bash-completion/completions/rc.d
	install -m644 -T zsh-completion $(DESTDIR)/usr/share/zsh/site-functions/_rc.d

%.5: %.5.txt
	a2x -d manpage -f manpage $<

%.8: %.8.txt
	a2x -d manpage -f manpage $<

doc: $(MAN_PAGES)

clean:
	rm -f $(MAN_PAGES)

tar:
	git archive HEAD --prefix=initscripts-$(VER)/ | xz > initscripts-$(VER).tar.xz

release: tar
	scp initscripts-$(VER).tar.xz gerolde.archlinux.org:/srv/ftp/other/initscripts/
	scp initscripts-$(VER).tar.xz pkgbuild.com:~/packages/initscripts/trunk/

.PHONY: all installdirs install doc clean tar release
