#!/usr/bin/env bash

source /tmp/config.sh

# Deploy keys to allow all nodes to connect each others as root
mkdir -p /root/.ssh
mv /tmp/id_rsa*  /root/.ssh/

chmod 400 /root/.ssh/id_rsa*
chown root:root  /root/.ssh/id_rsa*

cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
chmod 400 /root/.ssh/authorized_keys
chown root:root /root/.ssh/authorized_keys

# Add current node in  /etc/hosts
echo "127.0.0.1 $(hostname)" >> /etc/hosts

# Add kubemaster1 in  /etc/hosts
echo "$SERVER_IP  $SERVER_NAME" >> /etc/hosts

echo "Installing k3s(agent) v1.21.4+k3s1..."
scp -o StrictHostKeyChecking=no root@$SERVER_NAME:/var/lib/rancher/k3s/server/token /tmp/token
export INSTALL_K3S_VERSION=v1.21.4+k3s1
export INSTALL_K3S_EXEC="agent --server https://$SERVER_NAME:6443 --token-file /tmp/token --node-ip=$WORKER_IP"
curl -sfL https://get.k3s.io | sh -
