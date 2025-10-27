#!/bin/bash
set -e

LOGFILE="/root/setup/install.log"
exec >> "$LOGFILE" 2>&1

echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Start 05_unbound_config.sh ---"

apt-get install -y unbound

SRC_CONF="/root/setup/pi-hole.conf"
DST_CONF="/etc/unbound/unbound.conf.d/pi-hole.conf"

if [[ -f "$SRC_CONF" ]]; then
  echo "Kopieer $SRC_CONF naar $DST_CONF"
  cp -f "$SRC_CONF" "$DST_CONF"
else
  echo "FOUT: Configuratiebestand $SRC_CONF bestaat niet!" >&2
  exit 1
fi

systemctl restart unbound
systemctl enable unbound

echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Einde 05_unbound_config.sh ---"
