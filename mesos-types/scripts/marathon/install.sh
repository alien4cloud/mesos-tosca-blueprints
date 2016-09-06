#!/bin/bash -e

# Using mesosphere packages, already configured through mesos's install

case $OS in
    "ubuntu")
        # Get apt-lock
        NAME="Marathon"
        LOCK="/tmp/lockaptget"

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

        # Install Java 8 from Oracle's PPA
        sudo add-apt-repository -y ppa:webupd8team/java
        sudo apt-get update -y
        echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
        echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
        sudo apt-get install -y oracle-java8-installer oracle-java8-set-default

        # Install marathon
        sudo apt-get install -y marathon

        rm -rf "${LOCK}"
        echo "$NAME released apt lock"
        ;;
    *)
        echo "${OS} is not supported ATM. Exiting..." && exit 1
        ;;
esac
