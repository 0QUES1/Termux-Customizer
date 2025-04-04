#!/bin/bash

source config.cfg

# Custom Banner
echo -e "\e[1;${banner_color}mWelcome to Termux, $username!\e[0m" > ~/.termux/banner

# Custom Font
if [ "$font" != "Default" ]; then
    mkdir -p ~/.termux
    if [ -f "fonts/default/$font" ]; then
        cp "fonts/default/$font" ~/.termux/font.ttf
    elif [ -f "fonts/custom/$font" ]; then
        cp "fonts/custom/$font" ~/.termux/font.ttf
    fi
    termux-reload-settings
fi

# Startup Sound
if [ "$sound" = "y" ] && [ -n "$sound_file" ]; then
    if [ "$sound_file" = "default.mp3" ]; then
        cp "sounds/default.mp3" ~/startup.mp3
    else
        cp "sounds/custom/$sound_file" ~/startup.mp3
    fi
    echo "termux-media-player play ~/startup.mp3 &> /dev/null" >> ~/.bashrc
fi

# Custom Prompt
echo "PS1='$prompt_symbol'" >> ~/.bashrc

# Animations
if [ "$animations" = "y" ]; then
    echo "neofetch | lolcat" >> ~/.bashrc
fi

echo -e "\n🎉 Customizations applied! Restart Termux."