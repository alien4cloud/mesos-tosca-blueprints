#!/bin/bash -e
# setup mesos-dns
sudo mkdir /usr/local/mesos-dns/
sudo curl -sSL -o /usr/local/mesos-dns/mesos-dns https://github.com/mesosphere/mesos-dns/releases/download/v0.5.1/mesos-dns-v0.5.1-linux-amd64
sudo chmod +x /usr/local/mesos-dns/mesos-dns
