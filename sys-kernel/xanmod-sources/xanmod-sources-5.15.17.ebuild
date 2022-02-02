# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="2"
K_SECURITY_UNSUPPORTED="1"
K_NOSETEXTRAVERSION="1"
ETYPE="sources"

# Make sure that there is only one xanmod of this version
RDEPEND="
	!sys-kernel/xanmod-hybrid-${OKV}
	!sys-kernel/xanmod-lts-${OKV}
	!sys-kernel/xanmod-rt-${OKV}
	!sys-kernel/xanmod-rt-sources-${OKV}
"

inherit kernel-2
detect_version

DESCRIPTION="Full XanMod sources with Gentoo patchsets"
HOMEPAGE="https://xanmod.org"
LICENSE+=" CDDL"
KEYWORDS="~amd64 ~x86"
XANMOD_VERSION="2"
XANMOD_URI="https://github.com/xanmod/linux/releases/download"
SRC_URI="
	${KERNEL_BASE_URI}/linux-${KV_MAJOR}.${KV_MINOR}.tar.xz
	${XANMOD_URI}/${OKV}-xanmod${XANMOD_VERSION}/patch-${OKV}-xanmod${XANMOD_VERSION}.xz
	${GENPATCHES_URI}
"

S="${WORKDIR}/linux-${PV}-xanmod"

src_unpack() {
	UNIPATCH_LIST_DEFAULT=""
	UNIPATCH_LIST="${DISTDIR}/patch-${OKV}-xanmod${XANMOD_VERSION}.xz "
	kernel-2_src_unpack
}

src_prepare() {

	kernel-2_src_prepare

}

pkg_postinst() {
	elog "MICROCODES"
	elog "Use xanmod-sources with microcodes"
	elog "Read https://wiki.gentoo.org/wiki/Intel_microcode"
}
