provider "aws" {
  region  = var.aws_region
  profile = "terraform"
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  aws_region      = var.aws_region
  project_name    = var.project_name
}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
}

module "dns" {
  source      = "./modules/dns"
  domain_name = var.domain_name
  project_name = var.project_name
}
