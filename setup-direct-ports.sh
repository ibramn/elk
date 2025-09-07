#!/bin/bash

# Setup script for ELK stack with direct port access (no reverse proxy)
# Services will be accessible via elogs.aldrees.com:PORT

echo "🚀 Setting up ELK stack with direct port access (elogs.aldrees.com:PORT)"

# Check if Docker and Docker Compose are installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is available (modern docker compose or legacy docker-compose)
if ! docker compose version &> /dev/null && ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not available. Please install Docker Compose first."
    exit 1
fi

# Create external network if it doesn't exist
echo "📡 Creating Docker network..."
docker network create elasticnet 2>/dev/null || echo "Network already exists"

# Stop any existing services
echo "🛑 Stopping any existing services..."
if docker compose version &> /dev/null; then
    docker compose down
else
    docker-compose down
fi

# Start the services
echo "🐳 Starting ELK stack services..."
if docker compose version &> /dev/null; then
    docker compose up -d
else
    docker-compose up -d
fi

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 30

# Check service status
echo "📊 Checking service status..."
if docker compose version &> /dev/null; then
    docker compose ps
else
    docker-compose ps
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "🌐 Access your ELK stack directly via ports:"
echo "   - Kibana: http://elogs.aldrees.com:5601"
echo "   - Elasticsearch API: http://elogs.aldrees.com:9200"
echo "   - APM Server: http://elogs.aldrees.com:8200"
echo ""
echo "🔐 Default credentials:"
echo "   - Elasticsearch: elastic / nkiATsBHHFsQvVeY3Zk6"
echo "   - Kibana: elastic / nkiATsBHHFsQvVeY3Zk6"
echo ""
echo "📝 Next steps:"
echo "   1. Configure your DNS to point elogs.aldrees.com to this server"
echo "   2. Ensure ports 5601, 9200, and 8200 are open in your firewall"
echo "   3. For production, consider using HTTPS with proper SSL certificates"
echo ""
echo "🔧 Firewall commands (if needed):"
echo "   sudo ufw allow 5601/tcp  # Kibana"
echo "   sudo ufw allow 9200/tcp  # Elasticsearch"
echo "   sudo ufw allow 8200/tcp  # APM Server"
