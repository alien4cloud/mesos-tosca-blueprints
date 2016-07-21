#!/bin/bash
# Try to launch marathon-lb - if status = 409 then it's already launched.
status_code=$(sudo curl -s -o /dev/null -w "%{http_code}" -H 'Content-Type: Application/json' 'http://localhost:8080/v2/apps' -d @/usr/local/marathon-lb/app_definition.json)
if ! ([ $status_code = '201' ] || [ $status_code = '409' ]); then
  echo "Failure launching Marathon-LB. Error code : ${status_code}." && exit 1
fi
