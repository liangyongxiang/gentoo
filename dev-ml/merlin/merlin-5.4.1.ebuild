# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: vim-plugin, although it's not clear how to make it work here
inherit elisp-common dune edo

DESCRIPTION="Context sensitive completion for OCaml in Vim and Emacs"
HOMEPAGE="https://github.com/ocaml/merlin/"
SRC_URI="
	https://github.com/ocaml/merlin/archive/refs/tags/v${PV}-503.tar.gz
		-> ${P}-503.gh.tar.gz
"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="emacs +ocamlopt test"

# Tests fail unexpectedly on Tinderbox. See https://bugs.gentoo.org/933857
# RESTRICT="!test? ( test )"
RESTRICT="test"

RDEPEND="
	>=dev-lang/ocaml-5.3.0 <dev-lang/ocaml-5.4.0
	dev-ml/csexp:=
	dev-ml/menhir:=
	dev-ml/yojson:=
	emacs? (
		>=app-editors/emacs-23.1:*
		app-emacs/auto-complete
		app-emacs/company-mode
	)
"
DEPEND="
	${RDEPEND}
"
# NOTICE: Block dev-ml/seq (which is a back-port of code to ocaml <4.07)
# because it breaks merlin builds.
# https://github.com/ocaml/merlin/issues/1500
BDEPEND="
	!!<dev-ml/seq-0.3
	dev-ml/findlib
	test? (
		app-misc/jq
		dev-ml/alcotest
	)
"

SITEFILE="50${PN}-gentoo.el"

src_unpack() {
	default

	if has_version "=dev-lang/ocaml-5.3*" ; then
		edo mv "${P}-503" "${S}"
	else
		die "The installed version of OCaml is not yet supported"
	fi
}

src_prepare() {
	default

	# Handle ELisp installation via the Emacs Eclass.
	rm emacs/dune || die

	# This test runs only inside a git repo,
	# it is not included in merlin release for ocaml 4.12.
	if [[ -f tests/test-dirs/occurrences/issue1404.t ]] ; then
		rm tests/test-dirs/occurrences/issue1404.t || die
	fi
	rm -r tests/test-dirs/locate/context-detection/cd-mod_constr.t || die

	# Remove seq references from dune build files.
	sed -i 's|seq||g' src/frontend/ocamlmerlin/dune || die

	# Remove Menhir requirement.
	# > MenhirLib.StaticVersion.require_20201216
	sed -i src/ocaml/preprocess/parser_raw.ml \
		-e "s|MenhirLib.StaticVersion.require_.*|()|g" \
		|| die
}

src_compile() {
	dune_src_compile

	if use emacs ; then
		# iedit isn't packaged yet
		rm emacs/merlin-iedit.el || die

		local -x BYTECOMPFLAGS="-L emacs"
		elisp-compile ./emacs/*.el
	fi
}

src_install() {
	dune_src_install

	if use emacs ; then
		elisp-install "${PN}" ./emacs/*.el{,c}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
