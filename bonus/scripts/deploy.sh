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

sudo kubectl apply -f /tmp/bonus/confs/project.yaml -n argocd

sudo kubectl apply -f /tmp/bonus/confs/application.yaml -n argocd

sleep 60

kubectl port-forward svc/argocd-server --address 0.0.0.0 -n argocd 8082:80 2>&1 >/dev/null &


curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

kubectl create namespace gitlab

helm repo add gitlab https://charts.gitlab.io/
helm repo update

helm upgrade --install gitlab gitlab/gitlab \
  -n gitlab \
  -f https://gitlab.com/gitlab-org/charts/gitlab/raw/master/examples/values-minikube-minimum.yaml \
  --set global.hosts.domain=0.0.0.0.nip.io \
  --set global.hosts.externalIP=0.0.0.0 \
  --set global.edition=ce \
  --timeout 600s

kubectl delete deployment "gitlab-sidekiq-all-in-1-v2"
kubectl wait --for=condition=available deployments --all -n gitlab

sleep 300
