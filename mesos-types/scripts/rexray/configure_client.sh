#!/bin/bash -e

sudo sed -i "s/{{STORAGE_SERVICE}}/${STORAGE_SERVICE}/" /etc/rexray/config.yml
