# Troubleshooting Guide

## Cluster Issues

### Nodes not ready
kubectl describe node NODE_NAME
journalctl -u kubelet -n 50

### etcd not healthy
kops validate cluster --name taskapp.k8s.local
ssh -i ~/.ssh/kops-key ubuntu@MASTER_IP
sudo systemctl status etcd

### API server unreachable
aws elb describe-load-balancers --profile kops
kops export kubeconfig --admin --name taskapp.k8s.local

## Application Issues

### Pod stuck in Pending
kubectl describe pod POD_NAME -n taskapp
kubectl get events -n taskapp --sort-by=.lastTimestamp

### Pod stuck in CrashLoopBackOff
kubectl logs POD_NAME -n taskapp --previous
kubectl describe pod POD_NAME -n taskapp

### Database connection refused
kubectl exec -it BACKEND_POD -n taskapp -- env | grep DATABASE
kubectl exec -it POSTGRES_POD -n taskapp -- pg_isready -U taskapp

### ImagePullBackOff
kubectl describe pod POD_NAME -n taskapp
docker pull ayodavee/taskapp-backend:v1.0.0

## SSL Issues

### Certificate not issuing
kubectl describe clusterissuer letsencrypt-prod
kubectl describe certificate taskapp-tls -n taskapp
kubectl get certificaterequest -n taskapp
kubectl logs -n cert-manager deploy/cert-manager

### Ingress not working
kubectl describe ingress taskapp-ingress -n taskapp
kubectl get svc -n ingress-nginx
kubectl logs -n ingress-nginx deploy/ingress-nginx-controller

## Networking Issues

### Pods cannot communicate
kubectl get networkpolicy -n taskapp
kubectl describe networkpolicy -n taskapp

### DNS not resolving
kubectl exec -it POD_NAME -n taskapp -- nslookup postgres-svc
kubectl get svc -n taskapp
### DNS not resolving
kubectl exec -it POD_NAME -n taskapp -- nslookup postgres-svc
kubectl get svc -n taskapp
