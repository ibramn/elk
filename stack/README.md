# Self-contained ELK + OpenTelemetry Collector stack

This folder contains everything needed to run the stack:

- `docker-compose.yml`
- `otel-collector/` (Dockerfile, config, and `certs/` mount point)

Usage:

1. Place your TLS files in `otel-collector/certs/` as:
   - `CEPO240915890176.crt`
   - `Privatekey.key`
2. Run:
   - `docker compose up -d` (from this `stack/` folder)

Ports:
- Elasticsearch: 9200
- Kibana: 5601
- OTLP gRPC: 4317
- OTLP HTTP: 4318
- Collector health check: 13133

