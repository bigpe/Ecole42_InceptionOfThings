#!/bin/bash

apt update -y
apt upgrade -y
apt install curl -y

curl -fsSL https://get.docker.com -o get-docker.sh
sh ./get-docker.sh
systemctl start docker
groupadd docker
usermod -aG docker $(whoami)

## Installing Kubectl

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(<kubectl.sha256) kubectl" | sha256sum --check
# install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
chmod +x kubectl
mv ./kubectl /usr/local/bin

## K3d

curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash

echo "Installing the auto-completion scripts for k3d"
echo "source <(k3d completion bash)" >> ~/.bashrc

echo "..::OK::.."