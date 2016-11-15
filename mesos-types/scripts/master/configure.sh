#!/bin/bash -e

# Config ZK
sudo mkdir -p /var/lib/zookeeper/
sudo chown -R zookeeper /var/lib/zookeeper/
sudo cp ${zoo_config} /etc/zookeeper/conf/zoo.cfg
# If using cloudera's packages run service init
hash zookeeper-server && sudo service zookeeper-server init

# Put together the zk url and the zoo.cfg file
zk_endpoints=""
i=1 # counter
IFS=',' # separator
for inst in $INSTANCES
do
    zkHost="${inst}_MESOS_IP"
    zk_endpoints="${zk_endpoints}${!zkHost}:2181,"

    # Assign each node an unique zookeeper id
    [ $inst == $INSTANCE ] && (echo $i | sudo tee /var/lib/zookeeper/myid >/dev/null)
    echo "server.${i}=${!zkHost}:2888:3888" | sudo tee -a /etc/zookeeper/conf/zoo.cfg >/dev/null

    i=$((i+1))
done
zk_endpoints="${zk_endpoints%?}" # Remove last comma
zkURL="zk://${zk_endpoints}/mesos"

# Quorum for replicated log must be a majority of masters
quorum=$((1 + $(echo $INSTANCES | tr "," " " | wc -w)/2))

# Prepare a sh script, which will be sourced before starting mesos and will export environment variables defining the cluster
mkdir -p ~/mesos_install
touch ~/mesos_install/mesos_env.sh
while IFS='=' read name value; do
  if [ -n "$value" ]; then
    echo "export ${name}=\"${value}\"" >> ~/mesos_install/mesos_env.sh
  fi
done < <(env | grep "^MESOS_")
# Add ZK url and Quorum
echo "export MESOS_ZK=\"${zkURL}\"" >> ~/mesos_install/mesos_env.sh
echo "export MESOS_QUORUM=\"${quorum}\"" >> ~/mesos_install/mesos_env.sh

# Export zk_endpoints as operation output - this will be passed to the slaves through the MesosSlaveConnectsToMasterRelationShip
# TODO: for some reason commas are replaced by whitespaces during the export
export zk_endpoints="${zk_endpoints}"
