#!/bin/bash -e

echo "Installing aurora..."
if [ $OS = 'ubuntu' ]; then

    # Request apt lock
    NAME="Aurora Scheduler"
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

    # Install prerequisites - Java 8
    sudo add-apt-repository -y ppa:openjdk-r/ppa
    sudo apt-get update
    sudo apt-get install -y openjdk-8-jre-headless wget
    sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

    # Install aurora
    sudo wget -c https://apache.bintray.com/aurora/ubuntu-trusty/aurora-scheduler_0.12.0_amd64.deb
    sudo dpkg -i aurora-scheduler_0.12.0_amd64.deb # TODO : Aurora version

    # Stop scheduler service an initialize database
    sudo stop aurora-scheduler
    sudo -u aurora mkdir -p /var/lib/aurora/scheduler/db
    sudo -u aurora mesos-log initialize --path=/var/lib/aurora/scheduler/db

    # Release apt lock
    rm -rf "${LOCK}"
    echo "$NAME released apt lock"
elif [ $OS = 'centos' ]; then
    # Install prerequisites
    sudo rpm -Uvh https://archive.cloudera.com/cdh4/one-click-install/redhat/6/x86_64/cloudera-cdh-4-0.x86_64.rpm
    sudo yum install -y java-1.8.0-openjdk-headless
    sudo yum install -y wget

    # Install aurora
    sudo wget -c https://apache.bintray.com/aurora/centos-7/aurora-scheduler-0.12.0-1.el7.centos.aurora.x86_64.rpm
    sudo yum install -y aurora-scheduler-0.12.0-1.el7.centos.aurora.x86_64.rpm

    # Stop scheduler service an initialize database
    sudo systemctl stop aurora
    sudo -u aurora mkdir -p /var/lib/aurora/scheduler/db
    sudo -u aurora mesos-log initialize --path=/var/lib/aurora/scheduler/db
else
    echo "$OS is not supported ATM. Exiting now." && exit 1
fi
echo "Aurora successfully installed."