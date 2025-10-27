#!/bin/bash
set -e

echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Start 04_pihole_install.sh ---"

curl -sSL https://install.pi-hole.net | bash

TELEPORT_FILE=""
for file in "$(dirname "$(realpath "$0")")"/pi-hole*_teleporter_*.zip; do
  [[ -f "$file" ]] && TELEPORT_FILE="$file" && break
done

if [[ -n "$TELEPORT_FILE" ]]; then
  echo "Teleport bestand $TELEPORT_FILE importeren..."
  pihole-FTL --teleporter "$TELEPORT_FILE" || echo "Teleport import mislukt."
fi

echo "Voer Pi-hole webinterface wachtwoord in (leeg voor geen wachtwoord):"
read -s -p "Wachtwoord: " PIHOLE_PW
echo
if pihole help 2>&1 | grep -q "setpasswd"; then
  [[ -z "$PIHOLE_PW" ]] && printf "\n" | pihole setpasswd || printf "%s\n" "$PIHOLE_PW" | pihole setpasswd
else
  [[ -z "$PIHOLE_PW" ]] && pihole -a -p "" || pihole -a -p "$PIHOLE_PW"
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Einde 04_pihole_install.sh ---"
