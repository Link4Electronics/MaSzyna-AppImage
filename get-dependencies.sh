#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake          \
    glfw           \
    libserialport  \
    luajit         \
    openvr         \
    vulkan-headers

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
PRE_BUILD_CMDS='sed -i "/^check() {/,/^}/d" ./PKGBUILD' make-aur-package openssl-1.1
PRE_BUILD_CMDS='sed -i "/^check() {/,/^}$/d" ./PKGBUILD' make-aur-package python2
PRE_BUILD_CMDS='sed -i "s|INSTALL_DIR='\''/opt/maszyna'\''|INSTALL_DIR='\''\$APPDIR/bin'\''|g" ./maszyna.sh' make-aur-package maszyna-git

# If the application needs to be manually built that has to be done down here
mkdir -p ./AppDir/bin
mv -v /opt/maszyna/* ./AppDir/bin
