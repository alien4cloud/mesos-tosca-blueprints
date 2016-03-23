#!/usr/bin/env bash

awk -v key=data/adrian.pem '{ system("ssh -tt -i "key" centos@"$0" sudo service mesos-slave restart") }' data/slaves_ip