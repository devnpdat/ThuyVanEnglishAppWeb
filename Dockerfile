# ── Stage 1: Build Flutter Web ──────────────────────────────────────────────
# Build context: frontend/ directory (Railway rootDirectory)
FROM debian:bookworm-slim AS builder

ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_VERSION=3.44.1
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    curl \
    git \
    unzip \
    xz-utils \
    libglu1-mesa \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Download Flutter 3.44.1 Linux SDK
RUN curl -fsSL \
    "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
    -o /tmp/flutter.tar.xz \
    && tar xf /tmp/flutter.tar.xz -C /opt \
    && rm /tmp/flutter.tar.xz \
    && flutter precache --web \
    && flutter --version

WORKDIR /app

# Build context = frontend/, COPY directly without prefix
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get --no-example

COPY . .
RUN flutter build web --release

# ── Stage 2: Serve with nginx ─────────────────────────────────────────────────
FROM nginx:1.25-alpine AS runner

RUN apk add --no-cache gettext

COPY --from=builder /app/build/web /usr/share/nginx/html
# nginx.conf.template và start.sh cũng ở root của build context (frontend/)
COPY nginx.conf.template /app/nginx.conf.template
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 8080
CMD ["/app/start.sh"]
