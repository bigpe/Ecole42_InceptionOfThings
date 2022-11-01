#!/bin/bash

sudo -i

export PATH=$PATH:/usr/local/bin
echo "export PATH=$PATH:/usr/local/bin" >> .bashrc
source .bashrc

curl -fsSL https://get.docker.com -o get-docker.sh
sh ./get-docker.sh
usermod -aG docker $(whoami)
systemctl enable --now docker.service
systemctl enable --now containerd.service
systemctl start docker

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(<kubectl.sha256) kubectl" | sha256sum --check
chmod +x kubectl
install -o root -g root -m 0755 kubectl /usr/bin/kubectl
mv ./kubectl /usr/local/bin

curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
k3d cluster create dev-cluster --port 8080:80@loadbalancer --port 8888:8888@loadbalancer --port 8443:443@loadbalancer

kubectl get jobs -n kube-system
kubectl -n kube-system wait --for=condition=complete --timeout=-1s jobs/helm-install-traefik-crd
kubectl -n kube-system wait --for=condition=complete --timeout=-1s jobs/helm-install-traefik
kubectl get jobs -n kube-system

sleep 10