# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README"

RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="fattr.rb is a \"fatter attr\" for ruby"
HOMEPAGE="https://github.com/ahoward/fattr"

LICENSE="Ruby-BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

each_ruby_test() {
	${RUBY} test/fattr_test.rb || die "Tests failed."
}

all_ruby_install() {
	all_fakegem_install

	dodoc -r samples
}
