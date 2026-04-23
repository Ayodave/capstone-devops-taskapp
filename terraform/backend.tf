terraform {
  backend "s3" {
    bucket         = "taskapp-terraform-state-276945910356"
    key            = "taskapp/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "taskapp-terraform-lock"
    encrypt        = true
    profile        = "terraform"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}
