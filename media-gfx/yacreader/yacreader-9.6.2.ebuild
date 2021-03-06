# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils eutils fdo-mime

DESCRIPTION="A comic reader for cross-platform reading and managing your digital comic collection"
HOMEPAGE="http://www.yacreader.com"

if [[ ${PV} == 9999 ]];then
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/YACReader/${PN}.git"
else
	SRC_URI="https://github.com/YACReader/${PN}/archive/${PV}.tar.gz"
	KEYWORDS="~x86 ~amd64 ~arm"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="rar zip lha pdf qrcode"

DEPEND="
	app-arch/unarr
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtimageformats:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtscript:5
	dev-qt/qtsql:5[sqlite]
	dev-util/desktop-file-utils
	lha? ( app-arch/lha )
	pdf? ( app-text/poppler[qt5] )
	qrcode? ( media-gfx/qrencode )
	rar? ( app-arch/unrar )
	virtual/glu
	zip? ( app-arch/unzip )
"
RDEPEND="${DEPEND}"

src_configure(){
	eqmake5 YACReader.pro
}

src_install(){
	emake INSTALL_ROOT="${D}" install
}

pkg_postinst(){
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
	echo
	elog "Additional packages are required to open the most common comic archives:"
	elog
	elog "	cbr: app-arch/unrar"
	elog "	cbz: app-arch/unzip"
	elog
	elog "You can also add support for LHA files by installing app-arch/lha."
	elog "Also, if you want to add QR codes support, you can do it by"
	elog "installing media-gfx/qrencode"
	echo
}

pkg_postrm(){
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}
