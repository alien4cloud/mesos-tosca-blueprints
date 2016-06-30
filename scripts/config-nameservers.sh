if [[ $# -ne 1 ]]; then
  echo "Usage : ./config-nameservers.sh mesos-dns-ip iaas"
  exit 1
fi

cat slaves | while read ip 
do { 
  #ssh -tt -i ~/Workspace/fastconnect/keys/fraissea.pem ubuntu@$ip "sudo sed -i '1s/^/nameserver ${1}\n /' /etc/resolvconf/resolv.conf.d/head; sudo resolvconf -u" 
  ssh -tt ubuntu@$ip "sudo sed -i '1s/^/nameserver ${1}\n /' /etc/resolvconf/resolv.conf.d/head; sudo resolvconf -u" 
} </dev/null; done 
