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

# Lees voorlopig gebruiker naam in
if [[ -f /root/setup/username.txt ]]; then
  USERNAME=$(cat /root/setup/username.txt)
  if id -u "$USERNAME" &>/dev/null; then
    if ! groups "$USERNAME" | grep -qw docker; then
      echo "Voeg gebruiker $USERNAME toe aan docker groep..."
      usermod -aG docker "$USERNAME"
    else
      echo "Gebruiker $USERNAME zit al in docker groep."
    fi
  else
    echo "Gebruiker $USERNAME bestaat niet, sla deze stap over."
  fi
else
  echo "Bestand username.txt niet gevonden, sla toevoeging docker groep over."
fi

# Overige Docker installatie code hier...

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
