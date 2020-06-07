# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils gnome2

DESCRIPTION="Opera web browser with usage report tool"
HOMEPAGE="http://www.opera.com"

SLOT="0"
LICENSE="OPERA-9.0"
KEYWORDS="~x86"

IUSE="qt-static spell gnome"
RESTRICT="strip mirror"

OPERALNG="en"
OPERASUFF="543"
OPERAVER="9.12-20070119"
OPERAFTPDIR="910/final/${OPERALNG}"

SRC_URI="
	qt-static? (	http://snapshot.opera.com/unix/Weekly-${OPERASUFF}/intel-linux/${PN}-${OPERAVER}.1-static-qt.i386-${OPERALNG}-${OPERASUFF}.tar.bz2 )
	!qt-static? ( http://snapshot.opera.com/unix/Weekly-${OPERASUFF}/intel-linux/${PN}-${OPERAVER}.6-shared-qt.i386-${OPERALNG}-${OPERASUFF}.tar.bz2 )
	ftp://ftp.gtlib.cc.gatech.edu/pub/gentoo/gentoo-x86/www-client/opera/files/opera.desktop"

DEPEND=">=sys-apps/sed-4
	amd64? ( sys-apps/setarch )"

RDEPEND="|| ( ( x11-libs/libXrandr
				x11-libs/libXp
				x11-libs/libXmu
				x11-libs/libXi
				x11-libs/libXft
				x11-libs/libXext
				x11-libs/libXcursor
				x11-libs/libX11
				x11-libs/libSM
				x11-libs/libICE
			  )
			  virtual/x11
			)
	>=media-libs/fontconfig-2.1.94-r1
	qt-static? ( app-emulation/emul-linux-x86-xlibs )
    spell? ( app-text/aspell )
    !qt-static? ( =x11-libs/qt-3* )
	media-libs/jpeg"

use qt-static && S=${WORKDIR}/${PN}-${OPERAVER}.1-static-qt.i386-${OPERALNG}-${OPERASUFF}
use	qt-static || S=${WORKDIR}/${PN}-${OPERAVER}.6-shared-qt.i386-${OPERALNG}-${OPERASUFF}

src_compile() {
	true
}

src_install() {
	OPERA_INSTOPTS="--DESTDIR=${D} --prefix=/opt/opera"
	# Prepare installation directories for Opera's installer script.
	dodir /etc

	# Opera's native installer.
	if [ ${ARCH} = "amd64" ]; then
		linux32 ./install.sh ${OPERA_INSTOPTS} || die
	else
		./install.sh ${OPERA_INSTOPTS} || die
	fi

	# java workaround
	sed -i -e 's:LD_PRELOAD="${OPERA_JAVA_DIR}/libawt.so":LD_PRELOAD="$LD_PRELOAD"\:"${OPERA_JAVA_DIR}/libawt.so":' ${D}/opt/opera/bin/opera

	dosed /opt/opera/bin/opera
	dosed /opt/opera/share/opera/java/opera.policy

	# Install the icons
	insinto /usr/share/pixmaps
	doins images/opera.xpm
	for res in 16x16 22x22 32x32 48x48 ; do
		insinto /usr/share/icons/hicolor/${res}/apps/
		newins images/opera_${res}.png opera.png
	done

	# Install the menu entry
	insinto /usr/share/applications
	doins ${DISTDIR}/opera.desktop

	# Install a symlink /usr/bin/opera
	dodir /usr/bin
	dosym /opt/opera/bin/opera /usr/bin/opera

	# fix plugin path
	echo "Plugin Path=/opt/opera/lib/opera/plugins" >> ${D}/etc/opera6rc

	# enable spellcheck
	if use spell; then
		if use qt-static; then
			DIR=$OPERAVER.1
		else
			use sparc && DIR=$OPERAVER.2 || DIR=$OPERAVER.5
		fi
		echo "Spell Check Engine=/opt/opera/lib/opera/${DIR}/spellcheck.so" >> ${D}/opt/opera/share/opera/ini/spellcheck.ini
	fi

	dodir /etc/revdep-rebuild
	echo 'SEARCH_DIRS_MASK="/opt/opera/lib/opera/plugins"' > ${D}/etc/revdep-rebuild/90opera
}

pkg_postinst() {
	use gnome && gnome2_pkg_postinst

	elog "For localized language files take a look at:"
	elog "http://www.opera.com/download/languagefiles/index.dml?platform=linux"
	elog
	elog "To change the spellcheck language edit /opt/opera/share/opera/ini/spellcheck.ini"
	elog "and emerge app-dicts/aspell-language."
}


pkg_postrm() {
	use gnome && gnome2_pkg_postrm
}
