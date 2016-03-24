#!/usr/bin/env bash
# Repository
sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
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
sudo service docker start
exit 0
