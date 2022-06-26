# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8,9,10} )

inherit distutils-r1 gnome2-utils xdg xdg-utils python-r1 python-utils-r1

MY_PN="DisplayCAL"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Display calibration and characterization powered by Argyll CMS"
HOMEPAGE="https://displaycal.net/"
SRC_URI="https://github.com/eoyilmaz/displaycal-py3/releases/download/${PV}/${MY_P}.tar.gz"
RESTRICT="mirror test"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=media-gfx/argyllcms-1.1.0
	dev-python/wxpython:4.0[${PYTHON_USEDEP}]
	>=x11-libs/libX11-1.3.3
	>=x11-apps/xrandr-1.3.2
	>=x11-libs/libXxf86vm-1.1.0
	>=x11-libs/libXinerama-1.1
	dev-ruby/pkg-config
	dev-python/build[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	dev-python/pytest-faulthandler[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	|| (
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
	)
	dev-python/distro[${PYTHON_USEDEP}]
"

# Just in case someone renames the ebuild
S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Do not generate udev/hotplug files
	sed -e '/if os.path.isdir/s#/etc/udev/rules.d\|/etc/hotplug#\0-non-existant#' \
		-i DisplayCAL/setup.py || die
	# Prohibit setup from running xdg-* programs, resulting to sandbox violation
	sed -e '/if which/s#xdg-icon-resource#\0-non-existant#' \
		-e '/if which/s#xdg-desktop-menu#\0-non-existant#' \
		-i DisplayCAL/postinstall.py || die

	# Remove deprecated Encoding key from .desktop file
	sed -e '/Encoding=UTF-8/d' -i misc/*.desktop  || die

	# Remove x-world Media Type
	sed -e 's/x\-world\/x\-vrml\;//g' \
		-i misc/displaycal-vrml-to-x3d-converter.desktop || die

	distutils-r1_src_prepare
}

src_compile() {
	python_setup
	python -m build --wheel --no-isolation
}

src_install() {
	python -m installer --destdir="${ED}" "dist/*.whl"
	rm -r "${ED}/usr/lib/python3.10/site-packages/etc/"
	#doins "${ED}/etc/xdg/autostart"
	mv "${ED}/usr/share/doc/${MY_P}" "${ED}/usr/share/doc/${P}"
	python_optimize
}

pkg_postinst() {
	xdg_pkg_postinst
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	xdg_icon_cache_update
}
