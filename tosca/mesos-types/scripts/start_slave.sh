#!/bin/sh

# Starts a mesos slave
echo "Starting mesos slave..."
echo "export MESOS_MASTER=${MESOS_MASTER}" >> ~/mesos_install/mesos_env.txt
source ~/mesos_install/mesos_env.txt
sudo -E nohup mesos-slave >~/start-slave.log 2>&1 &