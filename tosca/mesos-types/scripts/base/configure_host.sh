#!/bin/bash -e

# Fix /etc/hosts
sudo cp /etc/hosts /tmp/hosts
echo "${IP}" `hostname` | sudo tee /etc/hosts >/dev/null
cat /tmp/hosts | sudo tee -a /etc/hosts >/dev/null