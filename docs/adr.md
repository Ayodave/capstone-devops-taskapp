# Architecture Decision Records

## ADR-001: Use Kops over EKS

Status: Accepted

Context:
Need a managed Kubernetes cluster on AWS for a capstone project.
Options were EKS (managed control plane) or Kops (self-managed).

Decision:
Use Kops to self-manage the Kubernetes cluster.

Reasons:
- Full control over cluster configuration
- Demonstrates deeper Kubernetes knowledge
- No EKS management fee ($0.10 per hour saved)
- etcd access and configuration control
- Custom AMI and instance type selection

Consequences:
- Must manage master node upgrades manually
- Responsible for etcd backups
- More complex initial setup

## ADR-002: Use Calico CNI over Flannel

Status: Accepted

Context:
Kubernetes requires a CNI plugin for pod networking.
Options were Flannel (simple) or Calico (advanced).

Decision:
Use Calico CNI.

Reasons:
- Supports Kubernetes NetworkPolicy enforcement
- Default deny all traffic security posture
- Production-grade network security
- Required for pod-level firewall rules

Consequences:
- Slightly more complex configuration
- Higher memory usage per node

## ADR-003: Use Sealed Secrets over AWS Secrets Manager

Status: Accepted

Context:
Need to store sensitive credentials securely in a GitOps workflow.

Decision:
Use Bitnami Sealed Secrets.

Reasons:
- Free (no AWS Secrets Manager cost)
- GitOps friendly - encrypted secrets in Git
- No application code changes required
- Works with standard Kubernetes secrets API

Consequences:
- Secrets tied to specific cluster
- Must re-seal secrets if cluster is rebuilt

## ADR-004: Use Docker Hub over ECR

Status: Accepted

Context:
Need a container registry to store Docker images.

Decision:
Use Docker Hub public repositories.

Reasons:
- Free for public images
- No ECR authentication complexity
- Images available globally
- CI/CD integration is simpler

Consequences:
- Images are publicly visible
- Rate limiting on pulls (solved with Docker Hub login)
Decision:
Use Bitnami Sealed Secrets.
Reasons:
- GitOps friendly - encrypted secrets safe to commit
- No additional AWS cost unlike Secrets Manager
- Works entirely within Kubernetes cluster
- kubeseal CLI integrates with existing workflow
Consequences:
- Secrets tied to cluster - must backup sealing key
- Cannot share secrets across clusters easily
