# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6..10} )

inherit distutils-r1

HOMEPAGE="https://github.com/lpechacek/cpuset/"
SRC_URI="${HOMEPAGE}archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

DSCRIPTION="Cpuset is a wrapper around Linux cpusets facilities"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
RESTRICT="test"

REQUIRED_USE=""

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

#src_prepare() {
#	default
#	sed -i "s/share\/doc\/packages\/cpuset/share\/doc\/${P}/g"
#}
