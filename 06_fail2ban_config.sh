#!/bin/bash
set -e

LOGFILE="/root/setup/install.log"
exec >> "$LOGFILE" 2>&1

echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Start 06_fail2ban_config.sh ---"

apt-get install -y fail2ban

cat <<EOF >/etc/fail2ban/jail.local
[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
maxretry = 5
EOF

systemctl restart fail2ban
systemctl enable fail2ban

echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Einde 06_fail2ban_config.sh ---"
