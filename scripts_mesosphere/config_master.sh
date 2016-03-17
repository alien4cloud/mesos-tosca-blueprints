#!/usr/bin/env bash

# Params from ssh
id=$ARG1
hostname=$ARG2
privateip=$ARG3
quorum=$ARG4


# Copy zk conf files
sudo mv ~/tmp/zk /etc/mesos/zk
sudo mv ~/tmp/zoo.cfg /etc/zookeeper/conf/zoo.cfg

# ID /var/lib/zookeeper/myid
sudo mkdir -p /var/lib/zookeeper; echo ${id} | sudo tee /var/lib/zookeeper/myid

# /etc/mesos-master/hostname /etc/marathon/conf/hostname
sudo mkdir -p /etc/marathon/conf/ && echo ${hostname} | sudo tee /etc/mesos-master/hostname /etc/marathon/conf/hostname

# /etc/mesos-master/quorum
echo ${quorum} | sudo tee /etc/mesos-master/quorum

# /etc/mesos-master/ip
echo ${privateip} | sudo tee /etc/mesos-master/ip

# clean
rm -rf ~/tmp/