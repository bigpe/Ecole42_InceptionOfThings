#!/bin/bash

apt update -y
apt upgrade -y
apt install curl -y

curl -fsSL https://get.docker.com -o get-docker.sh
sh ./get-docker.sh
systemctl start docker
groupadd docker
usermod -aG docker "$(whoami)"

export KUBE_CTL_ARCH="arm64"

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$KUBE_CTL_ARCH/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$KUBE_CTL_ARCH/kubectl.sha256"
echo "$(<kubectl.sha256) kubectl" | sha256sum --check
chmod +x kubectl
mv ./kubectl /usr/local/bin

curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash