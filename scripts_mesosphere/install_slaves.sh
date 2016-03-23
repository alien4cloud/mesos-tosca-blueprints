#!/usr/bin/env bash

# Params

key=data/adrian.pem

# Get one master
master=$(head -n 1 data/masters_ip)

cat data/slaves_ip | while read ip
do {
	host="centos@${ip}"

	# Install slave
	ssh -tt -q -i ${key} ${host} < scripts_mesosphere/setup_slave.sh

	if [ $? -eq 0 ]
	then
		# Get masters zk url
		scp -3 -i ${key} centos@${master}:/etc/mesos/zk ${host}:~/zk

		ssh -q -tt -i ${key} ${host} <<-ENDSSH
            sudo mv ~/zk /etc/mesos/zk
            ip addr show eth0 | grep -Po 'inet \K[\d.]+' | sudo tee /etc/mesos-slave/ip
            echo ${ip} | sudo tee /etc/mesos-slave/hostname
            exit 0
		ENDSSH
	else
		echo "Unable to connect using ssh. Exiting now..."
		exit 1
	fi
} </dev/null; done
