#!/usr/bin/env bash

# Add mesosphere pkg repo
sudo rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm

# Install kernel
sudo yum -y install mesos

# Disable master service
sudo systemctl stop mesos-master.service
sudo systemctl disable mesos-master.service
exit 0
