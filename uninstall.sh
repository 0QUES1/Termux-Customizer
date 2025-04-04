#!/bin/bash

echo -e "\033[1;31m▓▒░ Restoring Defaults ░▒▓\033[0m"

# Remove custom files
rm -f ~/.termux/font.ttf \
      ~/.startup.mp3 \
      ~/.termux_prompt \
      commands.log

# Reset config
echo "# Termux Configuration" > config.cfg

termux-reload-settings
echo -e "\033[1;32m✓ All customizations removed!\033[0m"
