# Operational Runbook

## Prerequisites

- AWS CLI configured with terraform and kops profiles
- kubectl installed
- Kops installed
- Terraform installed
- Helm installed

## How to Deploy the Application

1. Clone the repository
   git clone https://github.com/Ayodave/capstone-devops-taskapp.git
   cd capstone-devops-taskapp

2. Run the deploy script
   bash scripts/deploy.sh

3. Verify deployment
   kubectl get nodes
   kubectl get pods -n taskapp

## How to Scale the Cluster

Scale worker nodes up:
   kops edit ig nodes-us-east-1a
   Change maxSize and minSize values
   kops update cluster taskapp.ayodave.is-a.dev --yes
   kops rolling-update cluster taskapp.ayodave.is-a.dev --yes

Scale application pods:
   kubectl scale deployment backend --replicas=4 -n taskapp
   kubectl scale deployment frontend --replicas=4 -n taskapp

## How to Rotate Secrets

1. Generate new sealed secret
   kubectl create secret generic db-credentials \
     --from-literal=POSTGRES_USER=taskapp \
     --from-literal=POSTGRES_PASSWORD=NEW_PASSWORD \
     --namespace=taskapp \
     --dry-run=client -o yaml > /tmp/new-secret.yaml

2. Seal the secret
   kubeseal --format yaml < /tmp/new-secret.yaml > k8s/base/sealed-db-secret.yaml

3. Apply the new sealed secret
   kubectl apply -f k8s/base/sealed-db-secret.yaml

4. Delete temp file
   rm /tmp/new-secret.yaml

## Troubleshooting Common Failures

Pod not starting:
   kubectl describe pod POD_NAME -n taskapp
   kubectl logs POD_NAME -n taskapp

Node not ready:
   kubectl describe node NODE_NAME
   kops validate cluster taskapp.ayodave.is-a.dev

Certificate not issuing:
   kubectl describe certificate taskapp-tls -n taskapp
   kubectl describe certificaterequest -n taskapp

Database connection failed:
   kubectl exec -it POD_NAME -n taskapp -- pg_isready -U taskapp

## How to Destroy All Infrastructure

   bash scripts/destroy.sh
   Type DESTROY when prompted
