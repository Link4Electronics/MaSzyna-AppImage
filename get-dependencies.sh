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
    harfbuzz       \
    libserialport  \
    luajit         \
    openal         \
    openvr         \
    skia-sharp     \
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
mv -v build/bin/eu07* ./AppDir/bin/eu07

# Download and bundle StarterNG (NativeAOT Linux x64)
wget -q https://github.com/MaSzyna-EU07/StarterNG/releases/download/latest/StarterNG-linux-x64.tar.gz -O StarterNG.tar.gz
tar -xzf StarterNG.tar.gz
rm -f ./*.tar.gz ./*.dbg

mv Starter ./AppDir/bin/Starter
mv libSkiaSharp.so ./AppDir/bin/libSkiaSharp.so
mv libHarfBuzzSharp.so ./AppDir/bin/libHarfBuzzSharp.so
mv startercfg ./AppDir/bin/startercfg
