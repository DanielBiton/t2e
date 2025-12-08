variable "env" {
  description = "Environment name (dev, prod, etc.)"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "CIDRs for private subnets (must match AZs length)"
  type        = list(string)
}

variable "azs" {
  description = "Availability Zones for subnets"
  type        = list(string)
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.31"
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  type        = string
  default     = "t3.small"
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 1
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}



# variable "env" {
#   description = "Environment name (e.g. dev, prod)"
#   type        = string
#   default     = "prod"

#   validation {
#     condition     = contains(["dev", "prod"], var.env)
#     error_message = "env must be one of: dev, prod."
#   }
# }

# variable "cluster_version" {
#   description = "EKS cluster version"
#   type        = string
#   default     = "1.31"
# }