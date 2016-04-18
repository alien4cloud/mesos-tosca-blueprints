#!/bin/bash -e

if [ $OS -eq "ubuntu" ]; then
    sudo start aurora-scheduler
elif [ $OS -eq "centos" ]; then
    sudo systemctl start aurora
else
    exit 1
fi
exit 0