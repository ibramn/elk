FROM otel/opentelemetry-collector-contrib:latest

# Copy collector configuration
COPY otel-collector-config.yaml /etc/otel-collector-config.yaml

# Expose OTLP ports (gRPC 4317, HTTP 4318)
EXPOSE 4317 4318

# The base image entrypoint is "/otelcol-contrib"
CMD ["--config=/etc/otel-collector-config.yaml"]


