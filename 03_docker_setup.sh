#!/bin/bash
set -e
LOGFILE="/root/setup/install.log"
exec >> "$LOGFILE" 2>&1
echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Start 03_docker_setup.sh ---"

apt-get update
apt-get install -y git curl

if ! command -v docker &>/dev/null; then
  echo "Docker installeren..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
  systemctl enable docker
  systemctl start docker
else
  echo "Docker is al geïnstalleerd."
fi

# Voeg cafehling toe aan docker groep als die bestaat en nog niet in de groep zit
if id -u cafehling &>/dev/null; then
  if ! groups cafehling | grep -qw docker; then
    echo "Voeg cafehling toe aan docker groep..."
    usermod -aG docker cafehling
  else
    echo "Gebruiker cafehling zit al in docker groep."
  fi
fi

DOCKER_DIR="/root/docker"
mkdir -p "$DOCKER_DIR"
cat <<EOF >"$DOCKER_DIR/docker-compose.yml"
version: "3"
services:
  watchtower:
    image: containrrr/watchtower:latest
    restart: unless-stopped
    container_name: watchtower
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command: --cleanup
EOF

docker compose -f "$DOCKER_DIR/docker-compose.yml" up -d

SCRIPT_DIR=$(dirname $(realpath $0))
for dir in $(dirname $SCRIPT_DIR)/*/; do
  [ -f ${dir}docker-compose.yml ] && docker compose -f ${dir}docker-compose.yml up -d
done

echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Einde 03_docker_setup.sh ---"
