#!/bin/bash -e

# Prepare a sh script to export mesos environment variables
mkdir -p ~/mesos_install
touch ~/mesos_install/mesos_env.sh
while IFS='=' read name value; do
  if [ -n "$value" ]; then
    echo "export ${name}=\"${value}\"" >> ~/mesos_install/mesos_env.sh
  fi
done < <(env | grep "^MESOS_")

#TODO : add ports resources for LB --resources=ports:[9090-9091,10000-101000,31000-32000]
echo "export MESOS_RESOURCES=\"ports:[53,8123,9090-9091,10000-101000,31000-32000]\"" >> ~/mesos_install/mesos_env.sh

# TODO move this into a standalone component
# setup mesos-dns
sudo mkdir /usr/local/mesos-dns/
sudo wget -O /usr/local/mesos-dns/mesos-dns https://github.com/mesosphere/mesos-dns/releases/download/v0.5.1/mesos-dns-v0.5.1-linux-amd64
sudo chmod +x mesos-dns
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
