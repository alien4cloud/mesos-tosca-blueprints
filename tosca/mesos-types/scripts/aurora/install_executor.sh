#!/bin/bash -e

if [ $OS -eq "ubuntu" ]; then
    sudo apt-get install -y python2.7 wget

    # NOTE: This appears to be a missing dependency of the mesos deb package and is needed
    # for the python mesos native bindings.
    sudo apt-get -y install libcurl4-nss-dev

    wget -c https://apache.bintray.com/aurora/ubuntu-trusty/aurora-executor_0.12.0_amd64.deb
    sudo dpkg -i aurora-executor_0.12.0_amd64.deb
elif [ $OS -eq "centos" ]; then
    sudo yum install -y python2 wget

    wget -c https://apache.bintray.com/aurora/centos-7/aurora-executor-0.12.0-1.el7.centos.aurora.x86_64.rpm
    sudo yum install -y aurora-executor-0.12.0-1.el7.centos.aurora.x86_64.rpm
else
    echo "$OS is not supported by AURORA at the moment. Exiting now." && exit 1
fi
exit 0