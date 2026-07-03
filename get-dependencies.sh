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
    libsndfile     \
    luajit         \
    openal         \
    openvr         \
    p7zip          \
    python         \
    vulkan-headers \
    wine

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package

# If the application needs to be manually built that has to be done down here
git clone --recursive https://github.com/MaSzyna-EU07/maszyna
mkdir -p ./AppDir/bin
cd ./maszyna
mkdir build && cd build
export CXXFLAGS="$CXXFLAGS -Wno-error=format-security"
cmake .. -DCMAKE_BUILD_TYPE=Release -DWITH_BETTER_RENDERER=ON -DWITH_DISCORD_RPC=OFF -DWITH_OPENVR=ON
make -j$(nproc)
mv -v /opt/maszyna/* ./AppDir/bin
