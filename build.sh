#!/bin/sh
# @file build.sh
# @author Daniel Starke
# @copyright Copyright 2020 Daniel Starke
# @date 2020-03-26
# @version 2020-07-28

function ExitError() {
   echo "Error: ${*}" >&2
   exit 1
}

# adjust build environment
export KBUILD_BUILD_USER="Daniel Starke"
export KBUILD_BUILD_HOST="STIMUD"
GCC_VERSION="9.3.0" # needs an entry in package/gcc/gcc.hash
unset PERL_MM_OPT

BOARD_REV="A" # STIMUD board revision
BUILD_ALL=0
while [ $# -gt 0 ]; do
	case "x${1}" in
	'x-b'|'x--build')
		BUILD_ALL=1
		;;
	'x-h'|'x--help')
		cat << "EOF"
build.sh -hr?u

-h, --help
    Prints out this help.
-r, --revision <string>
    Performs the build for the specific board revision.
    This defaults to "A".
-b, --build
    Perform a complete build.
    Default is a minimal build if build/output/target exists.
EOF
		exit 0
		;;
	'x-r'|'x--revision')
		[ $# -lt 2 ] && ExitError "Missing argument for ${1}."
		case "x${2}" in
		x[ABC])
			BOARD_REV="${2}"
			;;
		*)
			ExitError "Invalid argument given for ${1} (\"${2}\")."
			;;
		esac
		shift 1
		;;
	*)
		ExitError "Unknown command-line argument \"${1}\"."
		;;
	esac
	shift 1
done

START_SED=""
case "${BOARD_REV}" in
'A')
	START_SED="$(cat <<-EOF | tr -d '\n\r'
s/BOARD_REV=.*/BOARD_REV="${BOARD_REV}"/g;
s/SWC=.*/SWC=192/g;
s/SW1=.*/SW1=193/g;
s/SW2=.*/SW2=194/g;
s/SW4=.*/SW4=195/g;
s/SW8=.*/SW8=196/g
EOF
)"
	;;
'B')
	START_SED="$(cat <<-EOF | tr -d '\n\r'
s/BOARD_REV=.*/BOARD_REV="${BOARD_REV}"/g;
s/SWC=.*/SWC=129/g;
s/SW1=.*/SW1=128/g;
s/SW2=.*/SW2=148/g;
s/SW4=.*/SW4=34/g;
s/SW8=.*/SW8=35/g
EOF
)"
	;;
'C')
	START_SED="$(cat <<-EOF | tr -d '\n\r'
s/BOARD_REV=.*/BOARD_REV="${BOARD_REV}"/g;
s/SWC=.*/SWC=32/g;
s/SW1=.*/SW1=33/g;
s/SW2=.*/SW2=36/g;
s/SW4=.*/SW4=37/g;
s/SW8=.*/SW8=38/g
EOF
)"
	;;
*)
	ExitError "Invalid board revision \"${BOARD_REV}\" configured."
	;;
esac

echo "Building image for STIMUD REV ${BOARD_REV}..."

[ ! -d build/output/target ] && BUILD_ALL=1
if [ "${BUILD_ALL}" -eq 1 ]; then
   # get source
   if [ ! -d build ]; then
      git clone -b 2020.02 --single-branch https://github.com/buildroot/buildroot.git build || ExitError "Failed to clone buildroot repository."
   fi
   cd build || ExitError "Failed to change directory into build."
   git pull || ExitError "Failed to update buildroot repository."
   cp -f ../board/* board/licheepi/ || ExitError "Failed to customize buildroot target image configuration."
   echo -e '\n# From ftp://gcc.gnu.org/pub/gcc/releases/gcc-9.3.0/sha512.sum\nsha512  4b9e3639eef6e623747a22c37a904b4750c93b6da77cf3958d5047e9b5ebddb7eebe091cc16ca0a227c0ecbd2bf3b984b221130f269a97ee4cc18f9cf6c444de  gcc-9.3.0.tar.xz' >> package/gcc/gcc.hash

   # load build configuration
   make licheepi_zero_defconfig BR2_GCC_VERSION="${GCC_VERSION}" || ExitError "Failed to load initial buildroot configuration."
   cp ../configs/buildroot.config .config || ExitError "Failed to customize buildroot configuration."
   sed -i 's/9\.2\.0/9\.3\.0/g' package/gcc/Config.in.host || ExitError "Failed"

   # build everything from scratch
   make clean BR2_GCC_VERSION="${GCC_VERSION}"
   make source BR2_GCC_VERSION="${GCC_VERSION}" || ExitError "Failed to download source code packages."
   make -j4 BR2_GCC_VERSION="${GCC_VERSION}" || ExitError "Failed to build everything."
else
   cd build || ExitError "Failed to change directory into build."
fi

# patch rootfs
output/host/bin/arm-buildroot-linux-uclibcgnueabihf-gcc -Wall -Wextra -Wformat -pedantic -Wshadow -DNDEBUG -fno-ident -s -O2 -o output/target/root/stimud-gpio ../src/stimud-gpio.c || ExitError "Failed to build STIMUD GPIO helper."
sed "${START_SED}" < ../src/start.sh > output/target/root/start.sh || ExitError "Failed to install STIMUD start script."
chmod 755 output/target/root/start.sh || ExitError "Failed to set permissions for STIMUD start script."
cp ../src/stimud.sh output/target/root || ExitError "Failed to install STIMUD script."
chmod 755 output/target/root/stimud.sh || ExitError "Failed to set permissions for STIMUD script."
cp ../src/stimud.cfg output/target/root || ExitError "Failed to install STIMUD default configuration."
if ! grep "start.sh" -q output/target/etc/inittab; then
   sed -i '/rcS/a \\n::sysinit:/root/start.sh' output/target/etc/inittab || ExitError "Failed to register STIMUD start script."
fi

# build final image
make -j4 BR2_GCC_VERSION="${GCC_VERSION}" || ExitError "Failed to build final image."
