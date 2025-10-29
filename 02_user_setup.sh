#!/bin/bash
set -e

echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Start 02_user_setup.sh (beheer gebruikers) ---"

# Verwijder gebruiker dietpi als die bestaat
if id -u dietpi &>/dev/null; then
  echo "Gebruiker 'dietpi' gevonden, verwijderen..."
  userdel -r dietpi
  echo "Gebruiker 'dietpi' succesvol verwijderd."
else
  echo "Gebruiker 'dietpi' niet gevonden, niets te verwijderen."
fi

# Vraag om een unieke gebruikersnaam
while true; do
  read -rp "Voer de gewenste gebruikersnaam in: " NEWUSER
  if [[ -z "$NEWUSER" ]]; then
    echo "Gebruikersnaam mag niet leeg zijn."
    continue
  fi
  if id -u "$NEWUSER" &>/dev/null; then
    echo "Gebruiker '$NEWUSER' bestaat al, kies een andere naam."
  else
    break
  fi
done

# Maak gebruiker aan
echo "Gebruiker '$NEWUSER' wordt aangemaakt..."
useradd -m -s /bin/bash "$NEWUSER"
passwd "$NEWUSER"
usermod -aG sudo "$NEWUSER"
echo "$NEWUSER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/"$NEWUSER"
chmod 440 /etc/sudoers.d/"$NEWUSER"

# Sla gebruikersnaam tijdelijk op
echo "$NEWUSER" > /root/setup/username.txt

echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Einde 02_user_setup.sh ---"
