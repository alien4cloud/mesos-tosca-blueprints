#!/bin/sh

# Starts a mesos slave
echo "Starting mesos slave..."
sudo -E nohup mesos-slave >/dev/null 2>&1 &