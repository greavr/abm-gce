#!/bin/bash
set -x
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
  ntpdate \
  net-tools \
  jq \
  nano \
  iputils-ping -y


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

# Configure network
echo 1 > /proc/sys/net/ipv4/ip_forward
I=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/vx-ip" -H "Metadata-Flavor: Google")


# Build Nodie IP list
WORKER_IPs=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/worker-node-ips" -H "Metadata-Flavor: Google")
MASTER_IPs=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/master-node-ips" -H "Metadata-Flavor: Google")
IP_LIST="$WORKER_IPs,$MASTER_IPs"
IFS=', ' read -r -a IPs <<< "$IP_LIST"
for ip in ${IPs[@]}; do
    echo $ip
done



ip link add vxlan0 type vxlan id 42 dev ens4 dstport 0
current_ip=$(ip --json a show dev ens4 | jq '.[0].addr_info[0].local' -r)
echo "VM IP address is: $current_ip"
for ip in ${IPs[@]}; do
    if [ "$ip" != "$current_ip" ]; then
        bridge fdb append to 00:00:00:00:00:00 dst $ip dev vxlan0
    fi
done
ip addr add 10.200.0.$I/24 dev vxlan0
ip link set up dev vxlan0

# Configure ssh key
SECRET_SOURCE=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/abm-private-key" -H "Metadata-Flavor: Google")
echo $SECRET_SOURCE
gcloud secrets versions access 1 --secret=$SECRET_SOURCE --format='get(payload.data)' | tr '_-' '/+' | base64 -d > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

# Get Key Files
SA_LIST=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/sa-key-list" -H "Metadata-Flavor: Google")
IFS=', ' read -r -a array <<< "$SA_LIST"

# Generate files
mkdir /abm
chmod 777 -R /abm
cd /abm


for i in "${array[@]}"
do
    echo "$i" >> log.log
    gcloud secrets versions access 1 --secret=$i --format='get(payload.data)' | tr '_-' '/+' | base64 -d > $i.json
done

# Setup cluster
export CLOUD_PROJECT_ID=$(gcloud config get-value project)

bmctl create config -c abm-gce --project-id=$CLOUD_PROJECT_ID  >> log.log

rm /abm/bmctl-workspace/abm-gce/abm-gce.yaml
#### WHY DOES THIS NOT WORK ####
ABM_TEMPLATE=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/template-path" -H "Metadata-Flavor: Google")  >> log.log
################################
echo $ABM_TEMPLATE >> log.log
gsutil cp $ABM_TEMPLATE /abm/bmctl-workspace/abm-gce/abm-gce.yaml  >> log.log
chmod 777 /abm/bmctl-workspace/abm-gce/*  >> log.log

sed -i "s/project\_id/$CLOUD_PROJECT_ID/g" /abm/bmctl-workspace/abm-gce/abm-gce.yaml

# Create cluster
bmctl create cluster -c abm-gce >> log.log