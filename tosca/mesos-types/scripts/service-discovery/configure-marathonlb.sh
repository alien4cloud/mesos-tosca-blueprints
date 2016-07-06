#!/bin/bash -e
# Configure marathon application file
sudo mkdir /usr/local/marathon-lb
sudo cp ${marathon_template} /usr/local/marathon-lb/app_definition.json
sudo sed -i "s/{{cpu}}/${CPU_ALLOC}/" /usr/local/marathon-lb/app_definition.json
sudo sed -i "s/{{mem}}/${MEM_ALLOC}/" /usr/local/marathon-lb/app_definition.json
