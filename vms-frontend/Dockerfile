# =============================================================================
# Stage 1: Build Flutter Web Application
# =============================================================================
FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app

# Copy dependency configuration
COPY pubspec.yaml ./
RUN flutter pub get

# Copy frontend source code and compile web release
COPY . .
RUN flutter build web --release

# =============================================================================
# Stage 2: Serve with Production Nginx Alpine
# =============================================================================
FROM nginx:alpine

# Copy compiled static web bundle to Nginx html directory
COPY --from=builder /app/build/web /usr/share/nginx/html

# Custom Nginx configuration for single-page app (SPA) routing
RUN echo 'server { \
    listen 80; \
    server_name localhost; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html index.htm; \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
