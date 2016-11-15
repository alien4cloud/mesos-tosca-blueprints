#!/bin/bash -e
sudo cp ${dns_config} /usr/local/mesos-dns/config.json

# setup resolvers
declare -a nameservers=($(cat /etc/resolv.conf | grep '^nameserver' | awk '{print $2}'))
resolvers=""
for res in "${nameservers[@]}"
do
  resolvers="${resolvers}\"${res}\","
done
resolvers="${resolvers%?}"
sudo sed -i "s/{{resolvers}}/${resolvers}/" /usr/local/mesos-dns/config.json

# Add self as a dns server
if [ -f /etc/resolvconf/resolv.conf.d/head ]; then
  sudo sed -i "2s/^/nameserver ${SLAVE_LOCAL_IP}\n /" /etc/resolvconf/resolv.conf.d/head
  sudo resolvconf -u
else
  sudo sed -i "2s/^/nameserver ${SLAVE_LOCAL_IP}\n /" /etc/resolv.conf
fi

# Configure marathon application file
sudo cp ${marathon_template} /usr/local/mesos-dns/app_definition.json

# Set appID - in lower case - to the node's name. Replace underscores with dashes.
appID=$(echo ${NODE} | tr '[:upper:]' '[:lower:]' | tr '_' '-')
sudo sed -i "s/{{app_id}}/${appID}/" /usr/local/mesos-dns/app_definition.json

# Constraint the application to the given slaves.
slaves_regx=""
IFS=","
for inst in $INSTANCES
do
  var_name="${inst}_SLAVE_IP"
  slaves_regx="${slaves_regx}${!var_name}|"
done
slaves_regx="${slaves_regx%?}" # Remove last pipe
sudo sed -i "s/{{slaves_regx}}/${slaves_regx}/" /usr/local/mesos-dns/app_definition.json

# Nb instances
nb_inst=$(echo $INSTANCES | tr "," " " | wc -w)
sudo sed -i "s/{{nb_inst}}/${nb_inst}/" /usr/local/mesos-dns/app_definition.json

# Resource reservation
sudo sed -i "s/{{cpu}}/${CPU_ALLOC}/" /usr/local/mesos-dns/app_definition.json
sudo sed -i "s/{{mem}}/${MEM_ALLOC}/" /usr/local/mesos-dns/app_definition.json
