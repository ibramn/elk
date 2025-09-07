#!/bin/bash

# Setup script for ELK stack with domain elogs.aldrees.com

echo "🚀 Setting up ELK stack with domain elogs.aldrees.com"

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

# Check if SSL certificates exist
if [ ! -f "ssl/elogs.aldrees.com.crt" ] || [ ! -f "ssl/elogs.aldrees.com.key" ]; then
    echo "⚠️  SSL certificates not found. Using self-signed certificate for development."
    echo "   For production, please add proper SSL certificates to the ssl/ directory."
fi

# Check if htpasswd file exists
if [ ! -f ".htpasswd" ]; then
    echo "⚠️  .htpasswd file not found. Creating one with default credentials..."
    echo "admin:\$2y\$10\$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi" > .htpasswd
    echo "   Default credentials: admin / password"
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
echo "🌐 Access your ELK stack at:"
echo "   - Kibana: https://elogs.aldrees.com"
echo "   - Elasticsearch API: https://elogs.aldrees.com/elasticsearch/"
echo "   - APM Server: https://elogs.aldrees.com/apm/"
echo "   - Health Check: https://elogs.aldrees.com/health"
echo ""
echo "🔐 Default credentials:"
echo "   - Elasticsearch: elastic / nkiATsBHHFsQvVeY3Zk6"
echo "   - Kibana: elastic / nkiATsBHHFsQvVeY3Zk6"
echo "   - Nginx Basic Auth: admin / password"
echo ""
echo "📝 Next steps:"
echo "   1. Configure your DNS to point elogs.aldrees.com to this server"
echo "   2. Replace the self-signed certificate with a proper SSL certificate"
echo "   3. Update the .htpasswd file with secure credentials"
echo "   4. Configure your firewall to allow ports 80 and 443"
