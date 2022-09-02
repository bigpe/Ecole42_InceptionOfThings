#!/bin/bash

systemctl start docker
groupadd docker
usermod -aG docker $(whoami)

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

echo "Argo CD is deployed, run the following command to access the dashboard:"
echo "kubectl port-forward svc/argocd-server --address 10.11.1.253 -n argocd 8081:80 2>&1 >/dev/null &"
echo "run the following command to access wil's app:"
echo "kubectl port-forward svc/wil-playground -n dev 8888:8888 2>&1 >/dev/null &"
echo "..::OK::.."
