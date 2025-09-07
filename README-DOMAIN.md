# ELK Stack with Domain Configuration

This setup configures an ELK (Elasticsearch, Logstash, Kibana) stack with the domain `elogs.aldrees.com` using Nginx as a reverse proxy.

## 🚀 Quick Start

### Development Setup (HTTP)
```bash
# Start with development configuration (HTTP only)
docker compose -f docker-compose.dev.yml up -d
```

### Production Setup (HTTPS)
```bash
# 1. Add SSL certificates to ssl/ directory
# 2. Run the setup script
./setup-domain.sh
```

## 📁 File Structure

```
elk/
├── docker-compose.yml          # Production configuration with HTTPS
├── docker-compose.dev.yml      # Development configuration with HTTP
├── nginx.conf                  # Production Nginx configuration
├── nginx-dev.conf             # Development Nginx configuration
├── ssl/                       # SSL certificates directory
│   ├── elogs.aldrees.com.crt  # SSL certificate
│   ├── elogs.aldrees.com.key  # Private key
│   └── README.md              # SSL setup instructions
├── .htpasswd                  # Basic auth credentials
├── setup-domain.sh            # Setup script
└── README-DOMAIN.md           # This file
```

## 🌐 Access URLs

### Production (HTTPS)
- **Kibana**: https://elogs.aldrees.com
- **Elasticsearch API**: https://elogs.aldrees.com/elasticsearch/
- **APM Server**: https://elogs.aldrees.com/apm/
- **Health Check**: https://elogs.aldrees.com/health

### Development (HTTP)
- **Kibana**: http://elogs.aldrees.com
- **Elasticsearch API**: http://elogs.aldrees.com/elasticsearch/
- **APM Server**: http://elogs.aldrees.com/apm/
- **Health Check**: http://elogs.aldrees.com/health

## 🔐 Default Credentials

- **Elasticsearch**: `elastic` / `nkiATsBHHFsQvVeY3Zk6`
- **Kibana**: `elastic` / `nkiATsBHHFsQvVeY3Zk6`
- **Nginx Basic Auth**: `admin` / `password`

## ⚙️ Configuration Details

### Nginx Reverse Proxy Features

1. **SSL/TLS Support**: Automatic HTTP to HTTPS redirect
2. **Rate Limiting**: API protection against abuse
3. **Security Headers**: XSS protection, content type sniffing prevention
4. **WebSocket Support**: For Kibana real-time features
5. **Basic Authentication**: For Elasticsearch API access
6. **Health Check Endpoint**: For monitoring

### Rate Limiting
- **API endpoints**: 10 requests/second with burst of 20
- **Login endpoints**: 1 request/second
- **APM endpoints**: 10 requests/second with burst of 50

## 🔧 Setup Instructions

### 1. DNS Configuration
Add an A record pointing `elogs.aldrees.com` to your server's IP address:
```
elogs.aldrees.com.  IN  A  YOUR_SERVER_IP
```

### 2. SSL Certificates (Production)

#### Option A: Let's Encrypt (Recommended)
```bash
# Install certbot
sudo apt-get install certbot

# Get certificate
sudo certbot certonly --standalone -d elogs.aldrees.com

# Copy certificates
sudo cp /etc/letsencrypt/live/elogs.aldrees.com/fullchain.pem ./ssl/elogs.aldrees.com.crt
sudo cp /etc/letsencrypt/live/elogs.aldrees.com/privkey.pem ./ssl/elogs.aldrees.com.key

# Set permissions
chmod 644 ssl/elogs.aldrees.com.crt
chmod 600 ssl/elogs.aldrees.com.key
```

#### Option B: Self-signed (Development only)
```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout ssl/elogs.aldrees.com.key \
  -out ssl/elogs.aldrees.com.crt \
  -subj "/C=SA/ST=Riyadh/L=Riyadh/O=Aldrees/CN=elogs.aldrees.com"
```

### 3. Authentication Setup
```bash
# Create new htpasswd file
htpasswd -c .htpasswd your_username
```

### 4. Firewall Configuration
```bash
# Allow HTTP and HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

## 🐳 Docker Commands

### Start Services
```bash
# Production
docker compose up -d

# Development
docker compose -f docker-compose.dev.yml up -d
```

### Stop Services
```bash
docker compose down
```

### View Logs
```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f nginx
docker compose logs -f kibana
docker compose logs -f elasticsearch
```

### Restart Services
```bash
docker compose restart
```

## 🔍 Troubleshooting

### Check Service Status
```bash
docker compose ps
```

### Test Nginx Configuration
```bash
docker exec nginx-proxy nginx -t
```

### Check SSL Certificate
```bash
openssl x509 -in ssl/elogs.aldrees.com.crt -text -noout
```

### Test Domain Resolution
```bash
nslookup elogs.aldrees.com
```

### Common Issues

1. **SSL Certificate Errors**: Ensure certificates are in the correct format and location
2. **DNS Resolution**: Verify DNS is pointing to the correct IP address
3. **Port Conflicts**: Ensure ports 80 and 443 are not in use by other services
4. **Network Issues**: Check if the `elasticnet` Docker network exists

## 📊 Monitoring

### Health Check
```bash
curl https://elogs.aldrees.com/health
```

### Service Status
```bash
# Elasticsearch
curl -u elastic:nkiATsBHHFsQvVeY3Zk6 https://elogs.aldrees.com/elasticsearch/_cluster/health

# Kibana
curl https://elogs.aldrees.com/api/status
```

## 🔒 Security Considerations

1. **Change Default Passwords**: Update all default credentials
2. **Use Strong SSL**: Replace self-signed certificates with proper SSL certificates
3. **Restrict Access**: Configure firewall rules to limit access
4. **Regular Updates**: Keep Docker images and SSL certificates updated
5. **Backup**: Regularly backup Elasticsearch data and configuration

## 📝 Notes

- The development configuration uses HTTP for easier testing
- Production should always use HTTPS with proper SSL certificates
- Rate limiting helps protect against abuse but may need adjustment based on usage
- The setup includes basic authentication for Elasticsearch API access
- WebSocket support is enabled for Kibana's real-time features
