// envs/prod/main.tf

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
  source             = "../../modules/eks_cluster"
  env                = "prod"
  cluster_version    = "1.31"
  vpc_id             = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
}
