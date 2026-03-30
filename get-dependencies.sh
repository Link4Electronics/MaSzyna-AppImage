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

echo "Building MaSzyna..."
echo "---------------------------------------------------------------"
REPO="https://github.com/MaSzyna-EU07/maszyna"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --recursive "$REPO" ./maszyna
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
#export CXXFLAGS="$CXXFLAGS -Wno-error=format-security"
cmake -S ./maszyna -B build -DCMAKE_BUILD_TYPE=Release -DWITH_BETTER_RENDERER=OFF -DWITH_DISCORD_RPC=OFF -DWITH_OPENVR=ON
cmake --build build -j$(nproc)
mv -v build/bin/eu07* ./AppDir/bin/maszyna
