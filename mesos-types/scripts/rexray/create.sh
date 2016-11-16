#!/bin/bash -e

# Get apt-lock
NAME="Rexray"
LOCK="/tmp/lockaptget"

# Fixme - Find a better way to deal with multiple instances 
# read -r -a array <<< ${INSTANCES}
# # RexrayServer is not scalable
# [ $INSTANCE == ${array[0]} ] || exit 0

while true; do
    if mkdir "${LOCK}" &>/dev/null; then
      echo "$NAME take apt lock"
      break;
    fi
    echo "$NAME waiting apt lock to be released..."
    sleep 0.5
done

while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
    echo "$NAME waiting for other software managers to finish..."
    sleep 0.5
done
sudo rm -f /var/lib/dpkg/lock

curl -sSL https://dl.bintray.com/emccode/rexray/install | sudo sh -s -- stable
sudo cp ${rexray_config} /etc/rexray/config.yml

rm -rf "${LOCK}"
echo "$NAME released apt lock"
