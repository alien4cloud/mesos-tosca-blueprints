#!/bin/bash -e

# Starts zookeeper
# sudo -E nohup bin/zkserver.sh >/dev/null 2>&1 &
sudo service zookeeper restart

# Put together the zk url
zkURL="zk://"
IFS=','
for inst in $INSTANCES
do
    host="${inst}_IP"
    zkURL="$zkURL${!host}:2181,"
done
zkURL="${zkURL%?}/mesos"
# Quorum for replicated log must be a majority of masters
quorum=$((1 + $(echo $INSTANCES | tr "," " " | wc -w)/2))

# Starts a mesos Master
echo "Starting mesos master..."
source ~/mesos_install/mesos_env.sh

echo "sudo -E nohup mesos-master --zk=${zkURL} --quorum=${quorum} >/dev/null 2>~/mesos_install/err.log &"
sudo -E nohup mesos-master --zk=${zkURL} --quorum=${quorum} >/dev/null 2>~/mesos_install/err.log &

sleep 5

# TODO : check if standalone mode and return the IP address - is it necessary considering ZK works fine in SAM ?
export master_url=${zkURL}
ps -ef | grep -v grep | grep mesos-master >/dev/null || exit 1
