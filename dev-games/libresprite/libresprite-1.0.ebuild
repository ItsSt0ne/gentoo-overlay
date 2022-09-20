# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop flag-o-matic xdg-utils git-r3

DESCRIPTION="FOSS animated sprite editor & pixel art tool, forked from Aseprite"
HOMEPAGE="https://libresprite.github.io/"
#SRC_URI="https://codeload.github.com/LibreSprite/LibreSprite/tar.gz/refs/tags/v${PV} -> ${P}.tar.gz"
EGIT_REPO_URI="https://github.com/LibreSprite/LibreSprite.git"
EGIT_COMMIT="v${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="+bundled-libs debug kde gtk3 test webp"
RESTRICT="bindist mirror !test? ( test )"

RDEPEND="
	!bundled-libs? ( media-libs/allegro:0[X,png] )
	gtk3? ( dev-cpp/gtkmm:3.0 )
	kde? (
		dev-qt/qtcore:5
		kde-frameworks/kio:5
	)
	webp? ( media-libs/libwebp )
	!dev-games/aseprite
	dev-libs/tinyxml
	media-libs/freetype
	media-libs/giflib:=
	media-libs/libpng:0=
	net-misc/curl
	sys-libs/zlib
	virtual/jpeg:0
	x11-libs/libX11
	x11-libs/pixman"
BDEPEND="
	app-arch/unzip
	dev-lang/lua:5.4
	gtk3? ( virtual/pkgconfig )
	webp? ( virtual/pkgconfig )"

DOCS=( docs/files/ase.txt
	docs/files/fli.txt
	docs/files/msk.txt
	docs/files/pic.txt
	docs/files/picpro.txt
	README.md )

#S="${WORKDIR}/LibreSprite-${PV}"

src_prepare() {
	cmake_src_prepare

	# Fix to make flag-o-matic work.
	if use debug ; then
		sed -i '/-DNDEBUG/d' CMakeLists.txt || die
	fi
	# Fix shebang in thumbnailer
	sed -i -e 's:#!/usr/bin/sh:#!/bin/sh:' desktop/libresprite-thumbnailer || die
}

src_configure() {
	use debug && append-cppflags -DDEBUGMODE -D_DEBUG

	local mycmakeargs=(
		-DFULLSCREEN_PLATFORM=ON
		-DUSE_SHARED_ALLEGRO4=$(usex !bundled-libs)
		-DWITH_DESKTOP_INTEGRATION=ON
		-DWITH_GTK_FILE_DIALOG_SUPPORT="$(usex gtk3)"
		-DWITH_QT_THUMBNAILER="$(usex kde)"
		-DWITH_WEBP_SUPPORT="$(usex webp)"
		-DENABLE_TESTS="$(usex test)"
	)
	cmake_src_configure
}

src_install() {
	newicon -s 64 "${S}/data/icons/ase64.png" "${PN}.png"
	cmake_src_install
}

pkg_postinst() {
	if use !bundled-libs ; then
		ewarn "Libresprite has been built with system-wide Allegro 4."
		ewarn "Please note that you will not be able to resize the main window."
		ewarn "For resizing support enable USE-flag bundled-libs and rebuild package."
	fi
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
