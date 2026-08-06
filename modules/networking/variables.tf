variable "env_name" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for resource names, e.g. Aneeta"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "azs" {
  description = "Availability zones to use"
  type        = list(string)
}