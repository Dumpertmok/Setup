#!/bin/bash
set -e

LOGFILE="/root/setup/install.log"
exec >> "$LOGFILE" 2>&1

echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Start 08_pihole_update_lists.sh ---"

pihole -g

echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Einde 08_pihole_update_lists.sh ---"
