#!/bin/bash -e

if [ -f /etc/resolvconf/resolv.conf.d/head ]; then
  sudo sed -i "2s/^/nameserver ${DNS_IP}\n /" /etc/resolvconf/resolv.conf.d/head
  sudo resolvconf -u
else
  sudo sed -i "2s/^/nameserver ${DNS_IP}\n /" /etc/resolv.conf
fi
