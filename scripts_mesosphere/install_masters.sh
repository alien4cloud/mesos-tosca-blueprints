#!/usr/bin/env bash

# Params

key=adrian.pem

# Global config file to scp to masters
mkdir tmp
touch tmp/zoo.cfg
touch tmp/zk

i=1
n=$(cat masters_ip | wc -l)
quorum=$((1 + n/2))

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
done < masters_private_ip
echo -n "/mesos" >> tmp/zk

i=1
while read ip
do
    host="centos@${ip}"

    # Install masters
    ssh -tt -i ${key} ${host} < setup_master.sh

    # Zookeeper configuration
    # /etc/mesos/zk /etc/zookeeper/conf/zoo.cfg

    ssh -q -i ${key} ${host} "mkdir -p ~/tmp" && scp -i ${key} tmp/zk ${host}:~/tmp/zk
    scp -q -i ${key} tmp/zoo.cfg ${host}:~/tmp/zoo.cfg

    # Config script
    ssh -q -tt -i ${key} ${host} ARG1=${i} ARG2=${ip} ARG3=${privates[$i]} ARG4=${quorum} < config_master.sh

    # restart services
    ssh -tt -i ${key} ${host} "sudo service zookeeper restart; sudo service mesos-master restart"

done < masters_ip

rm -rf tmp/

