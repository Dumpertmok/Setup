#!/bin/bash
set -e

echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Start 02_user_cafehling.sh (beheer gebruikers) ---"

# Verwijder gebruiker dietpi als die bestaat
if id -u dietpi &>/dev/null; then
  echo "Gebruiker dietpi gevonden, verwijderen..."
  userdel -r dietpi
  echo "Gebruiker dietpi succesvol verwijderd."
else
  echo "Gebruiker dietpi niet gevonden, niets te verwijderen."
fi

# Aanmaken of bijwerken van gebruiker cafehling
if ! id -u cafehling &>/dev/null; then
  echo "Gebruiker cafehling aanmaken..."
  useradd -m -s /bin/bash cafehling
  passwd cafehling
  usermod -aG sudo cafehling
  echo "cafehling ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/cafehling
  chmod 440 /etc/sudoers.d/cafehling
else
  echo "Gebruiker cafehling bestaat al, geen groep docker hier toevoegen."
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Einde 02_user_cafehling.sh ---"
