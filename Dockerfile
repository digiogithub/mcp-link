# Dockerfile para MCP Link
# Multistage build para optimizar el tamaño de la imagen final

# Stage 1: Build stage
FROM golang:1.23.0-alpine AS builder

# Instalar git y ca-certificates para dependencias
RUN apk add --no-cache git ca-certificates

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos de dependencias
COPY go.mod go.sum ./

# Descargar dependencias
RUN go mod download

# Copiar código fuente
COPY . .

# Compilar binario para Linux x64 con optimizaciones de release
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags='-w -s -extldflags "-static"' \
    -a -installsuffix cgo \
    -o mcp-link main.go

# Stage 2: Runtime stage usando Alpine Linux
FROM alpine:3.20

# Metadatos de la imagen
LABEL maintainer="MCP Link Team"
LABEL description="Convert Any OpenAPI V3 API to MCP Server"
LABEL version="1.0"

# Instalar ca-certificates y crear usuario no-root
RUN apk add --no-cache ca-certificates tzdata && \
    addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# Variables de entorno con valores por defecto
ENV PORT=8080
ENV HOST=0.0.0.0

# Copiar el binario compilado desde el stage de build
COPY --from=builder /app/mcp-link /usr/local/bin/mcp-link

# Copiar script de entrada
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Dar permisos de ejecución
RUN chmod +x /usr/local/bin/mcp-link /usr/local/bin/entrypoint.sh

# Exponer el puerto
EXPOSE ${PORT}

# Cambiar a usuario no-root para seguridad
USER appuser:appgroup

# Comando de entrada usando el script que maneja variables de entorno
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
