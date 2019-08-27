# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit

DESCRIPTION="Pixar Animation Studios USD - Universal Scene Description"
HOMEPAGE="https://github.com/PixarAnimationStudios/USD"
SRC_URI="https://github.com/PixarAnimationStudios/USD/archive/v19.07.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE="+tests +docs +python +ptex embree prman +opencolorio +openimageio alembic hdf5 +materialx maya katana houdini"

# openimageio and opencolorio provided by the 'cg' overlay
# pyside provided by 'waebbl' overlay (tested) and 'cg' overlay
# pyside-tools provided by 'waebbl' overlay
# embree provided by 'cg' and 'waebbl' overlays

RDEPEND="
	docs? ( app-doc/doxygen
			media-gfx/graphviz )
	>=dev-python/pyopengl-3.1.0
	>=media-libs/opensubdiv-3.0.5
	>=media-libs/openexr-2.2.0
	>=dev-python/pyside-1.2.2
	>=dev-python/pyside-tools-1.2.2
	>=media-libs/glew-2.0.0
	openimageio? ( >=media-libs/openimageio-1.5.11 )
	opencolorio? ( >=media-libs/opencolorio-1.0.9 )
	>=media-libs/osl-1.5.12
	ptex? ( >=media-libs/ptex-2.0.30 )
	embree? ( media-libs/embree )
	alembic? ( media-gfx/alembic[hdf5?] )
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/USD-19.07"

src_compile(){
	local myconf="
		 $(usex tests "--tests" "--no-tests") \
		 $(usex docs "--docs" "--no-docs") \
		 $(usex python "--python" "--no-python") \
		 $(usex ptex "--ptex" "--no-ptex") \
		 $(usex embree "--embre" "--no-embree") \
		 $(usex embree "--embree-location EMBREE_LOCATION" "") \
		 $(usex prman "--prman" "--no-prman") \
		 $(usex prman "--prman-location PRMAN_LOCATION" "") \
		 $(usex opencolorio "--opencolorio" "--no-opencolorio") \
		 $(usex openimageio "--openimageio" "--no-openimageio") \
		 $(usex alembic "--alembic" "--no-alembic") \
		 $(usex hdf5 "--hdf5" "--no-hdf5") \
		 $(usex materialx "--materialx" "--no-materialx") \
		 $(usex maya "--maya" "--no-maya") \
		 $(usex maya "--maya-location MAYA_LOCATION" "") \
		 $(usex katana "--katana" "--no-katana") \
		 $(usex katana "--katana-api-location KATANA_API_LOCATION" "") \
		 $(usex houdini "--houdini" "--no-houdini") \
		 $(usex houdini "--houdini-location HOUDINI_LOCATION" "")
"
	echo $myconf
	python2.7 ${S}/build_scripts/build_usd.py /usr/local/USD $myconf
}

# usage: build_usd.py [-h] [-n] [-v | -q] [-j JOBS] [--build BUILD]
#                     [--build-args [BUILD_ARGS [BUILD_ARGS ...]]]
#                     [--force FORCE_BUILD] [--force-all]
#                     [--generator GENERATOR] [--src SRC] [--inst INST]
#                     [--build-shared | --build-monolithic] [--debug]
#                     [--tests | --no-tests] [--docs | --no-docs]
#                     [--python | --no-python]
#                     [--imaging | --usd-imaging | --no-imaging]
#                     [--ptex | --no-ptex] [--usdview | --no-usdview]
#                     [--embree | --no-embree]
#                     [--embree-location EMBREE_LOCATION] [--prman | --no-prman]
#                     [--prman-location PRMAN_LOCATION]
#                     [--openimageio | --no-openimageio]
#                     [--opencolorio | --no-opencolorio]
#                     [--alembic | --no-alembic] [--hdf5 | --no-hdf5]
#                     [--materialx | --no-materialx] [--maya | --no-maya]
#                     [--maya-location MAYA_LOCATION] [--katana | --no-katana]
#                     [--katana-api-location KATANA_API_LOCATION]
#                     [--houdini | --no-houdini]
#                     [--houdini-location HOUDINI_LOCATION]
#                     install_dir

# Installation Script for USD

# Builds and installs USD and 3rd-party dependencies to specified location.

# - Libraries:
# The following is a list of libraries that this script will download and build
# as needed. These names can be used to identify libraries for various script
# options, like --force or --build-args.

# Alembic GLEW HDF5 JPEG MaterialX OpenColorIO OpenEXR OpenImageIO OpenSubdiv PNG Ptex TBB TIFF USD boost zlib

# - Downloading Libraries:
# If curl or powershell (on Windows) are installed and located in PATH, they
# will be used to download dependencies. Otherwise, a built-in downloader will
# be used.

# - Specifying Custom Build Arguments:
# Users may specify custom build arguments for libraries using the --build-args
# option. This values for this option must take the form <library name>,<option>.
# For example:

# build_usd.py --build-args boost,cxxflags=... USD,-DPXR_STRICT_BUILD_MODE=ON ...
# build_usd.py --build-args USD,"-DPXR_STRICT_BUILD_MODE=ON -DPXR_HEADLESS_TEST_MODE=ON" ...

# These arguments will be passed directly to the build system for the specified
# library. Multiple quotes may be needed to ensure arguments are passed on
# exactly as desired. Users must ensure these arguments are suitable for the
# specified library and do not conflict with other options, otherwise build
# errors may occur.

# - Python Versions and DCC Plugins:
# Some DCCs (most notably, Maya) may ship with and run using their own version of
# Python. In that case, it is important that USD and the plugins for that DCC are
# built using the DCC's version of Python and not the system version. This can be
# done by running build_usd.py using the DCC's version of Python.

# For example, to build USD and the Maya plugins on macOS for Maya 2019, run:

# /Applications/Autodesk/maya2019/Maya.app/Contents/bin/mayapy build_usd.py --maya --no-usdview ...

# Note that this is primarily an issue on macOS, where a DCC's version of Python
# is likely to conflict with the version provided by the system. On other
# platforms, build_usd.py *should* be run using the system Python and *should not*
# be run using the DCC's Python.

# positional arguments:
#   install_dir           Directory where USD will be installed

# optional arguments:
#   -h, --help            show this help message and exit
#   -n, --dry_run         Only summarize what would happen
#   -v, --verbose         Increase verbosity level (1-3)
#   -q, --quiet           Suppress all output except for error messages

# Build Options:
#   -j JOBS, --jobs JOBS  Number of build jobs to run in parallel. (default: #
#                         of processors [8])
#   --build BUILD         Build directory for USD and 3rd-party dependencies
#                         (default: <install_dir>/build)
#   --build-args [BUILD_ARGS [BUILD_ARGS ...]]
#                         Custom arguments to pass to build system when building
#                         libraries (see docs above)
#   --force FORCE_BUILD   Force download and build of specified library (see
#                         docs above)
#   --force-all           Force download and build of all libraries
#   --generator GENERATOR
#                         CMake generator to use when building libraries with
#                         cmake

# 3rd Party Dependency Build Options:
#   --src SRC             Directory where dependencies will be downloaded
#                         (default: <install_dir>/src)
#   --inst INST           Directory where dependencies will be installed
#                         (default: <install_dir>)

# USD Options:
#   --build-shared        Build individual shared libraries (default)
#   --build-monolithic    Build a single monolithic shared library
#   --debug               Build with debugging information
#   --tests               Build unit tests
#   --no-tests            Do not build unit tests (default)
#   --docs                Build documentation
#   --no-docs             Do not build documentation (default)
#   --python              Build python based components (default)
#   --no-python           Do not build python based components

# Imaging and USD Imaging Options:
#   --imaging             Build imaging component
#   --usd-imaging         Build imaging and USD imaging components (default)
#   --no-imaging          Do not build imaging or USD imaging components
#   --ptex                Enable Ptex support in imaging
#   --no-ptex             Disable Ptex support in imaging (default)
#   --usdview             Build usdview (default)
#   --no-usdview          Do not build usdview

# Imaging Plugin Options:
#   --embree              Build Embree sample imaging plugin
#   --no-embree           Do not build Embree sample imaging plugin (default)
#   --embree-location EMBREE_LOCATION
#                         Directory where Embree is installed.
#   --prman               Build Pixar's RenderMan imaging plugin
#   --no-prman            Do not build Pixar's RenderMan imaging plugin
#                         (default)
#   --prman-location PRMAN_LOCATION
#                         Directory where Pixar's RenderMan is installed.
#   --openimageio         Build OpenImageIO plugin for USD
#   --no-openimageio      Do not build OpenImageIO plugin for USD (default)
#   --opencolorio         Build OpenColorIO plugin for USD
#   --no-opencolorio      Do not build OpenColorIO plugin for USD (default)

# Alembic Plugin Options:
#   --alembic             Build Alembic plugin for USD
#   --no-alembic          Do not build Alembic plugin for USD (default)
#   --hdf5                Enable HDF5 support in the Alembic plugin
#   --no-hdf5             Disable HDF5 support in the Alembic plugin (default)

# MaterialX Plugin Options:
#   --materialx           Build MaterialX plugin for USD
#   --no-materialx        Do not build MaterialX plugin for USD (default)

# Maya Plugin Options:
#   --maya                Build Maya plugin for USD
#   --no-maya             Do not build Maya plugin for USD (default)
#   --maya-location MAYA_LOCATION
#                         Directory where Maya is installed.

# Katana Plugin Options:
#   --katana              Build Katana plugin for USD
#   --no-katana           Do not build Katana plugin for USD (default)
#   --katana-api-location KATANA_API_LOCATION
#                         Directory where the Katana SDK is installed.

# Houdini Plugin Options:
#   --houdini             Build Houdini plugin for USD
#   --no-houdini          Do not build Houdini plugin for USD (default)
#   --houdini-location HOUDINI_LOCATION
#                         Directory where Houdini is installed.
