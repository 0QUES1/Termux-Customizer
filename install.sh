#!/bin/bash

# Initialize
CONFIG="config.cfg"
[ ! -f "$CONFIG" ] && {
    echo -e "# Termux Configuration\n" > "$CONFIG"
    mkdir -p fonts sounds
}

# Load config
source "$CONFIG" 2>/dev/null

# Track package changes
track_packages() {
    {
        pkg list-installed | awk '{print $1}'
        pip list | awk '{print $1}'
    } > "commands.log.new"
    
    if [ -f "commands.log" ]; then
        # Detect new installations
        grep -Fxvf "commands.log" "commands.log.new" | while read pkg; do
            echo "INSTALLED: $pkg" >> "commands.history"
        done
        
        # Detect removals
        grep -Fxvf "commands.log.new" "commands.log" | while read pkg; do
            echo "REMOVED: $pkg" >> "commands.history"
        done
    fi
    
    mv "commands.log.new" "commands.log"
}

# Home Customization
custom_home() {
    echo -e "\033[1;36m▓▒░ Home Customization ░▒▓\033[0m"
    echo "1. Text Design (with color)"
    echo "2. Image Design"
    read -p "Choose [1-2]: " opt
    
    case $opt in
        1)
            read -p "Enter banner text: " text
            read -p "Text color (31-37): " color
            echo "HOME_TYPE=text" >> "$CONFIG"
            echo "HOME_TEXT='$text'" >> "$CONFIG"
            echo "HOME_COLOR='$color'" >> "$CONFIG"
            ;;
        2)
            echo "Place images in sounds/ folder first!"
            ls sounds/
            read -p "Image filename: " img
            echo "HOME_TYPE=image" >> "$CONFIG"
            echo "HOME_IMAGE='$img'" >> "$CONFIG"
            termux-wallpaper -f "sounds/$img"
            ;;
    esac
}

# Prompt Customization
custom_prompt() {
    read -p "Prompt symbol (e.g., λ ★ ❯): " symbol
    read -p "Color (31=Red, 32=Green, etc.): " color
    
    echo "PROMPT='$symbol'" >> "$CONFIG"
    echo "PROMPT_COLOR='$color'" >> "$CONFIG"
    
    # Create prompt with directory
    cat > ~/.termux_prompt <<EOF
PS1='\[\e[1;${color:-32}m\][\w] ${symbol:-❯}\[\e[0m\] '
EOF
}

# Backup System
backup_system() {
    echo -e "\033[1;36m▓▒░ Backup System ░▒▓\033[0m"
    echo "1. Create Full Backup"
    echo "2. Restore Backup"
    read -p "Choose [1-2]: " opt
    
    case $opt in
        1)
            tar -czvf termux_backup.tar.gz \
                "$CONFIG" \
                commands.log \
                ~/.termux/font.ttf \
                ~/.startup.mp3 \
                ~/.termux_prompt
            echo "Backup created: termux_backup.tar.gz"
            ;;
        2)
            tar -xzvf termux_backup.tar.gz -C ~/
            echo "Restored from backup!"
            ;;
    esac
}

# Main Menu
while true; do
    clear
    echo -e "\033[1;36m▓▒░ Termux Customizer ░▒▓\033[0m"
    echo "1. Customize Home"
    echo "2. Customize Prompt"
    echo "3. Backup/Restore"
    echo "4. Apply Changes"
    echo "5. Exit"
    
    read -p "Choose [1-5]: " choice
    
    case $choice in
        1) custom_home ;;
        2) custom_prompt ;;
        3) backup_system ;;
        4) 
            track_packages
            [ -f ~/.termux_prompt ] && source ~/.termux_prompt
            
            # Apply home design
            if grep -q "HOME_TYPE=text" "$CONFIG"; then
                echo -e "\e[1;${HOME_COLOR:-36}m$HOME_TEXT\e[0m"
            fi
            
            termux-reload-settings
            echo -e "\033[1;32m✓ Changes applied!\033[0m"
            ;;
        5) exit ;;
    esac
    
    read -p "Press Enter to continue..."
done
