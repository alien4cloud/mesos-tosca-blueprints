#!/bin/bash

# Fix /etc/hosts
sudo cp /etc/hosts /tmp/hosts
echo ${IP} | sudo tee /etc/hosts >/dev/null
cat  /tmp/hosts | sudo tee -a /etc/hosts > /dev/null