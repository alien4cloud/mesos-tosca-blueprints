#!/bin/bash -e

# Starts zookeeper
# sudo -E nohup bin/zkserver.sh >/dev/null 2>&1 &
sudo service zookeeper restart

# Put together the zk url
zkURL="zk://"
while IFS=',' read inst; do
    host=eval "echo \$$inst$IP"
    echo "... ${inst} : ${IP}"
    zkURL="$zkURL$host:2181,"
done < <(echo $INSTANCES)
# Remove the last comma and add mesos path
zkURL="${zkURL%?}/mesos"

# Starts a mesos Master
echo "Starting mesos master..."
source ~/mesos_install/mesos_env.sh
sudo -E nohup mesos-master --zk=${zkURL} >/dev/null 2>&1 &

sleep 5

# TODO : check if standalone mode and return the IP address
export master_url=${zkURL}
ps -ef | grep -v grep | grep mesos-master >/dev/null || exit 1
