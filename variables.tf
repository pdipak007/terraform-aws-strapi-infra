variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "root_volume_size" {
  description = "Size of root volume in GB"
  type        = number
  default     = 20
}

variable "ssh_public_key" {
  description = "Public SSH key for EC2 access"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH to EC2 instances"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = false
}

# Strapi Configuration Variables
variable "strapi_app_keys" {
  description = "Strapi APP_KEYS environment variable"
  type        = string
  sensitive   = true
}

variable "strapi_api_token_salt" {
  description = "Strapi API_TOKEN_SALT environment variable"
  type        = string
  sensitive   = true
}

variable "strapi_admin_jwt" {
  description = "Strapi ADMIN_JWT_SECRET environment variable"
  type        = string
  sensitive   = true
}

variable "strapi_jwt_secret" {
  description = "Strapi JWT_SECRET environment variable"
  type        = string
  sensitive   = true
}

variable "node_env" {
  description = "Node environment (development, production)"
  type        = string
  default     = "production"
}

variable "database_client" {
  description = "Database client (sqlite, postgres, mysql)"
  type        = string
  default     = "sqlite"
}

variable "database_filename" {
  description = "Database filename for SQLite"
  type        = string
  default     = ".tmp/data.db"
}
