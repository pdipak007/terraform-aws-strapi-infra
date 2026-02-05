# Terraform AWS Strapi Infrastructure

This Terraform project deploys a complete AWS infrastructure for running Strapi CMS with the following architecture:

##  Architecture Overview

- **VPC** with public and private subnets across 2 availability zones
- **Internet Gateway** for public subnet internet access
- **NAT Gateway** for private subnet outbound internet access
- **Application Load Balancer (ALB)** in public subnets
- **EC2 Instance** in private subnet running Strapi in Docker
- **Security Groups** for controlled access
- **IAM Roles** for EC2 instance permissions

##  Prerequisites

Before you begin, ensure you have:

1. **Terraform** installed (version 1.0+)
   ```bash
   terraform --version
   ```

2. **AWS CLI** configured with appropriate credentials
   ```bash
   aws configure
   ```

3. **SSH Key Pair** generated
   ```bash
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/strapi-key -N ""
   ```

##  Quick Start

### Step 1: Clone and Setup

```bash
# Navigate to project directory
cd terraform-strapi-infrastructure

# Copy example tfvars file
cp terraform.tfvars.example terraform.tfvars
```

### Step 2: Configure Variables

Edit `terraform.tfvars` and update the following:

```bash
# Generate Strapi secrets
openssl rand -base64 32  # Run this 4 times for different secrets

# Get your public IP
curl https://ifconfig.me

# Get your SSH public key
cat ~/.ssh/strapi-key.pub
```

Update `terraform.tfvars`:
```hcl
# Replace with your actual values
ssh_public_key    = "ssh-rsa AAAAB3NzaC1yc2EA... (your actual public key)"
allowed_ssh_cidrs = ["YOUR_IP/32"]  # Replace YOUR_IP with your actual IP

# Use the generated secrets
strapi_app_keys       = "secret1,secret2,secret3,secret4"
strapi_api_token_salt = "your-generated-token-salt"
strapi_admin_jwt      = "your-generated-admin-jwt"
strapi_jwt_secret     = "your-generated-jwt-secret"
```

### Step 3: Initialize Terraform

```bash
terraform init
```

### Step 4: Plan the Deployment

```bash
# For development environment
terraform plan -var-file="terraform.tfvars"

# For staging environment
terraform plan -var-file="staging.tfvars"

# For production environment
terraform plan -var-file="production.tfvars"
```

### Step 5: Deploy Infrastructure

```bash
# For development environment
terraform apply -var-file="terraform.tfvars"

# For staging environment
terraform apply -var-file="staging.tfvars"

# For production environment
terraform apply -var-file="production.tfvars"
```

Type `yes` when prompted to confirm the deployment.

### Step 6: Access Your Strapi Application

After deployment completes (takes ~5-10 minutes):

```bash
# Get the ALB URL
terraform output alb_url
```

Open the URL in your browser. Wait 2-3 minutes for Strapi to fully initialize.

Access Strapi admin panel at: `http://<alb-dns-name>/admin`

##  Project Structure

```
.
├── main.tf                      # Main infrastructure configuration
├── variables.tf                 # Variable definitions
├── outputs.tf                   # Output definitions
├── user_data.sh                 # EC2 initialization script
├── terraform.tfvars.example     # Example variables (dev)
├── staging.tfvars              # Staging environment variables
├── production.tfvars           # Production environment variables
├── .gitignore                  # Git ignore file
└── README.md                   # This file
```

##  Infrastructure Components

### VPC Configuration
- **CIDR Block**: Configurable (default: 10.0.0.0/16)
- **Public Subnets**: 2 subnets across different AZs
- **Private Subnets**: 2 subnets across different AZs

### Security Groups
1. **ALB Security Group**
   - Inbound: HTTP (80), HTTPS (443) from anywhere
   - Outbound: All traffic

2. **EC2 Security Group**
   - Inbound: Port 1337 from ALB, SSH from allowed CIDRs
   - Outbound: All traffic

### EC2 Instance
- **AMI**: Latest Amazon Linux 2023
- **Instance Type**: Configurable (t3.small for dev, t3.medium for prod)
- **Docker**: Auto-installed via user_data
- **Strapi**: Running in Docker container
- **Auto-restart**: Health check every 5 minutes

##  Security Best Practices

1. **SSH Access**: Restrict `allowed_ssh_cidrs` to your IP only
2. **Secrets**: Never commit `.tfvars` files with real secrets
3. **Encryption**: EBS volumes are encrypted by default
4. **IAM**: Least privilege access with SSM for instance management
5. **Network**: EC2 in private subnet, only ALB is public

##  Outputs

After deployment, you'll get:

```bash
terraform output
```

Key outputs:
- `alb_url`: URL to access Strapi application
- `alb_dns_name`: ALB DNS name
- `ec2_instance_id`: EC2 instance ID
- `ec2_private_ip`: Private IP of EC2 instance
- `vpc_id`: VPC ID

##  Multi-Environment Management

### Development
```bash
terraform workspace new dev
terraform apply -var-file="terraform.tfvars"
```

### Staging
```bash
terraform workspace new staging
terraform apply -var-file="staging.tfvars"
```

### Production
```bash
terraform workspace new prod
terraform apply -var-file="production.tfvars"
```

##  Common Commands

### View Current Infrastructure
```bash
terraform show
```

### Refresh State
```bash
terraform refresh
```

### View Specific Output
```bash
terraform output alb_url
```

### Format Terraform Files
```bash
terraform fmt
```

### Validate Configuration
```bash
terraform validate
```

### Destroy Infrastructure
```bash
# CAUTION: This will delete everything!
terraform destroy -var-file="terraform.tfvars"
```

##  Troubleshooting

### Strapi Not Loading
1. Wait 3-5 minutes after deployment for Strapi to initialize
2. Check EC2 instance logs:
   ```bash
   # Get instance ID
   terraform output ec2_instance_id
   
   # View user_data logs (requires AWS CLI and SSM)
   aws ssm start-session --target <instance-id>
   sudo tail -f /var/log/user-data.log
   sudo docker logs strapi
   ```

### ALB Health Check Failing
```bash
# Check target health
aws elbv2 describe-target-health \
  --target-group-arn $(terraform output -raw target_group_arn)
```

### SSH Connection
```bash
# Using SSH (from bastion or if you've configured it)
ssh -i ~/.ssh/strapi-key ec2-user@<private-ip>

# Using SSM Session Manager (recommended)
aws ssm start-session --target <instance-id>
```

### Docker Container Issues
```bash
# SSH into instance, then:
sudo docker ps
sudo docker logs strapi
sudo docker restart strapi
```


**Note**: NAT Gateway is the most expensive component. For cost savings in dev/staging, you could temporarily destroy it when not in use.

**Created by**: Dipak Purane  

