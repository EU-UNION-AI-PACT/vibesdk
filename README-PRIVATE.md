# 🚀 VibeSDK - Dein Privates Development Setup

Ein vollständig konfiguriertes Cloudflare Workers + React Development-Environment.

## 📋 Voraussetzungen

### Erforderlich:
- **Bun** (JavaScript Runtime): [bun.sh](https://bun.sh/)
- **Git** (Version Control)
- **Node.js 18+** (falls Bun nicht verfügbar)

### Optional:
- **Docker** (für Container-Features)
- **Visual Studio Code** (empfohlener Editor)

## ⚡ Schnellstart

### 1. Repository klonen
```bash
git clone https://github.com/[DEIN-USERNAME]/vibesdk.git
cd vibesdk
```

### 2. Desktop-Launcher verwenden

**Windows:**
- Doppelklick auf `start-vibesdk.bat`

**Linux/Mac:**
```bash
./start-vibesdk.sh
```

### 3. Manueller Start
```bash
# Dependencies installieren
bun install

# Projekt bauen
bun run build

# Frontend-only (empfohlen für UI-Entwicklung)
bun run dev:frontend
# → http://localhost:5173/

# Full-Stack mit Backend (für API-Integration)
bun run dev:fullstack  
# → http://localhost:8787/
```

## 🛠️ Verfügbare Kommandos

| Kommando | Beschreibung |
|----------|--------------|
| `bun run dev:frontend` | Nur Frontend (Vite) |
| `bun run dev:fullstack` | Frontend + Backend (Worker) |
| `bun run dev:simple` | Alternative Frontend-Konfiguration |
| `bun run build` | Production Build |
| `bun run test` | Tests ausführen |
| `bun run lint` | Code-Qualität prüfen |

## 🌐 URLs im Development

- **Frontend**: http://localhost:5173/
- **Full-Stack**: http://localhost:8787/
- **API-Routen**: http://localhost:8787/api/*

## 📁 Projektstruktur

```
vibesdk/
├── src/                    # React Frontend
├── worker/                 # Cloudflare Worker Backend
├── shared/                 # Geteilte Typen/Utils
├── dist/                   # Build-Output
├── .dev.vars              # Entwicklungs-Umgebungsvariablen
├── start-vibesdk.bat      # Windows-Launcher
├── start-vibesdk.sh       # Linux/Mac-Launcher
└── package.json           # Dependencies & Scripts
```

## 🔧 Konfiguration

### Umgebungsvariablen

Die Datei `.dev.vars` enthält alle notwendigen Umgebungsvariablen für die lokale Entwicklung. Für Produktion sollten diese in den entsprechenden Services konfiguriert werden.

### Build-Konfigurationen

- `vite.config.ts` - Standard-Konfiguration mit Cloudflare-Integration
- `vite.config.simple.ts` - Vereinfachte Frontend-only Konfiguration
- `wrangler.*.jsonc` - Verschiedene Worker-Konfigurationen

## 🚀 Deployment

### Automatisch (GitHub Actions)
Push auf `main` branch triggert automatisches Deployment.

### Manuell
```bash
# Cloudflare Workers
bun run deploy

# Oder mit Wrangler
bun wrangler deploy
```

## 🔄 Kontinuierliche Entwicklung

Das Setup ist so konfiguriert, dass:

1. **Auto-Reload**: Änderungen werden automatisch neu geladen
2. **Hot Module Replacement**: Schnelle Entwicklungszyklen
3. **TypeScript**: Vollständige Typsicherheit
4. **Linting**: Code-Qualität wird automatisch geprüft

## 🐛 Troubleshooting

### Port bereits in Verwendung
```bash
# Linux/Mac
lsof -ti:5173 | xargs kill -9
lsof -ti:8787 | xargs kill -9

# Windows
netstat -ano | findstr :5173
taskkill /PID <PID> /F
```

### Bun nicht gefunden
```bash
# Installation
curl -fsSL https://bun.sh/install | bash
source ~/.bashrc
```

### Módule können nicht aufgelöst werden
```bash
# Node modules löschen und neu installieren
rm -rf node_modules
rm bun.lock
bun install
```

## 📞 Support

Bei Problemen oder Fragen erstelle ein Issue im Repository.

---

**Happy Coding! 🎉**