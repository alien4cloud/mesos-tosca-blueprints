#!/bin/bash

# Add the docker containerizer to Mesos slave configuration
echo "export MESOS_CONTAINERIZERS=\"docker,mesos\"" >> ~/mesos_install/mesos_env.sh
# Enlarge executor registration timeout to grant docker enough time to pull images
echo "export MESOS_EXECUTOR_REGISTRATION_TIMEOUT=\"5mins\"" >> ~/mesos_install/mesos_env.sh
