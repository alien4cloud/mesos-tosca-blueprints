#!/bin/bash -e

# Stop Aurora service
if [ $OS = 'ubuntu' ]; then
    sudo stop aurora-scheduler
elif [ $OS = 'centos' ]; then
    sudo systemctl stop aurora
else
    exit 1
fi