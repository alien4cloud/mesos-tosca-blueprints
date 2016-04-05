#!/bin/bash -e

# Starts a mesos Master in stand-alone mode
echo "Starting mesos master..."
source ~/mesos_install/mesos_env.txt
sudo -E nohup mesos-master >~/start-master.log 2>&1 &

ps -ef | grep -v grep >/dev/null | grep mesos-master >/dev/null || exit 1

# Todo : vérifier que le master tourne (envoyer une tache de test ?)
