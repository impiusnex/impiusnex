# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A lightweight decompression library with support for rar, tar and zip archives"
HOMEPAGE="http://github.com/selmf/unarr"

SRC_URI="https://github.com/selmf/unarr/archive/master.zip -> ${P}.zip"
KEYWORDS="amd64"

LICENSE="LGPL-3"
SLOT="0"
IUSE=""

DEPEND="
	sys-libs/zlib
	app-arch/bzip2
	app-arch/xz-utils
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/unarr-master"

src_configure () {
	local mycmakeargs=(
		-DENABLE_7Z=ON
	)
	cmake-utils_src_configure
}
