#!/bin/bash

# Wait for Elasticsearch to be ready
echo "Waiting for Elasticsearch to be ready..."
until curl -s -u elastic:nkiATsBHHFsQvVeY3Zk6 http://localhost:9200/_cluster/health > /dev/null 2>&1; do
    echo "Waiting for Elasticsearch..."
    sleep 5
done

echo "Elasticsearch is ready!"

# Set up kibana_system user password
echo "Setting up kibana_system user..."
curl -X POST -u elastic:nkiATsBHHFsQvVeY3Zk6 \
  -H "Content-Type: application/json" \
  -d '{"password":"nkiATsBHHFsQvVeY3Zk6"}' \
  http://localhost:9200/_security/user/kibana_system/_password

# Create a custom admin role
echo "Setting up admin role..."
curl -X POST -u elastic:nkiATsBHHFsQvVeY3Zk6 \
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
  http://localhost:9200/_security/role/admin_role

# Create an admin user
echo "Creating admin user..."
curl -X POST -u elastic:nkiATsBHHFsQvVeY3Zk6 \
  -H "Content-Type: application/json" \
  -d '{
    "password": "nkiATsBHHFsQvVeY3Zk6",
    "roles": ["admin_role"],
    "full_name": "Admin User"
  }' \
  http://localhost:9200/_security/user/admin

echo "Setup complete! You can now log in with:"
echo "Username: admin"
echo "Password: nkiATsBHHFsQvVeY3Zk6"
echo ""
echo "Or use the elastic user:"
echo "Username: elastic"
echo "Password: nkiATsBHHFsQvVeY3Zk6" 