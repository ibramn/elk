#!/bin/bash

# Wait for Elasticsearch to be ready
echo "Waiting for Elasticsearch to be ready..."
until curl -s -u elastic:MG0nM0*BmGzOXxFAi59 http://localhost:9200/_cluster/health > /dev/null 2>&1; do
    echo "Waiting for Elasticsearch..."
    sleep 5
done

echo "Elasticsearch is ready!"

# Set up kibana_system user password
echo "Setting up kibana_system user..."
curl -X POST -u elastic:MG0nM0*BmGzOXxFAi59 \
  -H "Content-Type: application/json" \
  -d '{"password":"MG0nM0*BmGzOXxFAi59"}' \
  http://localhost:9200/_security/user/kibana_system/_password

# Create a superuser role if it doesn't exist
echo "Setting up superuser role..."
curl -X POST -u elastic:MG0nM0*BmGzOXxFAi59 \
  -H "Content-Type: application/json" \
  -d '{
    "cluster": ["all"],
    "indices": [
      {
        "names": ["*"],
        "privileges": ["all"]
      }
    ],
    "applications": [
      {
        "application": "*",
        "privileges": ["*"],
        "resources": ["*"]
      }
    ]
  }' \
  http://localhost:9200/_security/role/superuser

# Create a superuser user
echo "Creating superuser..."
curl -X POST -u elastic:MG0nM0*BmGzOXxFAi59 \
  -H "Content-Type: application/json" \
  -d '{
    "password": "MG0nM0*BmGzOXxFAi59",
    "roles": ["superuser"],
    "full_name": "Super User"
  }' \
  http://localhost:9200/_security/user/superuser

echo "Setup complete! You can now log in with:"
echo "Username: superuser"
echo "Password: MG0nM0*BmGzOXxFAi59" 