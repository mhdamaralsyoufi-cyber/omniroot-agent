#!/usr/bin/env bash
set -u

cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

echo "=== OmniRoot bootstrap ==="

for i in $(seq 1 30); do
  if docker info >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

if ! docker info >/dev/null 2>&1; then
  echo "Docker is not ready yet."
  exit 1
fi

echo "Building and starting OmniRoot from this repository..."
if ! docker compose up -d --build; then
  echo "Docker Compose failed."
  docker compose ps || true
  exit 1
fi

echo "Waiting for frontend and backend..."
for i in $(seq 1 60); do
  FRONTEND_OK=0
  BACKEND_OK=0
  curl -fsS --max-time 2 -o /dev/null http://127.0.0.1:5173/ && FRONTEND_OK=1
  curl -fsS --max-time 2 -o /dev/null http://127.0.0.1:5001/health && BACKEND_OK=1

  if [ "$FRONTEND_OK" -eq 1 ] && [ "$BACKEND_OK" -eq 1 ]; then
    echo "OmniRoot is running."
    docker compose ps
    exit 0
  fi
  sleep 2
done

echo "OmniRoot did not become ready in time."
docker compose ps || true
docker logs --tail 120 omniroot-agent || true
exit 1
