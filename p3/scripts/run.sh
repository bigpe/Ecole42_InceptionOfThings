#!/bin/bash

systemctl start docker
/usr/sbin/groupadd docker
/usr/sbin/usermod -aG docker "$(whoami)"

k3d cluster create iot-cluster --api-port 6443 -p 8080:80@loadbalancer --agents 2 --wait

kubectl create namespace argocd
kubectl create namespace dev

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl wait --for=condition=Ready pods --all -n argocd

kubectl -n argocd patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": "$2a$12$h2c83vniNJQYwb8zM.RE/.yKJ5c4DwHC0icQEoOU5nkc1QQQrgt3G",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'

kubectl apply -f ../confs/project.yaml -n argocd

kubectl apply -f ../confs/application.yaml -n argocd

kubectl wait --for=condition=Ready pods --all -n argocd

sleep 30

kubectl port-forward svc/wil-playground -n dev 8888:8888 2>&1 >/dev/null &
kubectl port-forward svc/argocd-server --address 0.0.0.0 -n argocd 8082:80 2>&1 >/dev/null &