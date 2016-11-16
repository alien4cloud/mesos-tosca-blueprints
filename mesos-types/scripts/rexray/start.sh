#!/bin/bash -e
# start rexray service
# read -r -a array <<< ${INSTANCES}
# # RexrayServer is not scalable
# [ $INSTANCE == ${array[0]} ] || exit 0
sudo service rexray start
