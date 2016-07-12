#!/bin/bash -e
# Starting marathon as sudo while retaining environment variables
# NOTE: Workaround - cfy replaces commas with whitespaces
MARATHON_MASTER=$(echo $MARATHON_MASTER | tr " " ",")
MARATHON_ZK=$(echo $MARATHON_ZK | tr " " ",")
sudo -E nohup marathon --access_control_allow_origin="*" 0</dev/null &>/dev/null &
sleep 5

ps -ef | grep -v grep | grep marathon >/dev/null || (echo "Failed to start marathon"; exit 1)
