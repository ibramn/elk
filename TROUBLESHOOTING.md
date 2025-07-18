# ELK Stack Authentication Troubleshooting

## Current Issue: "Forbidden" Error with elastic user

### Solution 1: Use the setup script (Recommended)

1. **Restart your containers:**
   ```bash
   docker-compose down
   docker-compose up -d
   ```

2. **Wait for Elasticsearch to be ready (2-3 minutes), then run:**
   ```bash
   ./setup-users.sh
   ```

3. **Access Kibana at http://your-server:5601 and login with:**
   - Username: `superuser`
   - Password: `MG0nM0*BmGzOXxFAi59`

### Solution 2: Manual User Setup

If the script doesn't work, manually set up users:

1. **Wait for Elasticsearch to be ready, then run:**
   ```bash
   # Set kibana_system password
   curl -X POST -u elastic:MG0nM0*BmGzOXxFAi59 \
     -H "Content-Type: application/json" \
     -d '{"password":"MG0nM0*BmGzOXxFAi59"}' \
     http://localhost:9200/_security/user/kibana_system/_password
   ```

2. **Create a superuser:**
   ```bash
   curl -X POST -u elastic:MG0nM0*BmGzOXxFAi59 \
     -H "Content-Type: application/json" \
     -d '{
       "password": "MG0nM0*BmGzOXxFAi59",
       "roles": ["superuser"],
       "full_name": "Super User"
     }' \
     http://localhost:9200/_security/user/superuser
   ```

### Solution 3: Disable Security (Development Only)

If you're in development and don't need security:

1. **Update docker-compose.yml:**
   ```yaml
   environment:
     - xpack.security.enabled=false
   ```

2. **Restart containers:**
   ```bash
   docker-compose down
   docker-compose up -d
   ```

### Common Issues:

1. **"Forbidden" with elastic user**: The elastic user might not have the right permissions. Use the superuser instead.

2. **Connection refused**: Wait for Elasticsearch to fully start (check logs with `docker-compose logs elasticsearch`).

3. **Authentication failed**: Make sure the password matches exactly: `MG0nM0*BmGzOXxFAi59`

### Verification Commands:

```bash
# Check if Elasticsearch is running
curl -u elastic:MG0nM0*BmGzOXxFAi59 http://localhost:9200/_cluster/health

# List users
curl -u elastic:MG0nM0*BmGzOXxFAi59 http://localhost:9200/_security/user

# Check Kibana logs
docker-compose logs kibana
```

### Default Users in Elasticsearch 8.x:

- `elastic`: Built-in superuser (may have restricted permissions)
- `kibana_system`: System user for Kibana
- `logstash_system`: System user for Logstash
- `beats_system`: System user for Beats
- `apm_system`: System user for APM
- `remote_monitoring_user`: System user for monitoring 