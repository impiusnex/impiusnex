# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils xdg-utils

DESCRIPTION="XnView MP image viewer/converter"
HOMEPAGE="http://www.xnview.com/"
SRC_URI="http://download.xnview.com/old_versions/XnViewMP-0931-linux-x64.tgz"

SLOT="0"
LICENSE="freedist XnView"
KEYWORDS="~amd64"
IUSE=""



RDEPEND=">=dev-libs/glib-2
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXt
	"

DEPEND=""

RESTRICT="strip mirror"
S="${WORKDIR}/XnView"

src_prepare() {
	default
}

src_install() {
	declare XNVIEW_HOME=/opt/XnView

	# Install XnView in /opt
	dodir ${XNVIEW_HOME%/*}
	mv "${S}" "${D}"${XNVIEW_HOME} || die "Unable to install XnView folder"

	# Create /opt/bin/xnview
	dodir /opt/bin/
	dosym ${XNVIEW_HOME}/xnview.sh /opt/bin/xnview

	# Install icon and .desktop for menu entry
	newicon "${D}"${XNVIEW_HOME}/xnview.png ${PN}.png
	make_desktop_entry xnview XnViewMP ${PN} "Graphics" || die "desktop file sed failed"
}

pkg_postinst(){
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
