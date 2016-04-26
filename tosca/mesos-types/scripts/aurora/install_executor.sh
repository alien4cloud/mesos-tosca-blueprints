#!/bin/bash -e

if [ $OS = 'ubuntu' ]; then

    # Request apt lock
    NAME="Aurora Executor"
    LOCK="/tmp/lockaptget"

    while true; do
        if mkdir "${LOCK}" &>/dev/null; then
          echo "$NAME take apt lock"
          break;
        fi
        echo "$NAME waiting apt lock to be released..."
        sleep 0.5
    done

    while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
        echo "$NAME waiting for other software managers to finish..."
        sleep 0.5
    done
    sudo rm -f /var/lib/dpkg/lock

    # Prerequisites
    sudo apt-get -y update || (sleep 15; sudo apt-get update || exit $1)
    sudo apt-get install -y python2.7 wget

    # NOTE: This appears to be a missing dependency of the mesos deb package and is needed
    # for the python mesos native bindings.
    sudo apt-get -y install libcurl4-nss-dev

    sudo wget -c https://apache.bintray.com/aurora/ubuntu-trusty/aurora-executor_0.12.0_amd64.deb
    sudo dpkg -i aurora-executor_0.12.0_amd64.deb

    # Release apt lock
    rm -rf "${LOCK}"
    echo "$NAME released apt lock"
elif [ $OS = 'centos' ]; then
    sudo yum install -y python2 wget

    sudo wget -c https://apache.bintray.com/aurora/centos-7/aurora-executor-0.12.0-1.el7.centos.aurora.x86_64.rpm
    sudo yum install -y aurora-executor-0.12.0-1.el7.centos.aurora.x86_64.rpm
else
    echo "$OS is not supported by AURORA at the moment. Exiting now." && exit 1
fi
exit 0