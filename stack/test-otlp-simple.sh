#!/bin/bash

echo "=== Simple OTLP Test ==="

# Test 1: Basic connectivity
echo "1. Testing OTLP HTTP endpoint connectivity..."
response=$(curl -s -w "%{http_code}" -o /dev/null "http://localhost:4318/v1/traces" -X POST -H "Content-Type: application/json" -d '{}')
echo "Response code: $response"

# Test 2: Send minimal valid trace
echo "2. Sending minimal trace..."
trace_payload='{
  "resourceSpans": [{
    "resource": {
      "attributes": [{
        "key": "service.name",
        "value": {"stringValue": "test-service"}
      }]
    },
    "scopeSpans": [{
      "scope": {"name": "test-scope"},
      "spans": [{
        "traceId": "12345678901234567890123456789012",
        "spanId": "1234567890123456",
        "name": "test-span",
        "startTimeUnixNano": "1609459200000000000",
        "endTimeUnixNano": "1609459201000000000",
        "status": {"code": "STATUS_CODE_OK"}
      }]
    }]
  }]
}'

echo "Sending trace payload..."
response=$(curl -s -X POST \
  -H "Content-Type: application/json" \
  -d "$trace_payload" \
  "http://localhost:4318/v1/traces")

echo "Response: $response"

# Test 3: Check if data reached Elasticsearch
echo "3. Checking Elasticsearch for OTLP data..."
sleep 2
indices=$(curl -s -u elastic:nkiATsBHHFsQvVeY3Zk6 "http://localhost:9200/_cat/indices/otel*?v")
echo "OTLP indices:"
echo "$indices"

# Test 4: Check collector logs
echo "4. Recent collector logs:"
docker compose logs --tail=10 otel-collector

echo "=== Test Complete ==="
