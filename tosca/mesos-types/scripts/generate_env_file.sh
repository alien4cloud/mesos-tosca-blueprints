#!/bin/bash

touch mesos_env.txt
while IFS='=' read name value; do
  if [ -n "$value" ]; then
    echo "export ${name}=\"${value}\"" >> mesos_env.txt
  fi
done < <(sudo env | grep "^MESOS_")

