#!/bin/bash

# Variables - you must change these according to your environment
USERNAME="yourusername"                 # <-- replace with your Ubuntu username
SHOUTCAST_DIR="/home/$USERNAME/shoutcast_server"
SERVICE_FILE="/etc/systemd/system/shoutcast.service"
WATCHDOG_SCRIPT="/usr/local/bin/shoutcast_watchdog.sh"

echo "Starting SHOUTcast setup script..."

# 1. Create the systemd service file
echo "Creating systemd service file at $SERVICE_FILE"
sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=SHOUTcast Radio Server
After=network.target

[Service]
Type=simple
WorkingDirectory=$SHOUTCAST_DIR
ExecStart=$SHOUTCAST_DIR/sc_serv $SHOUTCAST_DIR/sc_serv.conf
Restart=on-failure
User=$USERNAME

[Install]
WantedBy=multi-user.target
EOL

# 2. Reload systemd, enable and start the service
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "Enabling shoutcast.service to start on boot..."
sudo systemctl enable shoutcast.service

echo "Starting shoutcast.service..."
sudo systemctl start shoutcast.service

echo "Checking shoutcast.service status:"
sudo systemctl status shoutcast.service --no-pager

# 3. Create the watchdog script
echo "Creating watchdog script at $WATCHDOG_SCRIPT"
sudo bash -c "cat > $WATCHDOG_SCRIPT" <<'EOS'
#!/bin/bash
# Watchdog script for SHOUTcast server process

if ! pgrep -x sc_serv > /dev/null
then
    echo "$(date): Shoutcast not running, starting..." >> /var/log/shoutcast_watchdog.log
    systemctl start shoutcast.service
fi
EOS

# 4. Make the watchdog script executable
echo "Setting execute permissions for watchdog script..."
sudo chmod +x $WATCHDOG_SCRIPT

# 5. Add cron job for hourly checks if not already added
echo "Adding cron job for hourly watchdog check..."

# Check if the cron job already exists
(crontab -l 2>/dev/null | grep -q "$WATCHDOG_SCRIPT") || (
  (crontab -l 2>/dev/null; echo "0 * * * * $WATCHDOG_SCRIPT") | crontab -
  echo "Cron job added."
) || echo "Failed to add cron job or cron already present."

echo "Setup completed."

echo ""
echo "IMPORTANT:"
echo "- Replace the USERNAME variable at the top of this script with your actual username."
echo "- Make sure your SHOUTcast server files are in: $SHOUTCAST_DIR"
echo "- You can check the SHOUTcast logs with: journalctl -u shoutcast.service"
echo "- Your watchdog script logs restarts to /var/log/shoutcast_watchdog.log"
echo ""
echo "Run this script with: bash $0"
