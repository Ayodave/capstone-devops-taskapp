# Cost Analysis

## Monthly Cost Estimate (Cluster Running 24/7)

| Resource | Count | Unit Cost | Monthly Cost |
|----------|-------|-----------|--------------|
| t3.medium EC2 (masters) | 3 | $30/mo | $90 |
| t3.large EC2 (workers) | 3 | $60/mo | $180 |
| NAT Gateway | 3 | $32/mo | $96 |
| EBS gp3 20GB (postgres) | 1 | $1.60/mo | $1.60 |
| EBS volumes for nodes | 6 | $8/mo | $48 |
| S3 state buckets | 2 | $1/mo | $2 |
| Route53 hosted zone | 1 | $0.50/mo | $0.50 |
| Data transfer | est | variable | $20 |
| **TOTAL** | | | **$438/mo** |

## Actual Project Cost (Development Strategy)

This project uses a cost-minimization strategy:
- Weeks 1-2: Zero cost (local Minikube development)
- Week 3: AWS sprint only (2-3 days maximum)

Estimated sprint cost:
- Day 1 cluster running 8 hours: $438 x (8/720) = ~$5
- Day 2 demo and screenshots 8 hours: ~$5
- Total estimated project cost: $10-20

## Cost Optimization Recommendations

1. Use spot instances for worker nodes (saves 70%)
2. Scale down masters to t3.small for non-production
3. Use single NAT Gateway for dev (saves $64/mo)
4. Enable cluster autoscaler to scale to zero when idle
5. Use AWS Savings Plans for production workloads

## Free Tier Usage

The following resources are within AWS free tier:
- S3: First 5GB storage free
- DynamoDB: 25GB storage free (state locking table)
- CloudWatch: Basic monitoring free

## Budget Alert

A budget alert has been configured at $1 (zero spend)
to notify immediately when any charges appear.
Alert email: davidleejay591@gmail.com

## Cleanup

Always run destroy.sh after completing work:
   bash scripts/destroy.sh

This ensures no resources continue running unnecessarily.
