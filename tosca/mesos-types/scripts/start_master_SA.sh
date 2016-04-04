#!/bin/sh

# Starts a mesos Master in stand-alone mode
echo "Starting mesos master..."
source mesos_env.txt
sudo -E nohup mesos-master >~/start-master.log 2>&1 &