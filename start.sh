#!/bin/sh
set -e

# Railway injects PORT env var
export PORT=${PORT:-8080}

# Ensure nginx conf directory exists
mkdir -p /etc/nginx/conf.d

# Generate nginx.conf from template
envsubst '${PORT}' < /app/nginx.conf.template > /etc/nginx/conf.d/default.conf

# Start nginx
exec nginx -g 'daemon off;'
