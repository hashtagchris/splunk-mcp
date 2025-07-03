# Use Python 3.10 slim image as base
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install build dependencies, curl for healthcheck, and uv
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    python3-dev \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir uv

# Copy project files
COPY pyproject.toml poetry.lock ./
COPY splunk_mcp.py ./
COPY README.md ./
COPY .env.example ./

# Install dependencies using uv (only main group by default)
RUN uv pip install --system poetry && \
    uv pip install --system .

# Create directory for environment file
RUN mkdir -p /app/config

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV SPLUNK_HOST=
ENV SPLUNK_PORT=8089
ENV SPLUNK_USERNAME=
ENV SPLUNK_BEARER_TOKEN=
ENV SPLUNK_SCHEME=https
ENV FASTMCP_LOG_LEVEL=INFO
ENV FASTMCP_PORT=8001
ENV DEBUG=false
ENV MODE=stdio

CMD ["python", "splunk_mcp.py", "stdio"]