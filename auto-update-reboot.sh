#!/bin/bash
set -e

LOGFILE="/root/auto-update-log.txt"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Start auto-update ---" >> "$LOGFILE"

/boot/dietpi/dietpi-update 1
pihole -up
apt update -y && apt upgrade -y && apt autoremove -y
RESULT=$?

if [ $RESULT -eq 0 ]; then
  echo "Updates succesvol afgerond." >> "$LOGFILE"
  echo "Systeem wordt nu herstart." >> "$LOGFILE"
  reboot
else
  echo "Update mislukt met code $RESULT." >> "$LOGFILE"
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Einde auto-update ---" >> "$LOGFILE"
