## install Helm

sudo curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

## create namespace for gitlab

sudo kubectl create namespace gitlab

sudo helm repo add gitlab https://charts.gitlab.io/
sudo helm repo update

sudo helm upgrade --install gitlab gitlab/gitlab \
  -n gitlab \
  -f https://gitlab.com/gitlab-org/charts/gitlab/raw/master/examples/values-minikube-minimum.yaml \
  --set global.hosts.domain=10.11.1.253.nip.io \
  --set global.hosts.externalIP=10.11.1.253 \
  --set global.edition=ce \
  --timeout 600s

# The deployment may take 5-15 minutes
# watch kubectl get all -n gitlab
# helm status gitlab -n gitlab

# GitLab would’ve automatically created a random password for root user
# kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -ojsonpath='{.data.password}' | base64 --decode ; echo

sudo kubectl wait --for=condition=available deployments --all -n gitlab

# sudo kubectl wait --for=condition=Ready --timeout=-1s pods --all -n gitlab

echo "Gitlab is deployed, run the following command to access the UI:"
echo "sudo kubectl port-forward svc/gitlab-webservice-default --address 10.11.1.253 -n gitlab 8082:8080 2>&1 >/dev/null &"
echo "..::OK::.."

# ps -ef|grep port-forward
# sudo kill -9