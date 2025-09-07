#!/bin/bash

echo "🔧 Fixing domain access by switching to HTTP mode..."

# Stop current services
echo "🛑 Stopping current services..."
docker compose down

# Start with HTTP configuration
echo "🚀 Starting services with HTTP configuration..."
docker compose -f docker-compose.http.yml up -d

# Wait for services to start
echo "⏳ Waiting for services to start..."
sleep 30

# Check status
echo "📊 Checking service status..."
docker compose -f docker-compose.http.yml ps

echo ""
echo "✅ Fixed! Your ELK stack is now accessible via HTTP:"
echo ""
echo "🌐 Access URLs:"
echo "   - Kibana: http://elogs.aldrees.com"
echo "   - Elasticsearch API: http://elogs.aldrees.com/elasticsearch/"
echo "   - APM Server: http://elogs.aldrees.com/apm/"
echo "   - Health Check: http://elogs.aldrees.com/health"
echo ""
echo "🔐 Login credentials:"
echo "   - Username: elastic"
echo "   - Password: nkiATsBHHFsQvVeY3Zk6"
echo ""
echo "📝 Note: This is HTTP mode for development. For production,"
echo "   you should get a proper SSL certificate and use HTTPS."
