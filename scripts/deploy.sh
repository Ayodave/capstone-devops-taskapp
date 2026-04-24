#!/bin/bash
set -e

echo "=== TaskApp Deployment Script ==="

CLUSTER_NAME="taskapp.ayodave.is-a.dev"
KOPS_STATE_STORE="s3://taskapp-kops-state-276945910356"
echo ""
echo "Step 1: Applying Terraform infrastructure..."
cd terraform/
terraform init
terraform apply -auto-approve
cd ..
echo ""
echo "Step 2: Creating Kops cluster..."
export KOPS_STATE_STORE=$KOPS_STATE_STORE
export AWS_PROFILE=kops
kops create -f kops/cluster.yaml
kops create secret --name ${CLUSTER_NAME} sshpublickey admin -i ~/.ssh/kops-key.pub
kops update cluster ${CLUSTER_NAME} --yes
echo ""
echo "Step 3: Waiting for cluster..."
kops validate cluster --wait 15m --count 3
echo ""
echo "Step 4: Installing Helm charts..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add jetstack https://charts.jetstack.io
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace --wait

helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager --create-namespace \
  --set installCRDs=true --wait

helm install sealed-secrets sealed-secrets/sealed-secrets \
  --namespace kube-system --wait
echo ""
echo "Step 5: Deploying application..."
kubectl apply -f k8s/base/namespace.yaml
kubectl apply -f k8s/base/

echo ""
echo "=== Deployment Complete ==="
echo "Run: kubectl get pods -n taskapp"
echo ""
echo "Step 6: Installing monitoring..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl apply -f k8s/base/monitoring-namespace.yaml
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --values helm/prometheus-values.yaml \
  --wait

echo ""
echo "Step 7: Running demo checks..."
bash scripts/demo.sh
