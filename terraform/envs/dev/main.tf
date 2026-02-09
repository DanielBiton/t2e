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
  region  = "us-east-1"
  profile = "daniel-biton-sandbox"
}
## todo: finish split networking module

module "networking" {
  source = "../../modules/networking"

  env                  = "dev"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.10.10.0/24", "10.10.11.0/24"]
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  azs                  = ["us-east-1a", "us-east-1b"]
}

module "eks_cluster" {
  source             = "../../modules/eks_cluster"
  env                = "dev"
  cluster_version    = "1.31"
  vpc_id             = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
}