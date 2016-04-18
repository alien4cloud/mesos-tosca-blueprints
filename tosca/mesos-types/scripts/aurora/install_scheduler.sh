#!/bin/bash -e

echo "Installing aurora..."
if [ $OS -eq "ubuntu" ]; then
    # Install prerequisites
    sudo add-apt-repository -y ppa:openjdk-r/ppa
    sudo apt-get update
    sudo apt-get install -y openjdk-8-jre-headless wget
    sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

    # Install aurora
    wget -c https://apache.bintray.com/aurora/ubuntu-trusty/aurora-scheduler_0.12.0_amd64.deb
    sudo dpkg -i aurora-scheduler_0.12.0_amd64.deb

    # Stop scheduler service an initialize database
    sudo stop aurora-scheduler
    sudo -u aurora mkdir -p /var/lib/aurora/scheduler/db
    sudo -u aurora mesos-log initialize --path=/var/lib/aurora/scheduler/db
elif [ $OS -eq "centos" ]; then
    # Install prerequisites
    sudo rpm -Uvh https://archive.cloudera.com/cdh4/one-click-install/redhat/6/x86_64/cloudera-cdh-4-0.x86_64.rpm
    sudo yum install -y java-1.8.0-openjdk-headless
    sudo yum install -y wget

    # Install aurora
    wget -c https://apache.bintray.com/aurora/centos-7/aurora-scheduler-0.12.0-1.el7.centos.aurora.x86_64.rpm
    sudo yum install -y aurora-scheduler-0.12.0-1.el7.centos.aurora.x86_64.rpm

    # Stop scheduler service an initialize database
    sudo systemctl stop aurora
    sudo -u aurora mkdir -p /var/lib/aurora/scheduler/db
    sudo -u aurora mesos-log initialize --path=/var/lib/aurora/scheduler/db
else
    echo "$OS is not supported ATM. Exiting now." && exit 1
fi
echo "Aurora successfully installed" && exit 0