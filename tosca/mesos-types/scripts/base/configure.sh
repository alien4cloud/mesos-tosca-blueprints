#!/bin/bash -e

# Fix /etc/hosts
sudo cp /etc/hosts /tmp/hosts
echo "${MESOS_IP}" `hostname` | sudo tee /etc/hosts >/dev/null
cat /tmp/hosts | sudo tee -a /etc/hosts >/dev/null

# Create environnement variables
mkdir -p ~/mesos_install
touch ~/mesos_install/mesos_env.txt
while IFS='=' read name value; do
  if [ -n "$value" ]; then
    echo "export ${name}=\"${value}\"" >> ~/mesos_install/mesos_env.txt
  fi
done < <(env | grep "^MESOS_")
