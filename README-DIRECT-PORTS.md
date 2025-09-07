# ELK Stack with Direct Port Access

This setup configures an ELK (Elasticsearch, Logstash, Kibana) stack with direct port access using the domain `elogs.aldrees.com`. **No reverse proxy is used** - services are accessible directly via domain:port.

## 🚀 Quick Start

```bash
# Run the setup script
./setup-direct-ports.sh
```

## 🌐 Access URLs

All services are accessible directly via domain:port:

- **Kibana**: http://elogs.aldrees.com:5601
- **Elasticsearch API**: http://elogs.aldrees.com:9200  
- **APM Server**: http://elogs.aldrees.com:8200

## 📁 File Structure

```
elk/
├── docker-compose.yml          # Main configuration (no nginx)
├── docker-compose.http.yml     # HTTP configuration (no nginx)
├── docker-compose.dev.yml      # Development configuration (no nginx)
├── setup-direct-ports.sh       # Setup script for direct access
├── apm-server.yml             # APM server configuration
└── README-DIRECT-PORTS.md     # This file
```

## 🔐 Default Credentials

- **Elasticsearch**: `elastic` / `nkiATsBHHFsQvVeY3Zk6`
- **Kibana**: `elastic` / `nkiATsBHHFsQvVeY3Zk6`

## ⚙️ Configuration Details

### What Changed

1. **Removed Nginx**: No reverse proxy - services are exposed directly
2. **Direct Port Access**: Each service is accessible on its own port
3. **Updated Base URLs**: Kibana configured to work with direct port access
4. **Simplified Setup**: No SSL certificates or Nginx configuration needed

### Port Mapping

| Service | Internal Port | External Port | URL |
|---------|---------------|---------------|-----|
| Kibana | 5601 | 5601 | http://elogs.aldrees.com:5601 |
| Elasticsearch | 9200 | 9200 | http://elogs.aldrees.com:9200 |
| APM Server | 8200 | 8200 | http://elogs.aldrees.com:8200 |

## 🔧 Setup Instructions

### 1. DNS Configuration
Add an A record pointing `elogs.aldrees.com` to your server's IP address:
```
elogs.aldrees.com.  IN  A  YOUR_SERVER_IP
```

### 2. Firewall Configuration
Open the required ports:
```bash
# Allow direct access ports
sudo ufw allow 5601/tcp  # Kibana
sudo ufw allow 9200/tcp  # Elasticsearch  
sudo ufw allow 8200/tcp  # APM Server
```

### 3. Start Services
```bash
# Run the setup script
./setup-direct-ports.sh

# Or manually
docker compose up -d
```

## 🐳 Docker Commands

### Start Services
```bash
docker compose up -d
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
docker compose logs -f kibana
docker compose logs -f elasticsearch
docker compose logs -f apm-server
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

### Test Direct Access
```bash
# Test Kibana
curl http://elogs.aldrees.com:5601/api/status

# Test Elasticsearch
curl -u elastic:nkiATsBHHFsQvVeY3Zk6 http://elogs.aldrees.com:9200/_cluster/health

# Test APM Server
curl http://elogs.aldrees.com:8200
```

### Common Issues

1. **Port Already in Use**: Ensure ports 5601, 9200, and 8200 are not used by other services
2. **DNS Resolution**: Verify DNS is pointing to the correct IP address
3. **Firewall Blocking**: Check if firewall is blocking the ports
4. **Network Issues**: Check if the `elasticnet` Docker network exists

## 📊 Monitoring

### Health Checks
```bash
# Elasticsearch health
curl -u elastic:nkiATsBHHFsQvVeY3Zk6 http://elogs.aldrees.com:9200/_cluster/health

# Kibana status
curl http://elogs.aldrees.com:5601/api/status

# APM Server
curl http://elogs.aldrees.com:8200
```

## 🔒 Security Considerations

1. **Direct Port Exposure**: Services are directly accessible - consider firewall rules
2. **No SSL**: HTTP only - for production, consider using HTTPS
3. **Authentication**: Elasticsearch security is enabled with default credentials
4. **Network Security**: Ensure only authorized networks can access these ports

## 📝 Notes

- This setup is simpler than the reverse proxy version
- No SSL certificates or Nginx configuration needed
- Each service is independently accessible
- Useful for development or internal networks
- For production, consider adding SSL/TLS termination at the load balancer level

## 🔄 Migration from Reverse Proxy

If you're migrating from the reverse proxy setup:

1. Stop the current services: `docker compose down`
2. Run the new setup: `./setup-direct-ports.sh`
3. Update any client configurations to use the new URLs
4. Update firewall rules to allow direct port access
