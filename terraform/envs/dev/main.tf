// envs/dev/main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "daniel-biton-sandbox"
}

module "eks_cluster" {
  source = "../../modules/eks_cluster"

  env                  = "dev"
  vpc_cidr             = "10.10.0.0/16"
  public_subnet_cidrs  = ["10.10.10.0/24", "10.10.11.0/24"]
  private_subnet_cidrs = ["10.10.1.0/24", "10.10.2.0/24"]
  azs                  = ["us-east-1a", "us-east-1b"]
  cluster_version      = "1.31"
}