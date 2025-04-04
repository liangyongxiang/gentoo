# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools

if [[ ${PV} = *9999* ]]; then
	scm_eclass=git-r3
	EGIT_REPO_URI="https://github.com/Becksteinlab/${PN}.git"
	EGIT_BRANCH="develop"
else
	scm_eclass=vcs-snapshot
	SRC_URI="https://github.com/Becksteinlab/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit distutils-r1 ${scm_eclass}

DESCRIPTION="Python framework for Gromacs"
HOMEPAGE="https://gromacswrapper.readthedocs.io"

LICENSE="GPL-3 LGPL-3"
SLOT="0"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	sci-libs/numkit[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	test? ( >=dev-python/pandas-0.17[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest
