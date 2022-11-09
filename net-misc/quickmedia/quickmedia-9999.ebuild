# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGIT_CLONE_TYPE="shallow"

inherit git-r3

DESCRIPTION="A rofi inspired native client for web services. Supports youtube, peertube, lbry, soundcloud, nyaa.si, 4chan, matrix, saucenao, hotexamples, anilist and several manga sites"
HOMEPAGE="https://git.dec05eba.com/QuickMedia/about"
SRC_URI=""
EGIT_REPO_URI="https://repo.dec05eba.com/QuickMedia"

LICENSE="GPL-3"
SLOT="0"
IUSE="+ffmpeg libnotify"


BDEPEND="
	dev-util/sibs
	"

DEPEND="
	media-libs/libglvnd
	x11-libs/libX11
	x11-libs/libXrandr
	media-video/mpv[libmpv]
	"
RDEPEND="
	${DEPEND}
	net-misc/curl
	media-fonts/noto
	x11-misc/xdg-utils
	net-misc/youtube-dl
	ffmpeg? ( media-video/ffmpeg )
	libnotify? ( x11-libs/libnotify )
	"

src_compile() {
	sibs build --release --debug-symbols video_player || die
	sibs build --release --debug-symbols || die
}

src_install() {
	SIBS_PLATFORM=$(sibs platform)
	dobin "video_player/sibs-build/${SIBS_PLATFORM}/release/quickmedia-video-player"
	dobin "sibs-build/${SIBS_PLATFORM}/release/quickmedia"
	newbin "sibs-build/${SIBS_PLATFORM}/release/quickmedia" qm

	insinto /usr/share/quickmedia
	doins boards.json
	doins -r mpv/*
	doins -r {images,icons,shaders,themes}

	insinto /usr/share/applications
	for file in launcher/*; do
		doins "$file"
	done
}
