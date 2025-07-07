#!/bin/sh

# Script de entrada para MCP Link
# Permite usar variables de entorno en el comando

# Valores por defecto
PORT=${PORT:-8080}
HOST=${HOST:-0.0.0.0}

# Ejecutar el comando con los parámetros de las variables de entorno
exec /usr/local/bin/mcp-link serve --host "$HOST" --port "$PORT"
