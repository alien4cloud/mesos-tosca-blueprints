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
sudo sed -i "1s/^/nameserver ${SLAVE_LOCAL_IP}\n /" /etc/resolvconf/resolv.conf.d/head
sudo resolvconf -u

# Configure marathon application file
sudo cp ${marathon_template} /usr/local/mesos-dns/app_definition.json
sudo sed -i "s/{{slave_ip}}/${SLAVE_IP}/" /usr/local/mesos-dns/app_definition.json
sudo sed -i "s/{{cpu}}/${CPU_ALLOC}/" /usr/local/mesos-dns/app_definition.json
sudo sed -i "s/{{mem}}/${MEM_ALLOC}/" /usr/local/mesos-dns/app_definition.json
