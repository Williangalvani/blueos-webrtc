#!/bin/bash
set -e

SCRIPTS=$PWD
echo "Installing apt install requisites..."
BUILD_PACKAGES=(
    libmicrohttpd-dev
    libjansson-dev
	libssl-dev
    libsofia-sip-ua-dev
    libglib2.0-dev
	libopus-dev
    libogg-dev
    libcurl4-openssl-dev
	pkg-config
    gengetopt
    libtool
    automake
    git
    gcc
    make
    libnice-dev
    ninja-build
)

RUNTIME_PACKAGES=(
    libconfig-dev
    libconfig9
    libnice10
    libjansson4
    libcurl4
    libmicrohttpd12
    libogg0
)

apt update
apt install -y --no-install-recommends ${BUILD_PACKAGES[*]}
apt install -y --no-install-recommends ${RUNTIME_PACKAGES[*]}


pip install meson
git clone https://gitlab.freedesktop.org/libnice/libnice.git
cd libnice
#git checkout 0.1.16
meson builddir
ninja -C builddir
ninja -C builddir install

cd /tmp

echo "Installing libsrtp.."
wget https://github.com/cisco/libsrtp/archive/v2.2.0.tar.gz
tar -zxvf v2.2.0.tar.gz
cd libsrtp-2.2.0
./configure --prefix=/usr --enable-openssl
make shared_library -j4 && make install

cd ..

echo "cloning janus..."
git clone https://github.com/meetecho/janus-gateway.git

echo "building janus..."
cd janus-gateway
#git checkout tags/v0.4.4
#git checkout tags/v0.11.3
sh autogen.sh
./configure --disable-data-channels --disable-rabbitmq --disable-docs --prefix=/opt/janus

make -j15
make install
make configs

apt -y remove ${BUILD_PACKAGES[*]}
apt-mark hold ${RUNTIME_PACKAGES[*]}
apt -y autoremove
apt -y clean

rm -r /tmp/*
