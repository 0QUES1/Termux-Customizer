#!/bin/bash

# Set password first: termux-keystore set termux_pass YourPassword
password=$(termux-keystore get termux_pass)

read -sp "🔑 Enter Password: " input
if [ "$input" = "$password" ]; then
    ./apply.sh
else
    echo -e "\n❌ Access Denied!"
    exit 1
fi