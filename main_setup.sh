#!/bin/bash
set -e

LOGFILE="/root/setup/install.log"
mkdir -p /root/setup
echo "========== Nieuwe installatie op $(date) ==========" >> "$LOGFILE"

chmod +x ./*.sh

echo "--- Tijdzone instellen ---"
./01_timezone.sh >> "$LOGFILE" 2>&1

echo "--- Gebruikerbeheer (interactief) ---"
./02_user_cafehling.sh

echo "--- Docker & Watchtower ---"
./03_docker_setup.sh >> "$LOGFILE" 2>&1

echo "--- Pi-hole installatie (interactief) ---"
./04_pihole_install.sh

echo "--- Unbound configuratie ---"
./05_unbound_config.sh >> "$LOGFILE" 2>&1

echo "--- Fail2ban configuratie ---"
./06_fail2ban_config.sh >> "$LOGFILE" 2>&1

echo "--- Cronjob toevoegen ---"
./07_add_cronjob.sh >> "$LOGFILE" 2>&1

echo "--- Pi-hole lijsten updaten ---"
./08_pihole_update_lists.sh >> "$LOGFILE" 2>&1

echo "Setup compleet op $(date)"
