#!/bin/bash

echo "1. Backup Settings"
echo "2. Restore Settings"
read -p "Choice: " opt

case $opt in
    1)
        tar -czf termux_backup.tar.gz \
            ~/.termux \
            ~/.bashrc \
            config.cfg \
            fonts/custom/* \
            sounds/custom/*
        echo "🔒 Backup saved: termux_backup.tar.gz"
        ;;
    2)
        tar -xzf termux_backup.tar.gz -C ~/
        cp -r fonts/custom/* termux-customizer/fonts/custom/
        cp -r sounds/custom/* termux-customizer/sounds/custom/
        echo "🔓 Settings restored!"
        ;;
    *)
        echo "❌ Invalid option"
        ;;
esac