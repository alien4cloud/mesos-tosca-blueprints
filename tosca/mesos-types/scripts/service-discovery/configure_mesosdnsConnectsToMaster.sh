# Configure mesos-dns
source ~/mesos_install/mesos_env.sh
sudo sed -i "s;{{mesos_zk}};${MESOS_MASTER};" /usr/local/mesos-dns/config.json

url=$(echo ${MARATHON_API} | tr " " ",") # NOTE: This is to workaround the replacement of commas with spaces when the output is exported
echo "export MARATHON_API=\"${url}\"" >> ~/mesos_install/mesos_env.sh
