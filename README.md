# SHOUTcast v2 Server Daemon Setup on Ubuntu

This repository contains the setup scripts and instructions to run the SHOUTcast v2 server as a daemon on Ubuntu (tested on 24.04.1 LTS). It includes:

- A **systemd service** file to start SHOUTcast automatically at boot and restart on failure.
- A **watchdog script** to verify hourly that SHOUTcast is running and restart if necessary using a cron job.

## Features

- Automatically start SHOUTcast server on system boot.
- Automatic restart on failure via systemd.
- Hourly process check with watchdog script for additional reliability.
- Easy installation using the provided setup script.

## Contents

- `setup_shoutcast_service_and_watchdog.sh` - Setup script to:
  - Create and enable the systemd service.
  - Create the watchdog script and make it executable.
  - Add an hourly cron job for the watchdog.

- `shoutcast_watchdog.sh` _(created by setup script)_ - Script that checks if SHOUTcast process `sc_serv` is running, else restarts it.

## Prerequisites

- Ubuntu 24.04.1 LTS or similar systemd-based Linux distro.
- SHOUTcast v2 server installed at your home directory, e.g., `/home/yourusername/shoutcast_server`.
- Replace `yourusername` in the scripts with your actual username.

## Installation Instructions

1. Clone the repository to your Ubuntu server.

2. Edit the `setup_shoutcast_service_and_watchdog.sh` script and set the `USERNAME` variable to your actual Ubuntu username.

3. Make the setup script executable: `chmod +x setup_shoutcast_service_and_watchdog.sh`

4. Run the setup script with root privileges: `sudo ./setup_shoutcast_service_and_watchdog.sh`

5. Verify SHOUTcast service status: `sudo systemctl status shoutcast.service`

6. The watchdog script runs automatically every hour via cron to ensure the server stays up.

## Manual Operations

- Start service manually: `sudo systemctl start shoutcast.service`
- Stop service: `sudo systemctl stop shoutcast.service`
- Check logs: `journalctl -u shoutcast.service -f
tail -f /var/log/shoutcast_watchdog.log`


## Troubleshooting

- If the SHOUTcast server won’t start, verify your `shoutcast_server` path and permissions.
- Check logs with the above commands.
- Ensure your firewall allows the SHOUTcast ports.
- Verify that `sc_serv` and `sc_serv.conf` exist in your shoutcast directory.

## License

This setup is provided as-is under the MIT License. Modify and use freely.

## Author

Muhammad Faisal Nadeem or GitHub Handle  
Date: 2025-07-28


