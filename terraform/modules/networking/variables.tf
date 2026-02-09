# test write
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

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets (one per AZ)"
  type        = list(string)
}

variable "azs" {
  description = "Availability Zones for subnets"
  type        = list(string)
}
