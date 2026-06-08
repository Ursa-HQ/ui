#!/usr/bin/env bash
#
# deploy-launcher.sh --- Build and deploy the UrsaHQ Launcher

set -euo pipefail

# Load local env config if present (gitignored, contains server-specific values)
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
if [ -f "$SCRIPT_DIR/.env" ]; then
  set -a
  source "$SCRIPT_DIR/.env"
  set +a
fi

FLUTTER_HOME="${FLUTTER_HOME:-/path/to/flutter}"
INFRA_DIR="${INFRA_DIR:-/path/to/ursahq-infra}"
DOMAIN="${DOMAIN:-your-domain.example.com}"
NGINX_PROXY_HOST_ID="${NGINX_PROXY_HOST_ID:-5}"
NUC_HOST="${NUC_HOST:-nuc-host.local}"

echo "==> Building Flutter web app..."
cd apps/launcher
"$FLUTTER_HOME/bin/flutter" build web --release

echo "==> Building Docker image..."
cd ..
docker build \
  --build-arg NUC_HOST="$NUC_HOST" \
  -t ursahq-launcher \
  -f docker/Dockerfile.launcher .

echo "==> Syncing nginx config..."
cp docker/nginx-proxy-manager-advanced.conf.template \
   "$INFRA_DIR/config/nginx-proxy-manager/data/nginx/proxy_host/$NGINX_PROXY_HOST_ID.conf"

echo "==> Restarting containers..."
cd "$INFRA_DIR"
docker compose up -d launcher
docker compose restart nginx-proxy-manager

echo "==> Done! Launcher should be available at https://$DOMAIN"
