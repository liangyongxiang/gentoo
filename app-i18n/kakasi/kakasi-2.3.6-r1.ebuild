# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools flag-o-matic

DESCRIPTION="Converts Japanese text between kanji, kana, and romaji"
HOMEPAGE="http://kakasi.namazu.org/"
SRC_URI="http://${PN}.namazu.org/stable/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="l10n_ja static-libs"

DOCS=( AUTHORS ChangeLog {,O}NEWS README{,-ja} THANKS TODO doc/{ChangeLog.lib,JISYO,README.lib} )

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.6-configure-clang16.patch
)

src_prepare() {
	default

	# Clang 16 patch
	eautoreconf

	# for gcc-15 (bug #944244)
	append-cflags -std=gnu17
}

src_install() {
	default
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
	use static-libs || find "${ED}" -name '*.a' -delete || die

	if use l10n_ja; then
		iconv -f EUC-JP -t UTF-8 man/${PN}.1.ja > man/${PN}.ja.1
		doman man/${PN}.ja.1
	fi
}
