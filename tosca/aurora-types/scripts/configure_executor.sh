#!/bin/bash -e

# Configure slave work dir so thermos is able to find mesos sandboxes.
if [ -n $MESOS_WORK_DIR ]; then
    echo "MESOS_ROOT=${MESOS_WORK_DIR}" | sudo tee -a /etc/default/thermos
    # Up to aurora version 0.12.0, we need to edit /etc/init/thermos.conf too
    # TODO : add the line --mesos-root=${MESOS_ROOT:-/var/lib/mesos} \
fi
