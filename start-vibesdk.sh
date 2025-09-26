#!/bin/bash
# VibeSDK Linux/Mac Launcher
# Dieses Skript startet die VibeSDK Development-Umgebung

echo "============================================"
echo "           VibeSDK Development Launcher"
echo "============================================"
echo

# Farben für bessere Ausgabe
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Überprüfe ob Bun installiert ist
if ! command -v bun &> /dev/null; then
    echo -e "${RED}FEHLER: Bun ist nicht installiert!${NC}"
    echo -e "${YELLOW}Bitte installiere Bun von: https://bun.sh/${NC}"
    echo "Für Linux/Mac: curl -fsSL https://bun.sh/install | bash"
    exit 1
fi

# Überprüfe ob wir im richtigen Verzeichnis sind
if [[ ! -f "package.json" ]]; then
    echo -e "${RED}FEHLER: package.json nicht gefunden!${NC}"
    echo -e "${YELLOW}Bitte führe das Skript aus dem VibeSDK-Projektverzeichnis aus.${NC}"
    exit 1
fi

echo -e "${BLUE}Aktives Verzeichnis: $(pwd)${NC}"
echo

# Installation der Dependencies
echo -e "${YELLOW}[1/3] Installiere Dependencies...${NC}"
bun install

# Build das Projekt
echo -e "${YELLOW}[2/3] Baue das Projekt...${NC}"
bun run build

# Starte die Development-Umgebung
echo -e "${YELLOW}[3/3] Starte VibeSDK...${NC}"
echo
echo -e "${GREEN}Frontend URL: http://localhost:5173/${NC}"
echo -e "${GREEN}Backend URL:  http://localhost:8787/${NC}"
echo
echo -e "${BLUE}Drücke Ctrl+C um den Server zu stoppen${NC}"
echo

# Cleanup-Funktion für Ctrl+C
cleanup() {
    echo
    echo -e "${YELLOW}Stoppe VibeSDK...${NC}"
    
    # Stoppe alle Background-Prozesse
    pkill -f "bun run dev" 2>/dev/null || true
    pkill -f "vite" 2>/dev/null || true
    pkill -f "wrangler" 2>/dev/null || true
    
    echo -e "${GREEN}VibeSDK wurde beendet.${NC}"
    exit 0
}

# Registriere Cleanup-Funktion für Ctrl+C
trap cleanup SIGINT SIGTERM

# Starte Frontend und Backend
echo -e "${BLUE}Starte Frontend...${NC}"
bun run dev:frontend &
FRONTEND_PID=$!

# Warte kurz
sleep 3

echo -e "${BLUE}Starte Backend...${NC}"
bun run dev:fullstack &
BACKEND_PID=$!

echo
echo -e "${GREEN}✅ VibeSDK läuft erfolgreich!${NC}"
echo -e "${BLUE}Drücke Ctrl+C um zu beenden...${NC}"

# Warte auf Benutzer-Unterbrechung
wait