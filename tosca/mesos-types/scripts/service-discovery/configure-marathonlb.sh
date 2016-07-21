#!/bin/bash -e
# Configure marathon application file
sudo mkdir /usr/local/marathon-lb
sudo cp ${marathon_template} /usr/local/marathon-lb/app_definition.json
sudo sed -i "s/{{instances}}/${NB_INST}/" /usr/local/marathon-lb/app_definition.json
sudo sed -i "s/{{cpu}}/${CPU_ALLOC}/" /usr/local/marathon-lb/app_definition.json
sudo sed -i "s/{{mem}}/${MEM_ALLOC}/" /usr/local/marathon-lb/app_definition.json

url=$(echo ${MARATHON_API} | tr " " ",") # NOTE: This is to workaround the replacement of commas with spaces when the output is exported
sudo sed -i "s;{{marathon_api}};${url///v2};" /usr/local/marathon-lb/app_definition.json
