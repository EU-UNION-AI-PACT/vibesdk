#!/bin/bash
# VibeSDK - Vollautomatischer Ein-Klick-Installer
# Lädt das Repository herunter, installiert alles und startet das System

set -e  # Exit bei Fehlern

# Konfiguration
REPO_URL="https://github.com/EU-UNION-AI-PACT/vibesdk.git"
INSTALL_DIR="$HOME/VibeSDK"
DESKTOP_NAME="VibeSDK"

# Farben für Output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${PURPLE}"
echo "🚀 VibeSDK - Vollautomatischer Installer"
echo "========================================"
echo -e "${NC}"

# Überprüfe Voraussetzungen
check_requirements() {
    echo -e "${BLUE}[1/8] Überprüfe Systemvoraussetzungen...${NC}"
    
    # Git überprüfen
    if ! command -v git &> /dev/null; then
        echo -e "${RED}❌ Git ist nicht installiert!${NC}"
        echo "Installiere Git: sudo apt install git (Ubuntu/Debian) oder brew install git (Mac)"
        exit 1
    fi
    
    # Bun installieren falls nicht vorhanden
    if ! command -v bun &> /dev/null; then
        echo -e "${YELLOW}⚠️  Bun nicht gefunden. Installiere Bun...${NC}"
        curl -fsSL https://bun.sh/install | bash
        source ~/.bashrc
        
        if ! command -v bun &> /dev/null; then
            echo -e "${RED}❌ Bun-Installation fehlgeschlagen!${NC}"
            echo "Installiere Bun manuell: https://bun.sh/"
            exit 1
        fi
    fi
    
    echo -e "${GREEN}✅ Alle Voraussetzungen erfüllt${NC}"
}

# Repository klonen oder updaten
clone_repo() {
    echo -e "${BLUE}[2/8] Repository herunterladen...${NC}"
    
    if [[ -d "$INSTALL_DIR" ]]; then
        echo -e "${YELLOW}Repository existiert bereits. Aktualisiere...${NC}"
        cd "$INSTALL_DIR"
        git pull origin main
    else
        echo -e "${YELLOW}Klone Repository nach $INSTALL_DIR...${NC}"
        git clone "$REPO_URL" "$INSTALL_DIR"
        cd "$INSTALL_DIR"
    fi
    
    echo -e "${GREEN}✅ Repository bereit${NC}"
}

# Dependencies installieren
install_deps() {
    echo -e "${BLUE}[3/8] Dependencies installieren...${NC}"
    bun install
    echo -e "${GREEN}✅ Dependencies installiert${NC}"
}

# Projekt bauen
build_project() {
    echo -e "${BLUE}[4/8] Projekt bauen...${NC}"
    bun run build
    echo -e "${GREEN}✅ Projekt gebaut${NC}"
}

# Desktop-Integration
setup_desktop() {
    echo -e "${BLUE}[5/8] Desktop-Integration einrichten...${NC}"
    
    # Linux Desktop-Verknüpfung
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        DESKTOP_DIR="$HOME/Desktop"
        APPLICATIONS_DIR="$HOME/.local/share/applications"
        
        mkdir -p "$APPLICATIONS_DIR"
        
        # Desktop-Datei erstellen
        cat > "$APPLICATIONS_DIR/$DESKTOP_NAME.desktop" << EOF
[Desktop Entry]
Version=1.0
Name=$DESKTOP_NAME
Comment=VibeSDK Development Environment
Exec=$INSTALL_DIR/start-vibesdk.sh
Icon=applications-development
Terminal=true
Type=Application
Categories=Development;Programming;
Path=$INSTALL_DIR
StartupNotify=true
EOF
        
        chmod +x "$APPLICATIONS_DIR/$DESKTOP_NAME.desktop"
        
        # Auch auf Desktop kopieren
        if [[ -d "$DESKTOP_DIR" ]]; then
            cp "$APPLICATIONS_DIR/$DESKTOP_NAME.desktop" "$DESKTOP_DIR/"
            chmod +x "$DESKTOP_DIR/$DESKTOP_NAME.desktop"
        fi
        
        echo -e "${GREEN}✅ Linux Desktop-Verknüpfung erstellt${NC}"
        
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS Alias
        if [[ -f "$HOME/.zshrc" ]]; then
            if ! grep -q "alias vibesdk=" "$HOME/.zshrc"; then
                echo "alias vibesdk='cd $INSTALL_DIR && ./start-vibesdk.sh'" >> "$HOME/.zshrc"
            fi
        fi
        
        if [[ -f "$HOME/.bash_profile" ]]; then
            if ! grep -q "alias vibesdk=" "$HOME/.bash_profile"; then
                echo "alias vibesdk='cd $INSTALL_DIR && ./start-vibesdk.sh'" >> "$HOME/.bash_profile"
            fi
        fi
        
        echo -e "${GREEN}✅ macOS Terminal-Alias erstellt${NC}"
    fi
}

# Terminal-Befehl einrichten
setup_terminal_command() {
    echo -e "${BLUE}[6/8] Terminal-Befehl 'vibesdk' einrichten...${NC}"
    
    # Versuche symbolischen Link zu erstellen
    if sudo ln -sf "$INSTALL_DIR/start-vibesdk.sh" "/usr/local/bin/vibesdk" 2>/dev/null; then
        echo -e "${GREEN}✅ Globaler 'vibesdk' Befehl verfügbar${NC}"
    else
        # Fallback: Shell-Alias
        for rc_file in "$HOME/.bashrc" "$HOME/.zshrc"; do
            if [[ -f "$rc_file" ]] && ! grep -q "alias vibesdk=" "$rc_file"; then
                echo "alias vibesdk='$INSTALL_DIR/start-vibesdk.sh'" >> "$rc_file"
            fi
        done
        echo -e "${YELLOW}⚠️  Alias 'vibesdk' hinzugefügt (Terminal neu starten)${NC}"
    fi
}

# Autostart konfigurieren (optional)
setup_autostart() {
    echo -e "${BLUE}[7/8] Autostart-Option...${NC}"
    
    read -p "Soll VibeSDK beim Systemstart automatisch starten? (j/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[JjYy]$ ]]; then
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            AUTOSTART_DIR="$HOME/.config/autostart"
            mkdir -p "$AUTOSTART_DIR"
            
            cat > "$AUTOSTART_DIR/vibesdk.desktop" << EOF
[Desktop Entry]
Type=Application
Name=VibeSDK Development
Exec=$INSTALL_DIR/start-vibesdk.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Comment=Starte VibeSDK Development Environment
EOF
            echo -e "${GREEN}✅ Autostart konfiguriert${NC}"
        else
            echo -e "${YELLOW}⚠️  Autostart für macOS manuell einrichten${NC}"
        fi
    else
        echo -e "${BLUE}⏭️  Autostart übersprungen${NC}"
    fi
}

# Starten
start_vibesdk() {
    echo -e "${BLUE}[8/8] VibeSDK starten...${NC}"
    echo
    echo -e "${GREEN}🎉 Installation erfolgreich abgeschlossen!${NC}"
    echo
    echo -e "${PURPLE}Verfügbare Start-Optionen:${NC}"
    echo -e "1. ${YELLOW}Desktop-Verknüpfung${NC} (falls erstellt)"
    echo -e "2. ${YELLOW}Terminal: vibesdk${NC}"
    echo -e "3. ${YELLOW}Direkt: $INSTALL_DIR/start-vibesdk.sh${NC}"
    echo
    
    read -p "VibeSDK jetzt starten? (J/n): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${BLUE}Starte VibeSDK...${NC}"
        echo
        "$INSTALL_DIR/start-vibesdk.sh"
    else
        echo -e "${BLUE}Du kannst VibeSDK später mit 'vibesdk' starten${NC}"
    fi
}

# Hauptinstallation
main() {
    check_requirements
    clone_repo
    install_deps
    build_project
    setup_desktop
    setup_terminal_command
    setup_autostart
    start_vibesdk
}

# Fehler-Handler
trap 'echo -e "${RED}❌ Installation fehlgeschlagen!${NC}"; exit 1' ERR

# Installation starten
main "$@"