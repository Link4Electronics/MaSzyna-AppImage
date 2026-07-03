#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    asio           \
    cmake          \
    glfw           \
    glm            \
    libserialport  \
    luajit         \
    openal         \
    openvr         \
    vulkan-headers

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of MaSzyna..."
echo "---------------------------------------------------------------"
REPO="https://github.com/MaSzyna-EU07/maszyna"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --recursive "$REPO" ./maszyna
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./maszyna
mkdir build && cd build
export CXXFLAGS="$CXXFLAGS -Wno-error=format-security"
cmake .. -DCMAKE_BUILD_TYPE=Release -DWITH_BETTER_RENDERER=OFF -DWITH_DISCORD_RPC=OFF -DWITH_OPENVR=ON
make -j$(nproc)
mv -v bin/eu07* ../../AppDir/bin/maszyna
