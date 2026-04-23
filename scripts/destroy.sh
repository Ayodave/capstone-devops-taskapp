#!/bin/bash
set -e

echo "=== TaskApp Destroy Script ==="
echo "WARNING: This will destroy ALL infrastructure"
echo ""
read -p "Type 'DESTROY' to confirm: " confirm
[ "$confirm" != "DESTROY" ] && echo "Aborted" && exit 1

CLUSTER_NAME="taskapp.ayodave.is-a.dev"
KOPS_STATE_STORE="s3://taskapp-kops-state-276945910356"
echo ""
echo "Step 1: Deleting Kubernetes cluster..."
export KOPS_STATE_STORE=$KOPS_STATE_STORE
export AWS_PROFILE=kops
kops delete cluster ${CLUSTER_NAME} --yes
echo ""
echo "Step 2: Destroying Terraform resources..."
cd terraform/
terraform destroy -auto-approve
cd ..
echo ""
echo "Step 2: Destroying Terraform resources..."
cd terraform/
terraform destroy -auto-approve
cd ..
echo ""
echo "=== Destroy Complete ==="
echo "All AWS resources have been deleted"
echo "No further charges will be incurred"
