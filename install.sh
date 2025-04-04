#!/bin/bash

# Initialize
CONFIG="config.cfg"
[ ! -f "$CONFIG" ] && {
    echo -e "# Termux Configuration\n" > "$CONFIG"
    mkdir -p fonts sounds
}

# Load config
source "$CONFIG" 2>/dev/null

# Password System
set_password() {
    read -sp "Set login password: " pass
    echo -e "\nPASSWORD='$pass'" >> "$CONFIG"
}

# Custom Font
set_font() {
    echo -e "\nAvailable fonts:"
    ls fonts/ 2>/dev/null || echo "No fonts found"
    read -p "Font filename (.ttf): " font
    [ -f "fonts/$font" ] && {
        cp "fonts/$font" ~/.termux/font.ttf
        echo "FONT='$font'" >> "$CONFIG"
    }
}

# Custom Sound
set_sound() {
    echo -e "\nAvailable sounds:"
    ls sounds/ 2>/dev/null || echo "No sounds found"
    read -p "Sound filename (.mp3): " sound
    [ -f "sounds/$sound" ] && {
        cp "sounds/$sound" ~/.startup.mp3
        echo "SOUND='$sound'" >> "$CONFIG"
    }
}

# ASCII Art Home
set_home() {
    echo -e "\nCreate your ASCII art (Ctrl+D when done):"
    cat > ~/.home_art
    read -p "Art color (31-37): " color
    echo "HOME_ART='$(cat ~/.home_art)'" >> "$CONFIG"
    echo "ART_COLOR='$color'" >> "$CONFIG"
}

# Dynamic Prompt
set_prompt() {
    echo -e "\nAvailable variables:"
    echo "\$directory \$date \$time \$username"
    read -p "Enter prompt format (e.g. '[\$directory]λ '): " prompt
    read -p "Prompt color (31-37): " pcolor
    
    # Convert variables
    prompt=${prompt//\$directory/\\w}
    prompt=${prompt//\$date/\\d}
    prompt=${prompt//\$time/\\t}
    prompt=${prompt//\$username/\\u}
    
    echo "PS1='\[\e[1;${pcolor}m\]${prompt}\[\e[0m\] '" > ~/.termux_prompt
    echo "PROMPT='$prompt'" >> "$CONFIG"
    echo "PROMPT_COLOR='$pcolor'" >> "$CONFIG"
}

# Backup System
backup_system() {
    tar -czvf termux_backup.tar.gz \
        "$CONFIG" \
        ~/.termux/font.ttf \
        ~/.startup.mp3 \
        ~/.home_art \
        ~/.termux_prompt
    echo "Backup created: termux_backup.tar.gz"
}

# Main Menu
while true; do
    clear
    echo -e "\033[1;36m▓▒░ Termux Customizer ░▒▓\033[0m"
    echo "1. Set Password"
    echo "2. Set Custom Font"
    echo "3. Set Startup Sound"
    echo "4. Create ASCII Home"
    echo "5. Customize Prompt"
    echo "6. Create Backup"
    echo "7. Apply Changes"
    echo "8. Exit"
    
    read -p "Choose [1-8]: " choice
    
    case $choice in
        1) set_password ;;
        2) set_font ;;
        3) set_sound ;;
        4) set_home ;;
        5) set_prompt ;;
        6) backup_system ;;
        7) 
            # Apply all changes
            [ -f ~/.termux_prompt ] && source ~/.termux_prompt
            [ -f ~/.home_art ] && echo -e "\e[1;${ART_COLOR}m$(cat ~/.home_art)\e[0m"
            [ -f ~/.startup.mp3 ] && termux-media-player play ~/.startup.mp3 &
            termux-reload-settings
            echo -e "\033[1;32m✓ Changes applied!\033[0m"
            ;;
        8) exit ;;
    esac
    
    read -p "Press Enter to continue..."
done
