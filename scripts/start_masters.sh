#!/usr/bin/env bash

# start mesos-masters and marathon roughly at the same time
awk -v key=data/adrian.pem '{ system("ssh -tt -i "key" centos@"$0" sudo service mesos-master restart") }' data/masters_ip
awk -v key=data/adrian.pem '{ system("ssh -tt -i "key" centos@"$0" sudo service marathon restart") }' data/masters_ip