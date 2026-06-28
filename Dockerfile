# Cache buster: 2026-06-29-1
FROM nginx:alpine

COPY build/web /usr/share/nginx/html
COPY nginx.conf.template /etc/nginx/templates/default.conf.template

EXPOSE 8080
