#!/usr/bin/env bash

# Download latest Mesos release
wget http://www.apache.org/dist/mesos/0.27.2/mesos-0.27.2.tar.gz
tar -zxf mesos-0.27.2.tar.gz

# Build
cd mesos-0.27.2
mkdir build
cd build
../configure
make V=0

# Tests
make check

# Install
make install

# Clean

rm -f ~/mesos_install.tar.gz
rm -rf ~/scripts




