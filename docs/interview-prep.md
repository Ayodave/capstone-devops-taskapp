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

## More Technical Questions

### What is etcd and why does it matter?
etcd is a distributed key-value store that Kubernetes uses
to store all cluster state. Masters run etcd in a 3-node
cluster for quorum. If etcd is lost the cluster cannot
function. We back up etcd to S3 every hour using etcd-manager.

### Explain rolling updates in Kubernetes
Rolling updates replace pods gradually with zero downtime.
maxSurge=1 means one extra pod is created first.
maxUnavailable=0 means no pods are removed until new one is ready.
This ensures the app is always available during deployments.

### What is a PodDisruptionBudget?
A PDB limits how many pods can be unavailable during voluntary
disruptions like node maintenance. minAvailable=1 means at
least one backend pod must always be running even when a node
is drained for updates.

### How does cert-manager work?
cert-manager watches for Certificate and Ingress resources.
When it sees a ClusterIssuer annotation it creates an ACME
challenge with Let's Encrypt, proves domain ownership via
HTTP-01 challenge through the NGINX ingress, then stores
the certificate as a Kubernetes Secret.

### What is the difference between a Secret and SealedSecret?
A Kubernetes Secret is base64 encoded but not encrypted.
Anyone with cluster access can decode it. A SealedSecret
is asymmetrically encrypted using the cluster public key.
Only the Sealed Secrets controller with the private key
can decrypt it making it safe to commit to Git.

### How would you debug a pod that keeps restarting?
1. kubectl describe pod - check Events section
2. kubectl logs pod --previous - logs from crashed container
3. Check resource limits - OOMKilled means out of memory
4. Check liveness probe - failing probe causes restarts
5. Check image - ImagePullBackOff means wrong tag or credentials

### What is Calico and how does NetworkPolicy work?
Calico is a CNI that implements NetworkPolicy enforcement.
Our default-deny policy blocks all traffic by default.
Explicit allow policies then permit only required paths:
ingress-nginx to frontend, frontend to backend, backend to postgres.
This is zero trust networking at the pod level.
