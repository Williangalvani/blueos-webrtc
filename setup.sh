#!/bin/bash

SCRIPTS=$PWD
echo "Installing apt install requisites..."

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
git checkout tags/v0.11.3
sh autogen.sh
./configure --disable-data-channels --disable-rabbitmq --disable-docs --prefix=/opt/janus

make -j15
make install
make configs
