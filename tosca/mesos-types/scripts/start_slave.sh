#!/bin/bash -e

# Starts a mesos slave
echo "Starting mesos slave..."
echo "export MESOS_MASTER=${MESOS_MASTER}" >> ~/mesos_install/mesos_env.txt
source ~/mesos_install/mesos_env.txt
sudo -E nohup mesos-slave >~/start-slave.log 2>&1 &

sleep 5
if [ $? = 0 ]; then
    echo "Slave started"
else
    exit 1
fi