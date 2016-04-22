#!/bin/bash -e

# Create environnement variables
mkdir -p ~/mesos_install
touch ~/mesos_install/mesos_env.sh
while IFS='=' read name value; do
  if [ -n "$value" ]; then
    echo "export ${name}=\"${value}\"" >> ~/mesos_install/mesos_env.sh
  fi
done < <(env | grep "^MESOS_")
