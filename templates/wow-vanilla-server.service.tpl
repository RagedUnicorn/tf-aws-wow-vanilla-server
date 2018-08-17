[Unit]
Description=Run on startup and update server configurations
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=/home/"${operator_user}"/service.sh
StandardOutput=journal

[Install]
WantedBy=multi-user.target
