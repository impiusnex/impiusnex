# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_7 )

inherit cmake-utils xdg-utils flag-o-matic xdg-utils pax-utils python-single-r1 toolchain-funcs eapi7-ver

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="https://www.blender.org"
SRC_URI="https://download.blender.org/source/${P}.tar.gz"

LICENSE="|| ( GPL-2 BL )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+bullet +dds +elbeem +openexr collada color-management \
		cuda cycles debug doc ffmpeg fftw headless jack jemalloc jpeg2k libav \
		llvm man ndof nls openal openimageio openmp opensubdiv openvdb \
		osl sdl sndfile test tiff valgrind"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
		cuda? ( cycles )
		cycles? ( openexr tiff openimageio )
		osl? ( cycles llvm )"

RDEPEND="${PYTHON_DEPS}
		>=dev-libs/boost-1.62:=[nls?,threads(+)]
		dev-libs/lzo:2
		>=dev-python/numpy-1.10.1[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		media-libs/freetype
		media-libs/glew:*
		media-libs/libpng:0=
		media-libs/libsamplerate
		sys-libs/zlib
		virtual/glu
		virtual/jpeg:0=
		virtual/libintl
		virtual/opengl
		collada? ( >=media-libs/opencollada-1.6.18:= )
		color-management? ( media-libs/opencolorio )
		cuda? ( dev-util/nvidia-cuda-toolkit:= )
		ffmpeg? ( media-video/ffmpeg:=[x264,mp3,encode,theora,jpeg2k?] )
		libav? ( >=media-video/libav-11.3:=[x264,mp3,encode,theora,jpeg2k?] )
		fftw? ( sci-libs/fftw:3.0= )
		!headless? (
				x11-libs/libX11
				x11-libs/libXi
				x11-libs/libXxf86vm
		)
		jack? ( virtual/jack )
		jemalloc? ( dev-libs/jemalloc:= )
		jpeg2k? ( media-libs/openjpeg:0 )
		llvm? ( sys-devel/llvm:= )
		ndof? (
				app-misc/spacenavd
				dev-libs/libspnav
		)
		nls? ( virtual/libiconv )
		openal? ( media-libs/openal )
		openimageio? ( >=media-libs/openimageio-1.7.0 )
		openexr? (
				>=media-libs/ilmbase-2.2.0:=
				>=media-libs/openexr-2.2.0:=
		)
		opensubdiv? ( >=media-libs/opensubdiv-3.3.0:=[cuda?] )
		openvdb? (
				media-gfx/openvdb[-abi3-compat(-),abi4-compat(+)]
				dev-cpp/tbb
				>=dev-libs/c-blosc-1.5.2
		)
		osl? ( media-libs/osl:= )
		sdl? ( media-libs/libsdl2[sound,joystick] )
		sndfile? ( media-libs/libsndfile )
		tiff? ( media-libs/tiff:0 )
		valgrind? ( dev-util/valgrind )"


DEPEND="${RDEPEND}
		>=dev-cpp/eigen-3.2.8:3
		virtual/pkgconfig
		doc? (
				app-doc/doxygen[-nodot(-),dot(+),latex]
				dev-python/sphinx[latex]
		)
		nls? ( sys-devel/gettext )"

BDEPEND=""


src_configure() {
	local mycmakeargs=(
		-DPYTHON_VERSION="${EPYTHON/python/}"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DWITH_INSTALL_PORTABLE=OFF
		-DWITH_PYTHON_INSTALL=OFF
		-DWITH_PYTHON_INSTALL_NUMPY=OFF
		-DWITH_STATIC_LIBS=OFF
		-DWITH_SYSTEM_GLEW=ON
		-DWITH_SYSTEM_EIGEN3=ON
		-DWITH_SYSTEM_LZO=ON
		-DWITH_BOOST=ON
		-DWITH_BULLET=$(usex bullet)
		-DWITH_CODEC_FFMPEG=$(usex ffmpeg)
		-DWITH_CODEC_SNDFILE=$(usex sndfile)
		-DWITH_CUDA=$(usex cuda)
		-DWITH_CYCLES_DEVICE_CUDA=$(usex cuda TRUE FALSE)
		-DWITH_CYCLES=$(usex cycles)
		-DWITH_CYCLES_OSL=$(usex osl)
		-DWITH_LLVM=$(usex llvm)
		-DWITH_FFTW3=$(usex fftw)
		-DWITH_HEADLESS=$(usex headless)
		-DWITH_X11=$(usex !headless)
		-DWITH_IMAGE_DDS=$(usex dds)
		-DWITH_IMAGE_OPENEXR=$(usex openexr)
		-DWITH_IMAGE_OPENJPEG=$(usex jpeg2k)
		-DWITH_IMAGE_TIFF=$(usex tiff)
		-DWITH_INPUT_NDOF=$(usex ndof)
		-DWITH_INTERNATIONAL=$(usex nls)
		-DWITH_JACK=$(usex jack)
		-DWITH_MOD_FLUID=$(usex elbeem)
		-DWITH_MOD_OCEANSIM=$(usex fftw)
		-DWITH_OPENAL=$(usex openal)
		-DWITH_OPENCOLORIO=$(usex color-management)
		-DWITH_OPENCOLLADA=$(usex collada)
		-DWITH_OPENIMAGEIO=$(usex openimageio)
		-DWITH_OPENMP=$(usex openmp)
		-DWITH_OPENSUBDIV=$(usex opensubdiv)
		-DWITH_OPENVDB=$(usex openvdb)
		-DWITH_OPENVDB_BLOSC=$(usex openvdb)
		-DWITH_SDL=$(usex sdl)
		-DWITH_CXX_GUARDEDALLOC=$(usex debug)
		-DWITH_ASSERT_ABORT=$(usex debug)
		-DWITH_GTESTS=$(usex test)
		-DWITH_DOC_MANPAGE=$(usex man)
		-DWITH_MEM_JEMALLOC=$(usex jemalloc)
		-DWITH_MEM_VALGRIND=$(usex valgrind)
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
