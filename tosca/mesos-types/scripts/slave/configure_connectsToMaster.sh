#!/bin/bash

if [ -n "${MESOS_MASTER}" ]; then
    url=$(echo ${MESOS_MASTER} | tr " " ",") # TODO: This is to workaround the replacement of commas with spaces when the output is exported
    echo "export MESOS_MASTER=\"${url}\"" >> ~/mesos_install/mesos_env.sh
else
    echo "Failed to configure slave : Master URL is mandatory." && exit 1
fi