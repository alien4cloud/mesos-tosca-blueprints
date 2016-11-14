#!/bin/bash -e

# Using mesosphere packages, already configured through mesos's install

case $OS in
    "ubuntu"|"debian")
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

        if [ "$OS_VERS" == "14.04" ]; then
          # Ubuntu 14.04 does not support openjdk8 yet - install from Oracle using webupd8team PPA
          sudo add-apt-repository -y ppa:webupd8team/java
          sudo apt-get update -y
          echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
          echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
          sudo apt-get install -y oracle-java8-installer oracle-java8-set-default
        fi

        # Install marathon - java8 is installed as a dependency
        sudo apt-get install -y marathon

        rm -rf "${LOCK}"
        echo "$NAME released apt lock"
        ;;
    "redhat"|"centos")
        sudo yum install -y marathon
        ;;
    *)
        echo "${OS} is not supported ATM. Exiting..." && exit 1
        ;;
esac
