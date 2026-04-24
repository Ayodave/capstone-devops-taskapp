# Cloud-Native TaskApp Deployment

![CI Pipeline](https://github.com/Ayodave/capstone-devops-taskapp/actions/workflows/ci.yaml/badge.svg)
![Docker Backend](https://img.shields.io/docker/v/ayodavee/taskapp-backend?label=backend)
![Docker Frontend](https://img.shields.io/docker/v/ayodavee/taskapp-frontend?label=frontend)

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
- CI/CD with GitHub Actions

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
- CI/CD: GitHub Actions
- Images: Docker Hub (ayodavee)

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
    .github/workflows/  CI/CD pipeline
    index.html          Live progress tracking page

## Docker Images

- Backend: docker.io/ayodavee/taskapp-backend:v1.0.0
- Frontend: docker.io/ayodavee/taskapp-frontend:v1.0.0

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
- Network policies enforced

## Author

Ayodave — DevOps Capstone Project 2026
GitHub: https://github.com/Ayodave
Docker Hub: https://hub.docker.com/u/ayodavee
- Private subnet topology
- IAM least privilege
- Network policies enforced

## Author

Ayodave - DevOps Capstone Project 2026
GitHub: https://github.com/Ayodave
Docker Hub: https://hub.docker.com/u/ayodavee
