# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1 meson xdg-utils

#BUILD_DIR="/usr"
EMESON_BUILDTYPE="release"
DISTUTILS_USE_SETUPTOOLS="no"
DESCRIPTION="GTK-based mixer application (and more) for JACK"
HOMEPAGE="https://rdio.space/jackmixer/"
SRC_URI="https://rdio.space/jackmixer/tarballs/jack_mixer-${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

BDEPEND="
	sys-devel/gettext
	dev-python/cython
	dev-util/ninja
	virtual/jack
	dev-util/meson
	dev-python/docutils
	dev-python/pyxdg
"
DEPEND="virtual/jack"
RDEPEND="${DEPEND}
	dev-python/pycairo
	dev-python/pygobject
	dev-python/appdirs
"

src_prepare() {
	default
}

src_configure() {
	meson_src_configure
}

src_install() {
	meson_src_install
}
pkg_postrm() {
	xdg_icon_cache_update
}

pkg_postinst() {
	xdg_icon_cache_update
}
