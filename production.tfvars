# AWS Configuration
aws_region = "us-east-1"

# Project Configuration
project_name = "strapi-app"
environment  = "prod"

# VPC Configuration
vpc_cidr             = "10.1.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.11.0/24", "10.1.12.0/24"]

# EC2 Configuration
instance_type    = "t3.medium"
root_volume_size = 30

# SSH Configuration
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD... your-production-public-key-here"

# Restrict SSH to specific IPs in production
allowed_ssh_cidrs = ["YOUR_OFFICE_IP/32"]

# ALB Configuration
enable_deletion_protection = true

# Strapi Configuration (USE DIFFERENT SECRETS FOR PRODUCTION)
strapi_app_keys       = "prod-app-key-1,prod-app-key-2,prod-app-key-3,prod-app-key-4"
strapi_api_token_salt = "prod-api-token-salt"
strapi_admin_jwt      = "prod-admin-jwt-secret"
strapi_jwt_secret     = "prod-jwt-secret"

# Application Configuration
node_env          = "production"
database_client   = "sqlite"
database_filename = ".tmp/data.db"
