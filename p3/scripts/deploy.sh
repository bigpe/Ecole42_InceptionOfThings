#!/bin/bash

sudo -i
export PATH=$PATH:/usr/local/bin
echo "export PATH=$PATH:/usr/local/bin" >> .bashrc
source .bashrc

kubectl create namespace argocd
kubectl create namespace dev

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl wait --for=condition=Ready pods --all -n argocd

kubectl -n argocd patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": "$2a$12$h2c83vniNJQYwb8zM.RE/.yKJ5c4DwHC0icQEoOU5nkc1QQQrgt3G",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'

sudo kubectl apply -f /tmp/p3/confs/project.yaml -n argocd

sudo kubectl apply -f /tmp/p3/confs/application.yaml -n argocd

sleep 60
