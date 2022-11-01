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

kubectl wait --for=condition=available deployments --all -n gitlab

kubectl port-forward svc/gitlab-webservice-default --address 0.0.0.0 -n gitlab 8083:8080 2>&1 >/dev/null &