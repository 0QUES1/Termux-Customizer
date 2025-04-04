#!/bin/bash

echo -e "\033[1;31m▓▒░ Uninstalling Customizations ░▒▓\033[0m"

# Remove all custom files
rm -f ~/.termux/font.ttf \
      ~/.startup.mp3 \
      ~/.home_art \
      ~/.termux_prompt \
      config.cfg

# Reset Termux
termux-reload-settings

echo -e "\033[1;32m✓ All customizations removed!\033[0m"
