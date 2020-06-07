# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/sdcc-svn/sdcc-svn-2.5.0.ebuild,v 1.1 2006/05/05 18:41:38 calchan Exp $

ESVN_REPO_URI="https://s.snth.net/svn/neverball/trunk"

inherit eutils games subversion

MY_PN="${PN/-svn}"

DESCRIPTION="Clone of Super Monkey Ball using SDL/OpenGL"
HOMEPAGE="http://icculus.org/neverball/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="!games-puzzle/neverball
	>=media-libs/libsdl-1.2
	>=media-libs/sdl-mixer-1.2.5
	>=media-libs/sdl-image-1.2.2
	media-libs/sdl-ttf
	virtual/opengl"

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	sed -i \
		-e '/CONFIG_DATA/s:"\./data":"'${GAMES_DATADIR}/${MY_PN}'":g' \
		share/base_config.h \
		|| die "sed base_config.h failed"
	sed -i \
		-e 's:-O3:$(E_CFLAGS):' \
		-e "/^MAPC_TARG/s/mapc/${MY_PN}-mapc/" \
		Makefile \
		|| die "sed Makefile failed"
}

src_compile() {
	emake E_CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dogamesbin ${MY_PN}-mapc neverball neverputt || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}/${MY_PN}"
	doins -r data/* || die "doins failed"
	dodoc AUTHORS CHANGES MANUAL README TRANSLATIONS

	doicon icon/*.png
	make_desktop_entry neverball Neverball neverball.png
	make_desktop_entry neverputt Neverputt neverputt.png

	prepgamesdirs
}
