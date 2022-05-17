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



# Configure BMCTL
gsutil cp gs://anthos-baremetal-release/bmctl/1.11.1/linux-amd64/bmctl .
chmod +x bmctl
mv bmctl /usr/local/bin/

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

# Passwordless sudo
echo "ubuntu    ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

# Configure ssh key
SECRET_SOURCE=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/abm-private-key" -H "Metadata-Flavor: Google")
echo $SECRET_SOURCE
gcloud secrets versions access 1 --secret=$SECRET_SOURCE --format='get(payload.data)' | tr '_-' '/+' | base64 -d >> ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

# Get Key Files
SA_LIST=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/sa-key-list" -H "Metadata-Flavor: Google")

# Setup cluster
export CLOUD_PROJECT_ID=$(gcloud config get-value project)

bmctl create config -c abm-gce \
    --create-service-accounts --project-id=$CLOUD_PROJECT_ID