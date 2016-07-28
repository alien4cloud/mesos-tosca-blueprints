#!/bin/bash -e

# Retrieves Aurora configuration and sed values into /etc/defaulf/aurora-scheduler, the configuration file used by the init.d aurora services
while IFS='=' read name value; do
    # Check if value is not null or empty
    if [ -n "$value" ]; then
        # NOTE: Workaround commas being replaced by whitespaces
        value=$(echo $value | tr " " ",")
        # Substitute value in aurora config file
        sudo sed -i.bak "s;^${name}=.*;${name}=\"${value}\";" /etc/default/aurora-scheduler
    fi
done < <(env | grep '^AURORA_' | sed 's/AURORA_//')

# Calculate quorum
quorum=$((1 + $(echo $INSTANCES | tr "," " " | wc -w)/2))
sudo sed -i.bak "s/^\(QUORUM_SIZE=\)[0-9]*$/\1${quorum}/" /etc/default/aurora-scheduler

# Use the known compute hostname to advertise in ZooKeeper instead of the locally-resolved hostname.
sudo sed -i.bak "s/^\(EXTRA_SCHEDULER_ARGS=\).*$/\1\"-hostname=\\\\\"${HOSTNAME}\\\\\"\"/" /etc/default/aurora-scheduler

zk_ensemble=$(echo $AURORA_ZK_ENDPOINTS | tr " " ",")
# Set the ZK ensemble that tasks will use for service discovery. TODO : use a different ZK ensemble
sudo sed -i.bak "s/^\(THERMOS_EXECUTOR_FLAGS=\"\).*$/\1--announcer-ensemble ${zk_ensemble}\"/" /etc/default/aurora-scheduler

# Remove backup file
sudo rm -f /etc/default/aurora-scheduler.bak
