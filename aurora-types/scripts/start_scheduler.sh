#!/bin/bash -e

# Start Aurora service
if [ $OS = 'ubuntu' ]; then
    sudo start aurora-scheduler
elif [ $OS = 'centos' ]; then
    sudo systemctl start aurora
else
    exit 1
fi