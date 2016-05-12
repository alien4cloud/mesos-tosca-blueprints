#!/bin/bash -e

if [[ $# -ne 1 || ! $1 =~ (^ubuntu$|^centos$) ]]; then
  echo "usage : ./docker_install.sh ubuntu|centos"
  exit 1
fi
case $1 in
  "ubuntu")
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    linux_codename=$(lsb_release -cs)
    echo "deb https://apt.dockerproject.org/repo ubuntu-${linux_codename} main" | sudo tee -a /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt-get update
    sudo apt-get purge -y lxc-docker
    sudo apt-get install -y linux-image-extra-$(uname -r)
    sudo apt-get install -y docker-engine
    sudo service docker start
    ;;
  "centos")
    sudo tee /etc/yum.repos.d/docker.repo <<-EOF
    [dockerrepo]
    name=Docker Repository
    baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
    enabled=1
    gpgcheck=1
    gpgkey=https://yum.dockerproject.org/gpg
EOF
    # Install
    sudo yum -y install docker-engine
    # Start deamon
    sudo service docker
    ;;
esac
exit 0
