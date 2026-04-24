#!/bin/bash
set -e

echo "=== Creating Sealed Secrets ==="
echo "This script requires kubeseal and kubectl connected to cluster"

read -sp "Enter POSTGRES_PASSWORD: " DB_PASSWORD
echo ""
read -sp "Enter SECRET_KEY: " SECRET_KEY
echo ""

kubectl create secret generic db-credentials \
  --from-literal=POSTGRES_USER=taskapp \
  --from-literal=POSTGRES_PASSWORD=${DB_PASSWORD} \
  --from-literal=SECRET_KEY=${SECRET_KEY} \
  --namespace=taskapp \
  --dry-run=client -o yaml > /tmp/db-secret.yaml

kubeseal --format yaml < /tmp/db-secret.yaml > k8s/base/sealed-db-secret.yaml
rm /tmp/db-secret.yaml

echo "Sealed secret created at k8s/base/sealed-db-secret.yaml"
echo "Safe to commit to Git"
