CONFIG_PATH="/tmp/p3/confs"

export PATH=$PATH:/usr/local/bin
echo "export PATH=$PATH:/usr/local/bin" >> .bashrc
source .bashrc

kubectl create namespace argocd
kubectl create namespace dev


kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl apply -n argocd -f $CONFIG_PATH/ingress.yaml

kubectl rollout status deployment argocd-server -n argocd
kubectl rollout status deployment argocd-redis -n argocd
kubectl rollout status deployment argocd-repo-server -n argocd
kubectl rollout status deployment argocd-dex-server -n argocd

kubectl apply -n argocd -f $CONFIG_PATH/application.yaml

# password is test
kubectl -n argocd patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": "$2a$12$h2c83vniNJQYwb8zM.RE/.yKJ5c4DwHC0icQEoOU5nkc1QQQrgt3G",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'

kubectl wait --for=condition=Ready pods --all -n argocd
sleep 60
curl http://localhost:8888