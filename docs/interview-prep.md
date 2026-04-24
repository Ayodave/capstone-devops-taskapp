# Interview Preparation Notes

## Project Summary (30 second pitch)

"I built a cloud-native TaskApp on AWS using Kubernetes.
The project uses Terraform for infrastructure, Kops to manage
a 3-master HA Kubernetes cluster across 3 availability zones,
with automated SSL via cert-manager and CI/CD via GitHub Actions.
Everything is Infrastructure as Code with zero manual clicking."

## Key Technical Questions

### Why Kops over EKS?
Kops gives full control over cluster configuration including
networking, etcd, and master nodes. EKS abstracts the control
plane which reduces learning. For a capstone showing deep
Kubernetes knowledge, Kops is more impressive.

### How does your HA setup work?
3 Kubernetes masters across 3 AZs provide etcd quorum.
If one AZ fails, 2 masters remain and the cluster keeps running.
3 NAT gateways mean no single point of failure for egress traffic.
PodDisruptionBudgets ensure minimum replicas during node maintenance.

### How do you handle secrets?
Sealed Secrets encrypts Kubernetes secrets using the cluster
public key. The encrypted SealedSecret can be safely committed
to Git. Only the cluster can decrypt it. This is GitOps-friendly
secret management without AWS Secrets Manager costs.

### What is Calico CNI and why use it?
Calico is a Container Network Interface plugin that enables
Kubernetes NetworkPolicy. Without Calico, NetworkPolicy objects
exist but have no effect. With Calico, we enforce default-deny
and only allow specific pod-to-pod communication paths.

### Explain your Terraform module structure
Three modules: vpc (networking), iam (roles), dns (Route53).
Remote state stored in S3 with DynamoDB locking prevents
concurrent applies. Each module has clear inputs and outputs
for reusability and testing.

### What would you do differently in production?
1. Use EBS CSI driver with encrypted gp3 volumes
2. Enable AWS GuardDuty for threat detection
3. Add Prometheus and Grafana for observability
4. Use AWS ACM instead of Let's Encrypt for certificates
5. Implement Velero for cluster backup and restore
6. Add pod security admission policies
