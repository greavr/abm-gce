#!/bin/bash
systemctl stop ufw
ufw disable
apt-get update
apt-get remove docker docker-engine docker.io containerd runc
apt-get install apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common \
  docker.io \
  ntpdate -y

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

# Passwordless sudo
echo "ubuntu    ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers