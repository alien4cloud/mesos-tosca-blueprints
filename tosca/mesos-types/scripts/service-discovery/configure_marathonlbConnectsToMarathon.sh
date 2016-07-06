#!/bin/bash -e
url=$(echo ${MARATHON_API} | tr " " ",") # NOTE: This is to workaround the replacement of commas with spaces when the output is exported
sudo sed -i "s;{{marathon_api}};${url};" /usr/local/marathon-lb/app_definition.json
echo "export MARATHON_API=\"${url}\"" >> ~/mesos_install/mesos_env.sh
