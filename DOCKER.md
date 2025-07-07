# Docker Usage Examples for MCP Link (Alpine-based)

## Build the Docker image

```bash
# Build the image
docker build -t mcp-link:latest .

# Build with custom tag
docker build -t mcp-link:alpine .
```

## Run the container

```bash
# Run with default settings (port 8080, host 0.0.0.0)
docker run -p 8080:8080 mcp-link:latest

# Run with custom port and host
docker run -p 3000:3000 -e PORT=3000 -e HOST=0.0.0.0 mcp-link:latest

# Run in background with custom environment
docker run -d -p 8080:8080 \
  -e PORT=8080 \
  -e HOST=0.0.0.0 \
  --name mcp-link-server \
  mcp-link:latest

# Run with docker-compose
docker-compose up -d

# Run with custom environment file
env PORT=3000 HOST=localhost docker-compose up
```

## Testing the container

```bash
# Check if the service is running
curl http://localhost:8080/sse?s=https://api.example.com/openapi.json&u=https://api.example.com

# Health check (if implemented)
curl http://localhost:8080/health
```

## Production deployment

```bash
# Build for production
docker build --target runtime -t mcp-link:prod .

# Run in production mode
docker run -d \
  --name mcp-link-prod \
  --restart unless-stopped \
  -p 8080:8080 \
  -e PORT=8080 \
  -e HOST=0.0.0.0 \
  mcp-link:prod
```

## Multi-architecture build

```bash
# Build for multiple architectures
docker buildx build --platform linux/amd64,linux/arm64 -t mcp-link:latest .

# Push to registry
docker buildx build --platform linux/amd64,linux/arm64 -t your-registry/mcp-link:latest --push .
```
