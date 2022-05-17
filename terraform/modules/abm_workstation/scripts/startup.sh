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

export CLOUD_PROJECT_ID=$(gcloud config get-value project)

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/


# Setup cluster
bmctl create config -c abm-gce \
    --create-service-accounts --project-id=$GCP_PROJECT