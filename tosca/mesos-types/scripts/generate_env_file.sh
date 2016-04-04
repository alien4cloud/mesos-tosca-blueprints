#!/bin/bash

mkdir -p ~/mesos_install
touch ~/mesos_install/mesos_env.txt
while IFS='=' read name value; do
  if [ -n "$value" ]; then
    echo "export ${name}=\"${value}\"" >> ~/mesos_install/mesos_env.txt
  fi
done < <(sudo env | grep "^MESOS_")

