#!/usr/bin/env bash

# Params

key=data/adrian.pem

# Global config file to scp to masters
mkdir tmp
touch tmp/zoo.cfg
touch tmp/zk

i=1
n=$(cat data/masters_ip | wc -l)
quorum=$((1 + n/2))
privates=()

echo -n "zk://" > tmp/zk

while read ip
do
	privates[$i]=${ip}
	echo "server.${i}=${ip}:2888:3888" | tee -a tmp/zoo.cfg
	if [ ${i} -eq 1 ]
	then
		echo -n "${ip}:2181" >> tmp/zk
	else
		echo -n ",${ip}:2181" >> tmp/zk
	fi
	i=$((i+1))
done < data/masters_private_ip

echo "/mesos" >> tmp/zk

i=1
cat data/masters_ip | while read ip
do {
	host="centos@${ip}"

	# Install masters
	ssh -q -tt -i ${key} ${host} < scripts_mesosphere/setup_master.sh
	if [ $? -eq 0 ]
	then

		# Zookeeper configuration

		ssh -q -i ${key} ${host} "mkdir -p ~/tmp" && scp -i ${key} tmp/zk ${host}:~/tmp/zk
		scp -q -i ${key} tmp/zoo.cfg ${host}:~/tmp/zoo.cfg


        private_ip=${privates[$i]}

		# Config script
		ssh -q -tt -i ${key} ${host} <<-ENDSSH
			# Copy zk conf files
			sudo mv ~/tmp/zk /etc/mesos/zk
			cat ~/tmp/zoo.cfg | sudo tee -a /etc/zookeeper/conf/zoo.cfg

			# ID /var/lib/zookeeper/myid
			sudo mkdir -p /var/lib/zookeeper; echo ${i} | sudo tee /var/lib/zookeeper/myid

			# /etc/mesos-master/hostname /etc/marathon/conf/hostname
			sudo mkdir -p /etc/marathon/conf/ && echo ${ip} | sudo tee /etc/mesos-master/hostname /etc/marathon/conf/hostname

			# /etc/mesos-master/quorum
			echo ${quorum} | sudo tee /etc/mesos-master/quorum

			# /etc/mesos-master/ip
			echo ${private_ip} | sudo tee /etc/mesos-master/ip

			# Cluster name /etc/mesos-master/cluster
			echo "Mesos" | sudo tee /etc/mesos-master/cluster

			# private ip in /etc/hosts
			{ echo $private_ip | tr "\n" " " ; hostname ; } | sudo tee -a /etc/hosts

			# clean
			rm -rf ~/tmp/
			exit 0
		ENDSSH

		if [ $? -eq 0 ]
		then
			# restart zookeeper
			ssh -tt -i ${key} ${host} "sudo service zookeeper restart"
		else
			echo "Unable to configure zookeeper. Exiting now..."
			exit 1
		fi
	else
		echo "Unable to connect using ssh. Exiting now..."
		exit 1
	fi
	i=$((i+1))

	echo "master traité : ${ip}"
} </dev/null; done

rm -rf tmp/
