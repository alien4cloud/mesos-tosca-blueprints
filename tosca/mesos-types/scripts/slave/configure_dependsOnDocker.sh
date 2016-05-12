#!/bin/bash

# Add the docker containerizer to Mesos slave configuration
echo "export MESOS_CONTAINERIZERS=\"mesos,docker\"" >> ~/mesos_install/mesos_env.sh
