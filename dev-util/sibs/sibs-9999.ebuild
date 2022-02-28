# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake git-r3

DESCRIPTION="A simple cross-platform build system and package manager for c, c++ and zig. Inspired by rusts cargo"
HOMEPAGE="https://git.dec05eba.com/sibs/about/"
SRC_URI=""
EGIT_REPO_URI="https://repo.dec05eba.com/sibs"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	app-arch/libarchive
	"
RDEPEND="
	${DEPEND}
	dev-util/ccache
	"

src_install() {
	dobin "${BUILD_DIR}/sibs"
}
