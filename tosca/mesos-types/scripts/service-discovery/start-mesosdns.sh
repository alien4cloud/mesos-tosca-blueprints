source ~/mesos_install/mesos_env.sh
sudo curl -H 'Content-Type: Application/json' "${MARATHON_API}/apps" -d@/usr/local/mesos-dns/app_definition.json
