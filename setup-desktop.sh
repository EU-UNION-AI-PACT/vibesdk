#!/bin/bash
# VibeSDK Desktop Setup Script
# Dieses Skript erstellt Desktop-Verknüpfungen und konfiguriert das System

echo "🚀 VibeSDK Desktop Setup"
echo "========================"

# Farben
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}Projekt-Verzeichnis: $PROJECT_DIR${NC}"

# Überprüfe Betriebssystem
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    echo -e "${YELLOW}Linux-System erkannt${NC}"
    
    # Desktop-Verknüpfung erstellen
    DESKTOP_DIR="$HOME/Desktop"
    if [[ -d "$DESKTOP_DIR" ]]; then
        cat > "$DESKTOP_DIR/VibeSDK.desktop" << EOF
[Desktop Entry]
Version=1.0
Name=VibeSDK Development
Comment=Starte VibeSDK Development Environment
Exec=$PROJECT_DIR/start-vibesdk.sh
Icon=applications-development
Terminal=true
Type=Application
Categories=Development;
Path=$PROJECT_DIR
EOF
        chmod +x "$DESKTOP_DIR/VibeSDK.desktop"
        echo -e "${GREEN}✅ Desktop-Verknüpfung erstellt${NC}"
    fi
    
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    echo -e "${YELLOW}macOS-System erkannt${NC}"
    
    # Alias für Terminal erstellen
    if [[ -f "$HOME/.zshrc" ]]; then
        echo "alias vibesdk='cd $PROJECT_DIR && ./start-vibesdk.sh'" >> "$HOME/.zshrc"
        echo -e "${GREEN}✅ Terminal-Alias 'vibesdk' hinzugefügt (.zshrc)${NC}"
    fi
    
    if [[ -f "$HOME/.bash_profile" ]]; then
        echo "alias vibesdk='cd $PROJECT_DIR && ./start-vibesdk.sh'" >> "$HOME/.bash_profile"
        echo -e "${GREEN}✅ Terminal-Alias 'vibesdk' hinzugefügt (.bash_profile)${NC}"
    fi
    
else
    echo -e "${YELLOW}Unbekanntes System: $OSTYPE${NC}"
fi

# Erstelle Autostart-Skript (optional)
echo
read -p "Möchtest du VibeSDK beim Systemstart automatisch starten? (j/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[JjYy]$ ]]; then
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux Autostart
        AUTOSTART_DIR="$HOME/.config/autostart"
        mkdir -p "$AUTOSTART_DIR"
        cat > "$AUTOSTART_DIR/vibesdk.desktop" << EOF
[Desktop Entry]
Type=Application
Name=VibeSDK Development
Exec=$PROJECT_DIR/start-vibesdk.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF
        echo -e "${GREEN}✅ Autostart konfiguriert${NC}"
    fi
fi

# PATH-Umgebung hinzufügen (optional)
echo
read -p "Möchtest du 'vibesdk' als Terminal-Befehl verfügbar machen? (j/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[JjYy]$ ]]; then
    # Symbolischen Link erstellen
    sudo ln -sf "$PROJECT_DIR/start-vibesdk.sh" "/usr/local/bin/vibesdk" 2>/dev/null
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}✅ Terminal-Befehl 'vibesdk' verfügbar${NC}"
    else
        echo -e "${YELLOW}⚠️  Konnte globalen Befehl nicht erstellen (Berechtigung fehlt)${NC}"
        # Fallback: Alias hinzufügen
        if [[ -f "$HOME/.bashrc" ]]; then
            echo "alias vibesdk='$PROJECT_DIR/start-vibesdk.sh'" >> "$HOME/.bashrc"
            echo -e "${GREEN}✅ Terminal-Alias 'vibesdk' hinzugefügt (.bashrc)${NC}"
        fi
    fi
fi

echo
echo -e "${GREEN}🎉 Setup abgeschlossen!${NC}"
echo
echo -e "${BLUE}Verfügbare Start-Optionen:${NC}"
echo -e "1. Desktop-Verknüpfung (falls erstellt)"
echo -e "2. Terminal: ${YELLOW}./start-vibesdk.sh${NC}"
echo -e "3. Terminal: ${YELLOW}vibesdk${NC} (falls konfiguriert)"
echo -e "4. Direkt: ${YELLOW}cd $PROJECT_DIR && ./start-vibesdk.sh${NC}"
echo