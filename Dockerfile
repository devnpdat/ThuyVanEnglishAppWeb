# Build stage — compile Flutter Web
FROM ghcr.io/cirruslabs/flutter:3.24 AS build
WORKDIR /app
COPY . .
RUN flutter build web --release --no-pub

# Runtime stage — custom Node.js server (handle GET+POST, bypass nginx 405)
FROM node:18-alpine
WORKDIR /app

# Copy build output + server
COPY --from=build /app/build/web ./build/web
COPY server.js .

# Railway assigns PORT dynamically
ENV PORT=3000
EXPOSE 3000

CMD ["node", "server.js"]
