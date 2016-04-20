#!/bin/bash -e

# Config ZK
sudo cp ${zoo_config} /etc/zookeeper/conf/zoo.cfg

zkURL="zk://"
i=1 # counter
IFS=',' # separator
for inst in $INSTANCES
do
    # Put together the zk url and the zoo.cfg file
    zkHost="${inst}_IP"
    zkURL="$zkURL${!zkHost}:2181,"
    echo "server.${i}=${!zkHost}:2888:3888" | sudo tee -a /etc/zookeeper/conf/zoo.cfg >/dev/null

    # Assign each node a unique id
    [ $inst == $INSTANCE ] && (echo $i | sudo tee /var/lib/zookeeper/myid >/dev/null)
    i=$((i+1))
done
zkURL="${zkURL%?}/mesos"
# Quorum for replicated log must be a majority of masters
quorum=$((1 + $(echo $INSTANCES | tr "," " " | wc -w)/2))

# Starts zookeeper
sudo service zookeeper restart # TODO use the zk binary instead of mesosphere services : sudo -E nohup bin/zkserver.sh >/dev/null 2>&1 &
sleep 5

# Starts a mesos Master
echo "Starting mesos master..."
source ~/mesos_install/mesos_env.sh

echo "sudo -E nohup mesos-master --zk=${zkURL} --quorum=${quorum} >/dev/null 2>~/mesos_install/err.log &"
sudo -E nohup mesos-master --zk=${zkURL} --quorum=${quorum} >/dev/null 2>~/mesos_install/err.log &
sleep 5

export master_url=${zkURL}
ps -ef | grep -v grep | grep mesos-master >/dev/null || exit 1