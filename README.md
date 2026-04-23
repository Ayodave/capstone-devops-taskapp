# Cloud-Native TaskApp Deployment

Production Kubernetes deployment of TaskApp on AWS using
Terraform, Kops, Helm and cert-manager.

## Live Demo

- Frontend: https://taskapp.ayodave.is-a.dev
- Backend API: https://api.ayodave.is-a.dev
- Project Page: https://ayodave.github.io/capstone-devops-taskapp

## Project Overview

This capstone project migrates a containerized TaskApp
(React frontend, Flask backend, PostgreSQL database)
to production-grade AWS infrastructure featuring:

- High availability across 3 AWS Availability Zones
- Automated SSL/TLS with cert-manager and Let's Encrypt
- Infrastructure as Code with Terraform
- Kubernetes cluster management with Kops
- Zero single points of failure

## Architecture

    Internet --> Route53 --> NLB --> NGINX Ingress
                                         |
                              VPC 10.0.0.0/16
                                         |
                    Private Subnets (3 AZs)
                                         |
                    K8s Masters x3 + Workers x3
                                         |
                    Frontend + Backend + PostgreSQL

## Tech Stack

- Cloud: AWS (EC2, VPC, Route53, S3, DynamoDB, EBS)
- IaC: Terraform v1.9.8
- Kubernetes: v1.28.8 managed by Kops v1.28.4
- CNI: Calico (NetworkPolicy support)
- Ingress: NGINX Ingress Controller
- SSL: cert-manager + Let's Encrypt
- Secrets: Sealed Secrets (Bitnami)
- Monitoring: kubectl + kops validate

## Quickstart

### Prerequisites
- AWS CLI configured
- kubectl, kops, terraform, helm installed
- SSH key pair at ~/.ssh/kops-key

### Deploy
    git clone https://github.com/Ayodave/capstone-devops-taskapp.git
    cd capstone-devops-taskapp
    bash scripts/deploy.sh

### Destroy (important - stops AWS charges)
    bash scripts/destroy.sh

## Repository Structure

    capstone-devops-taskapp/
    terraform/          AWS infrastructure (VPC, IAM, DNS)
    kops/               Kubernetes cluster specification
    k8s/base/           Kubernetes manifests
    scripts/            deploy.sh and destroy.sh
    docs/               Architecture, runbook, cost analysis
    index.html          Live progress tracking page

## Documentation

- Architecture: docs/architecture.md
- Runbook: docs/runbook.md
- Cost Analysis: docs/cost-analysis.md

## Security

- No secrets committed to Git
- Sealed Secrets for encrypted secret management
- Private subnet topology
- IAM least privilege
- MFA on AWS root account

## Author

Ayodave — DevOps Capstone Project 2026
GitHub: https://github.com/Ayodave
