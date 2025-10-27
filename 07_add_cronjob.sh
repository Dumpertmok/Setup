#!/bin/bash
set -e

LOGFILE="/root/setup/install.log"
exec >> "$LOGFILE" 2>&1

echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Start 07_add_cronjob.sh ---"

UPDATE_SCRIPT="/root/setup/auto-update-reboot.sh"
CRON_FILE="/etc/cron.d/auto-update"
CRON_LINE="0 3 * * 1 root /bin/bash $UPDATE_SCRIPT"

if [[ -f "$UPDATE_SCRIPT" ]] && [[ -x "$UPDATE_SCRIPT" ]]; then
  echo "Update-script $UPDATE_SCRIPT is aanwezig en uitvoerbaar."
else
  echo "WAARSCHUWING: update-script $UPDATE_SCRIPT ontbreekt of is niet uitvoerbaar!" >&2
fi

if [[ -f "$CRON_FILE" ]] && grep -Fq "$UPDATE_SCRIPT" "$CRON_FILE" ]]; then
  echo "Cronjob voor wekelijkse update bestaat al in $CRON_FILE"
else
  echo "Toevoegen cronjob voor wekelijkse update."
  echo "$CRON_LINE" > "$CRON_FILE"
  chmod 644 "$CRON_FILE"
  echo "Cronjob succesvol toegevoegd via cron.d."
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Einde 07_add_cronjob.sh ---"
