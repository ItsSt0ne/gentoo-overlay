# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker xdg-utils

DESCRIPTION="A Markdown Editor for the 21st century."
HOMEPAGE="https://www.zettlr.com/"
SRC_URI="https://github.com/Zettlr/Zettlr/releases/download/v${PV}/Zettlr-${PV}-amd64.deb"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}
	dev-libs/expat
	net-libs/gnutls
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gconf
	media-libs/alsa-lib
	media-libs/freetype
	sys-apps/dbus
	x11-libs/gtk+:3[cups]
"
BDEPEND=""

RESTRICT="mirror"
S="${WORKDIR}"

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	sed -i 's/text\/markdown;text\/markdown;text\/markdown;/text\/markdown;/g' usr/share/applications/Zettlr.desktop || die
	eapply_user
}

src_install() {
	cp -a * "${ED}/"
	mkdir -p "${ED}/usr/bin"
	ln -sr "${ED}/opt/Zettlr/Zettlr" "${ED}/usr/bin/zettlr"

	mv "${ED}/usr/share/doc/zettlr" "${ED}/usr/share/doc/${P}"
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
