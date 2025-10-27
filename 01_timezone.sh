#!/bin/bash
set -e
LOGFILE="/root/setup/install.log"
exec >> "$LOGFILE" 2>&1
echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Start 01_timezone.sh ---"
EXPECTED_TZ="Europe/Amsterdam"
CURRENT_TZ=$(readlink /etc/localtime || echo "" | awk -F/ '{print $(NF-1)"/"$NF}')
if [[ "$CURRENT_TZ" != "$EXPECTED_TZ" ]]; then
  echo "Tijdzone wijzigen naar $EXPECTED_TZ"
  ln -sf "/usr/share/zoneinfo/$EXPECTED_TZ" /etc/localtime
else
  echo "Tijdzone is al correct."
fi
echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Einde 01_timezone.sh ---"
