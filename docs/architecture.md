# Architecture Documentation

## System Overview

This project deploys a cloud-native TaskApp on AWS using Kubernetes,
managed by Kops with infrastructure provisioned via Terraform.

## Architecture Diagram

    Internet
        |
        +-- Route53 (ayodave.is-a.dev)
        |
        +-- AWS NLB + NGINX Ingress (HTTPS:443)
        |
        +-- VPC 10.0.0.0/16
              |
              +-- Public Subnets x3 AZ
              |   +-- NAT Gateways (one per AZ)
              |
              +-- Private Subnets x3 AZ
                    |
                    +-- K8s Masters x3 (one per AZ)
                    +-- K8s Workers x3 (one per AZ)
                          |
                          +-- Frontend (React, 2 replicas)
                          +-- Backend (Flask, 2 replicas)
                          +-- PostgreSQL (EBS PersistentVolume)

## CIDR Allocation Rationale

- VPC: 10.0.0.0/16 chosen for 65,536 IPs supporting future growth
- Public subnets: 10.0.0.0/24, 10.0.1.0/24, 10.0.2.0/24
- Private subnets: 10.0.10.0/24, 10.0.11.0/24, 10.0.12.0/24
- Each /24 provides 254 usable IPs per subnet
- Gap between public (0-2) and private (10-12) allows future expansion

## High Availability Strategy

- 3 Kubernetes masters across 3 AZs (quorum survives 1 AZ failure)
- 3 NAT Gateways one per AZ (no single point of failure)
- Pod anti-affinity rules spread workloads across nodes
- etcd distributed across 3 masters with hourly S3 backups
- Rolling update strategy with zero unavailable replicas

## Security Model

- Private subnet topology - no public IPs on any nodes
- Calico NetworkPolicy - default deny, explicit allow rules
- IAM least privilege - separate roles for creation vs operation
- Sealed Secrets - encrypted secrets safe to store in Git
- TLS - Let's Encrypt certificates via cert-manager
- No root account usage - dedicated IAM users only
- MFA enabled on AWS root account

## Technology Stack

- Cloud: AWS
- IaC: Terraform v1.9.8
- K8s Management: Kops v1.28.4
- Kubernetes: v1.28.8
- CNI: Calico
- Ingress: NGINX Ingress Controller
- SSL: cert-manager with Let's Encrypt
- Secrets: Sealed Secrets v0.26.0
- Frontend: React
- Backend: Flask
- Database: PostgreSQL 15.4
- Storage: AWS EBS gp3 encrypted

## Design Decisions

1. Kops over EKS - full control over cluster configuration
2. Calico CNI - supports NetworkPolicy for pod-level security
3. Sealed Secrets over AWS Secrets Manager - no extra cost
4. Private topology - security best practice no public node IPs
5. Multi-AZ NAT - eliminates single point of failure for egress
6. Terraform modules - reusable and maintainable infrastructure code
7. Remote state in S3 - team collaboration and state locking
