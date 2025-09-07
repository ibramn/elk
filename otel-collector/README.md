OpenTelemetry Collector for ELK stack

This folder contains a minimal OpenTelemetry Collector setup to receive OTLP traffic over gRPC and HTTP and forward data to Elasticsearch and Elastic APM.

Files:
- `Dockerfile`: Builds a collector image using `otel/opentelemetry-collector-contrib` and loads `otel-collector-config.yaml`.
- `otel-collector-config.yaml`: Collector configuration (receivers, processors, exporters, pipelines).
- `certs/`: Mount point for TLS certificate and key used by the OTLP receivers. Provide:
  - `CEPO240915890176.crt`
  - `Privatekey.key`

Usage with docker-compose:
The root `docker-compose.yml` defines the `otel-collector` service that builds from this folder and exposes ports 4317, 4318 and 13133.

