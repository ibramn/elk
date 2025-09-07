#!/bin/bash

echo "=== ELK + OpenTelemetry Collector Stack Health Check ==="
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to test endpoint
test_endpoint() {
    local name="$1"
    local url="$2"
    local expected_status="$3"
    
    echo -n "Testing $name... "
    
    response=$(curl -s -w "%{http_code}" -o /dev/null "$url" 2>/dev/null)
    
    if [ "$response" = "$expected_status" ]; then
        echo -e "${GREEN}✓ OK${NC} (HTTP $response)"
    else
        echo -e "${RED}✗ FAILED${NC} (HTTP $response, expected $expected_status)"
    fi
}

# Function to test with authentication
test_endpoint_auth() {
    local name="$1"
    local url="$2"
    local expected_status="$3"
    local auth="$4"
    
    echo -n "Testing $name... "
    
    response=$(curl -s -w "%{http_code}" -o /dev/null -u "$auth" "$url" 2>/dev/null)
    
    if [ "$response" = "$expected_status" ]; then
        echo -e "${GREEN}✓ OK${NC} (HTTP $response)"
    else
        echo -e "${RED}✗ FAILED${NC} (HTTP $response, expected $expected_status)"
    fi
}

echo "1. Basic Connectivity Tests"
echo "=========================="
test_endpoint "Elasticsearch" "http://localhost:9200" "200"
test_endpoint "Kibana" "http://localhost:5601" "200"
test_endpoint "OTLP Collector Health" "http://localhost:13133" "200"

echo
echo "2. Elasticsearch Authentication Tests"
echo "====================================="
test_endpoint_auth "Elasticsearch Auth" "http://localhost:9200/_cluster/health" "200" "elastic:nkiATsBHHFsQvVeY3Zk6"
test_endpoint_auth "Elasticsearch Info" "http://localhost:9200" "200" "elastic:nkiATsBHHFsQvVeY3Zk6"

echo
echo "3. Elasticsearch Cluster Health"
echo "==============================="
echo -n "Cluster Health: "
curl -s -u elastic:nkiATsBHHFsQvVeY3Zk6 "http://localhost:9200/_cluster/health?pretty" | grep -E '"status"|"number_of_nodes"|"active_primary_shards"'

echo
echo "4. OpenTelemetry Collector Info"
echo "==============================="
echo -n "Collector Build Info: "
curl -s "http://localhost:13133" | grep -o '"buildInfo":[^}]*' || echo "No build info available"

echo
echo "5. Test OTLP Endpoints"
echo "======================"
echo -n "OTLP gRPC endpoint (4317): "
nc -z localhost 4317 && echo -e "${GREEN}✓ Port open${NC}" || echo -e "${RED}✗ Port closed${NC}"

echo -n "OTLP HTTP endpoint (4318): "
nc -z localhost 4318 && echo -e "${GREEN}✓ Port open${NC}" || echo -e "${RED}✗ Port closed${NC}"

echo
echo "6. Send Test OTLP Data"
echo "====================="
echo -n "Sending test trace to OTLP HTTP... "

# Create a simple OTLP trace payload
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
        "startTimeUnixNano": "'$(date +%s%N)'",
        "endTimeUnixNano": "'$(date +%s%N)'",
        "status": {"code": "STATUS_CODE_OK"}
      }]
    }]
  }]
}'

response=$(curl -s -w "%{http_code}" -X POST \
  -H "Content-Type: application/json" \
  -d "$trace_payload" \
  "http://localhost:4318/v1/traces" 2>/dev/null)

if [ "$response" = "200" ]; then
    echo -e "${GREEN}✓ Success${NC} (HTTP $response)"
else
    echo -e "${RED}✗ Failed${NC} (HTTP $response)"
fi

echo
echo "7. Check Elasticsearch Indices"
echo "=============================="
echo -n "OTLP indices: "
curl -s -u elastic:nkiATsBHHFsQvVeY3Zk6 "http://localhost:9200/_cat/indices/otel*?v" || echo "No OTLP indices found"

echo
echo "8. Docker Container Status"
echo "========================="
docker compose ps

echo
echo "=== Health Check Complete ==="
echo
echo "Useful URLs:"
echo "- Elasticsearch: http://localhost:9200"
echo "- Kibana: http://localhost:5601"
echo "- Collector Health: http://localhost:13133"
echo "- OTLP gRPC: localhost:4317"
echo "- OTLP HTTP: localhost:4318"
