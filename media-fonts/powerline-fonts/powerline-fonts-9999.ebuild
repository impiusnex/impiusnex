# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="A collection of patched fonts for Powerline users"
HOMEPAGE="https://github.com/powerline/fonts"
SRC_URI="https://github.com/powerline/fonts/archive/master.zip -> ${P}.zip"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 ~x86"

IUSE="+3270 AnonymousPro"
RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/fonts-master"
FONT_S=""
FONT_SUFFIX="ttf"

src_prepare() {
	usex 3270 'FONT_S="3270"' ''
	usex AnonymousPro 'FONT_S="${FONT_S} AnonymousPro"' ''
	echo $FONT_S
	src_prepare
}
