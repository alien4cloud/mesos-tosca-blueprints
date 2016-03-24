#!/usr/bin/env bash

# Add mesosphere pkg repo
sudo rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm

# Install kernel
sudo yum -y install mesos marathon
sudo yum -y install mesosphere-zookeeper

# Disable slave service
sudo service mesos-slave stop
sudo systemctl disable mesos-slave.service
exit 0
