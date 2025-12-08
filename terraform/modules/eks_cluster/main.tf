// modules/eks_cluster/main.tf

locals {
  name_prefix = "t2e-${var.env}"
}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${local.name_prefix}-vpc"
    ENV  = var.env
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${local.name_prefix}-private-${count.index + 1}"
    ENV  = var.env
  }
}

resource "aws_iam_role" "cluster_role" {
  name = "${local.name_prefix}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}

resource "aws_eks_cluster" "this" {
  name    = local.name_prefix
  version = var.cluster_version

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.cluster_role.arn

  vpc_config {
    subnet_ids = aws_subnet.private[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}






# resource "aws_eks_cluster" "t2e" {
#   name = "t2e-prod"

#   access_config {
#     authentication_mode = "API"
#   }

#   role_arn = aws_iam_role.cluster-role.arn
#   version  = "1.31"
#   vpc_config {
#     subnet_ids = [
#       aws_subnet.private1.id,
#       aws_subnet.private2.id,
#     ]
#   }

#   # Ensure that IAM Role permissions are created before and deleted
#   # after EKS Cluster handling. Otherwise, EKS will not be able to
#   # properly delete EKS managed EC2 infrastructure such as Security Groups.
#   depends_on = [
#     aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
#   ]
# }

# resource "aws_iam_role" "cluster-role" {
#   name = "t2e-prod-cluster-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "sts:AssumeRole",
#           "sts:TagSession"
#         ]
#         Effect = "Allow"
#         Principal = {
#           Service = "eks.amazonaws.com"
#         }
#       },
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.cluster-role.name
# }

# resource "aws_vpc" "t2e-prod" {
#   cidr_block = "10.0.0.0/16"
# }

# resource "aws_subnet" "private1" {
#   vpc_id     = aws_vpc.t2e-prod.id
#   cidr_block = "10.0.1.0/24"
#  availability_zone = "us-east-1a"

#   tags = {
#     Name    = "t2e-prod",
#     ENV     = "prod"
#   }
# }
# resource "aws_subnet" "private2" {
#   vpc_id            = aws_vpc.t2e-prod.id
#   cidr_block        = "10.0.2.0/24"
#   availability_zone = "us-east-1b"

#   tags = {
#     Name = "t2e-prod",
#     ENV = "prod"
# }
# }