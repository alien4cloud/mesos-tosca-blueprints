#!/bin/bash -e


echo "Starting mesos slave..."
# Source Mesos environment variables
source ~/mesos_install/mesos_env.sh

# Start a mesos slave
sudo -E nohup mesos-slave >/dev/null 2>&1 &

sleep 5
ps -ef | grep -v grep | grep mesos-slave >/dev/null || ( echo "Failed to start slave"; exit 1)
