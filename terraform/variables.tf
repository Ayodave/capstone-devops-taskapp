variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "project_name" {
  description = "Project name used for tagging"
  type        = string
  default     = "taskapp"
}

variable "domain_name" {
  description = "Domain name for Route53"
  type        = string
  default     = "ayodave.is-a.dev"
}

variable "cluster_name" {
  description = "Kubernetes cluster name"
  type        = string
  default     = "taskapp.ayodave.is-a.dev"
}
