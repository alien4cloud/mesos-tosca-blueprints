#!/bin/bash -e
source ~/mesos_install/mesos_env.sh
sudo curl -H 'Content-Type: Application/json' "${MARATHON_API}/apps" -d@/usr/local/marathon-lb/app_definition.json
