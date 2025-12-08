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

  role_arn = aws_iam_role.cluster_role.arn

  vpc_config {
    subnet_ids = aws_subnet.private[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

# =====================================================
# IAM Role עבור ה-Worker Nodes (EC2 של ה-Node Group)
# =====================================================
resource "aws_iam_role" "node_role" {
  name = "${local.name_prefix}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# פוליסיז סטנדרטיים לנודים של EKS
resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# ========================
# Managed Node Group
# ========================
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${local.name_prefix}-ng"

  node_role_arn = aws_iam_role.node_role.arn
  subnet_ids    = aws_subnet.private[*].id

  scaling_config {
    desired_size = var.node_desired_size
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }

  instance_types = [var.node_instance_type]
  capacity_type  = "ON_DEMAND"

  # AL2023 זו האופציה המודרנית לנודים מנוהלים
  ami_type  = "AL2023_x86_64_STANDARD"
  disk_size = 20

  tags = {
    Name = "${local.name_prefix}-ng"
    ENV  = var.env
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]
}
 