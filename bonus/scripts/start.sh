kubectl port-forward svc/argocd-server --address 0.0.0.0 -n argocd 8082:80 2>&1 >/dev/null &
kubectl port-forward svc/gitlab-webservice-default --address 0.0.0.0 -n gitlab 8083:8080 2>&1 >/dev/null &