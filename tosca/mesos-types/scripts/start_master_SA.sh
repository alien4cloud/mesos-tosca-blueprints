#!/bin/sh

# Starts a mesos Master in stand-alone mode
echo "Starting mesos master..."
sudo -E nohup mesos-master >/dev/null 2>&1 &