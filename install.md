# Upload scripts
$ awk '{ system("scp -i adrian.pem mesos_install.tar.gz centos@"$0":~ ") }' cluster_ip

# Untar scripts
$ awk '{ system("ssh -i adrian.pem centos@"$0" tar -xzf mesos_install.tar.gz") }' cluster_ip 

# Exec permissions
$ awk '{ system("ssh -tt -i adrian.pem  centos@"$0" sudo chmod +x scripts/*.sh") }' cluster_ip  

# Launch prerequisites 
$ awk '{ system("ssh -tt -i adrian.pem  centos@"$0" ./scripts/prereq_centos7.sh") }' cluster_ip

# Launch build
$ awk '{ system("ssh -tt -i adrian.pem centos@"$0" ./scripts/build.sh")}' cluster_ip

# Retrieve private IP
$ private_ip=ip -f inet addr show eth0 | grep -Po 'inet \K[\d.]+'