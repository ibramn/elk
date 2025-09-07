#!/bin/bash

# Wait for Elasticsearch to be ready
echo "Waiting for Elasticsearch to be ready..."
until curl -s -u elastic:nkiATsBHHFsQvVeY3Zk6 http://localhost:9200/_cluster/health > /dev/null; do
  echo "Waiting for Elasticsearch..."
  sleep 5
done

echo "Elasticsearch is ready. Setting up users..."

# Set password for kibana_system user
curl -X POST -u elastic:nkiATsBHHFsQvVeY3Zk6 \
  "http://localhost:9200/_security/user/kibana_system/_password" \
  -H "Content-Type: application/json" \
  -d '{"password": "nkiATsBHHFsQvVeY3Zk6"}'

echo "kibana_system user password set successfully!"
