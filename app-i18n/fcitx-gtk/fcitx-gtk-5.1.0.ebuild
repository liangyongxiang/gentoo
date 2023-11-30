# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="fcitx5-gtk"

inherit cmake gnome2-utils xdg

DESCRIPTION="Gtk im module for fcitx5 and glib based dbus client library"
HOMEPAGE="https://github.com/fcitx/fcitx5-gtk"
SRC_URI="https://download.fcitx-im.org/fcitx5/${MY_PN}/${MY_PN}-${PV}.tar.xz -> ${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="gtk2 +gtk3 +gtk4 +introspection +snooper onlyplugin wayland"
REQUIRED_USE="|| ( gtk2 gtk3 gtk4 )"

RDEPEND="
	app-i18n/fcitx:5
	kde-frameworks/extra-cmake-modules:0
	gtk2? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3[wayland?] )
	gtk4? ( gui-libs/gtk:4[wayland?] )
	introspection? ( dev-libs/gobject-introspection )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_GTK2_IM_MODULE=$(usex gtk2)
		-DENABLE_GTK3_IM_MODULE=$(usex gtk3)
		-DENABLE_GTK4_IM_MODULE=$(usex gtk4)
		-DENABLE_SNOOPER=$(usex snooper)
		-DENABLE_GIR=$(usex introspection)
		-DBUILD_ONLY_PLUGIN=$(usex onlyplugin)
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	use gtk2 && gnome2_query_immodules_gtk2
	use gtk3 && gnome2_query_immodules_gtk3
}

pkg_postrm() {
	xdg_pkg_postrm
	use gtk2 && gnome2_query_immodules_gtk2
	use gtk3 && gnome2_query_immodules_gtk3
}
