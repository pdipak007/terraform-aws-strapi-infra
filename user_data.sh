#!/bin/bash

# Update system
dnf update -y

# Install Docker
dnf install -y docker

# Start and enable Docker service
systemctl start docker
systemctl enable docker

# Add ec2-user to docker group
usermod -aG docker ec2-user

# Create directory for Strapi data
mkdir -p /opt/strapi/data
chmod -R 755 /opt/strapi

# Create Strapi configuration
cat > /opt/strapi/.env << 'EOF'
APP_KEYS=${strapi_app_keys}
API_TOKEN_SALT=${strapi_api_token_salt}
ADMIN_JWT_SECRET=${strapi_admin_jwt}
JWT_SECRET=${strapi_jwt_secret}
NODE_ENV=${node_env}
DATABASE_CLIENT=${database_client}
DATABASE_FILENAME=${database_filename}
HOST=0.0.0.0
PORT=1337
EOF

# Pull and run Strapi container
docker run -d \
  --name strapi \
  --restart unless-stopped \
  -p 1337:1337 \
  -v /opt/strapi/data:/opt/app/data \
  --env-file /opt/strapi/.env \
  strapi/strapi:latest

# Wait for Strapi to start
sleep 30

# Check if Strapi is running
docker ps | grep strapi

# Setup log rotation for Docker
cat > /etc/logrotate.d/docker << 'EOF'
/var/lib/docker/containers/*/*.log {
    rotate 7
    daily
    compress
    missingok
    delaycompress
    copytruncate
}
EOF

# Create a health check script
cat > /usr/local/bin/strapi-health-check.sh << 'HEALTH_EOF'
#!/bin/bash
if ! docker ps | grep -q strapi; then
    docker start strapi
fi
HEALTH_EOF

chmod +x /usr/local/bin/strapi-health-check.sh

# Add health check to cron (every 5 minutes)
echo "*/5 * * * * /usr/local/bin/strapi-health-check.sh" | crontab -

# Log completion
echo "Strapi setup completed at $(date)" >> /var/log/user-data.log
