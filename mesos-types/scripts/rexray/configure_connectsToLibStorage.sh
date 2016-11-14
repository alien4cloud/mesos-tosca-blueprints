#!/bin/bash -e

sudo sed -i "s/{{REXRAY_SERVER}}/${REXRAY_SERVER}/" /etc/rexray/config.yml
