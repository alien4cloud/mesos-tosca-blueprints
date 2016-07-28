#!/bin/bash -e
source ~/mesos_install/mesos_env.sh

# Try to launch mesos-dns - if status = 409 then it's already launched.
status_code=$(sudo curl -s -o /dev/null -w "%{http_code}" -H 'Content-Type: Application/json' "${MARATHON_API}/apps" -d @/usr/local/mesos-dns/app_definition.json)
if ! ([ $status_code = '201' ] || [ $status_code = '409' ]); then
  echo "Failure launching MesosDNS. Error code : ${status_code}." && exit 1
fi
