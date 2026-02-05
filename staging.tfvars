# AWS Configuration
aws_region = "us-east-1"

# Project Configuration
project_name = "strapi-app"
environment  = "staging"

# VPC Configuration
vpc_cidr             = "10.2.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.2.1.0/24", "10.2.2.0/24"]
private_subnet_cidrs = ["10.2.11.0/24", "10.2.12.0/24"]

# EC2 Configuration
instance_type    = "t3.small"
root_volume_size = 20

# SSH Configuration
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD... your-staging-public-key-here"

allowed_ssh_cidrs = ["0.0.0.0/0"]

# ALB Configuration
enable_deletion_protection = false

# Strapi Configuration
strapi_app_keys       = "staging-app-key-1,staging-app-key-2,staging-app-key-3,staging-app-key-4"
strapi_api_token_salt = "staging-api-token-salt"
strapi_admin_jwt      = "staging-admin-jwt-secret"
strapi_jwt_secret     = "staging-jwt-secret"

# Application Configuration
node_env          = "production"
database_client   = "sqlite"
database_filename = ".tmp/data.db"
