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

echo "Installing k3s v1.21.4+k3s1..."
export INSTALL_K3S_VERSION=v1.21.4+k3s1
export INSTALL_K3S_EXEC="server --write-kubeconfig-mode 644 --advertise-address=$SERVER_IP --node-ip=$SERVER_IP"
curl -sfL https://get.k3s.io | sh -
