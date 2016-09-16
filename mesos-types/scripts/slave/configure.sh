#!/bin/bash -e

# Prepare a sh script to export mesos environment variables
mkdir -p ~/mesos_install
touch ~/mesos_install/mesos_env.sh
while IFS='=' read name value; do
  if [ -n "$value" ]; then
    echo "export ${name}=\"${value}\"" >> ~/mesos_install/mesos_env.sh
  fi
done < <(env | grep "^MESOS_")

# Add ports resources for LB --resources=ports:[9090-9091,10000-101000,31000-32000]
echo "export MESOS_RESOURCES=\"ports:[53,8123,9090-9091,10000-10100,31000-32000]\"" >> ~/mesos_install/mesos_env.sh
