#!/bin/bash

# Initialize config
config_file="config.cfg"
touch $config_file
source $config_file 2>/dev/null

clear
echo "✨ Termux Ultimate Customizer Setup ✨"

# User Input
read -p "Your name: " username
read -p "Banner color (31=Red, 32=Green, 36=Cyan): " banner_color
read -p "Enable animations? (y/n): " animations
read -p "Enable startup sound? (y/n): " sound
read -p "Custom prompt symbol (e.g., '>>> '): " prompt_symbol

# Font Selection
echo -e "\n🔤 Available Fonts:"
fonts=("Default" $(ls fonts/default/) "Custom")
select font in "${fonts[@]}"; do
    [ -n "$font" ] && break
done

# Sound Configuration
if [ "$sound" = "y" ]; then
    echo -e "\n🔊 Sound files:"
    sounds=("default.mp3" $(ls sounds/custom/) "None")
    select sound_file in "${sounds[@]}"; do
        [ -n "$sound_file" ] && break
    done
fi

# Save Config
cat > $config_file << EOF
username="$username"
banner_color="$banner_color"
animations="$animations"
sound="$sound"
prompt_symbol="$prompt_symbol"
font="$font"
sound_file="$sound_file"
EOF

echo -e "\n✅ Setup complete! Run './apply.sh' to apply changes"