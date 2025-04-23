touch /etc/systemd/system/monitor_configurator.service
echo "[Unit]
Description=Monitor Configurator
After=graphical-session.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=/home/prochazo/git/linux-setup/scripts/ondra_monitor_automation.sh
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/monitor_configurator.service
