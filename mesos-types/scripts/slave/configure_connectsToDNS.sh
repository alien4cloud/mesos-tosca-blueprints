#!/bin/bash -e
sudo sed -i "1s/^/nameserver ${DNS_IP}\n /" /etc/resolvconf/resolv.conf.d/head
sudo resolvconf -u
