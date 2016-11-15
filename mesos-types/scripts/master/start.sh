#!/bin/bash

# Start a mesos Master
echo "Starting mesos master..."

# Start zookeeper
sudo service zookeeper start || sudo service zookeeper-server start
# TODO use the zk binary instead of services : sudo -E nohup pathToZk/bin/zkserver.sh >/dev/null 2>&1 &
sleep 5 # Wait a few secs until ZK is up and running

# Source Mesos environment variables
source ~/mesos_install/mesos_env.sh

# Start master - redirecting inputs and outputs to /dev/null to avoid locking up the shell. Logs can be found inside $MESOS_LOG directory (default : var/log/mesos)
sudo -E nohup mesos-master 0</dev/null &>/dev/null &
sleep 10

ps -ef | grep -v grep | grep mesos-master >/dev/null || (echo "Failed to start master"; exit 1)
