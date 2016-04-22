#!/bin/bash -e

# Starts a mesos slave
echo "Starting mesos slave..."
source ~/mesos_install/mesos_env.sh
sudo -E nohup mesos-slave --master="${MESOS_MASTER}" >/dev/null 2>&1 &

sleep 5
ps -ef | grep -v grep | grep mesos-slave >/dev/null || ( echo "Failed to start slave"; exit 1)

