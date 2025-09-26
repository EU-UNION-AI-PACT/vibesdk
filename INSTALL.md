# 🚀 VibeSDK - Ein-Klick Installation

## ⚡ Sofortige Installation (Ein Befehl!)

### **Linux/Mac:**
```bash
curl -fsSL https://raw.githubusercontent.com/EU-UNION-AI-PACT/vibesdk/main/install-vibesdk.sh | bash
```

### **Windows PowerShell (als Administrator):**
```powershell
iex (iwr https://raw.githubusercontent.com/EU-UNION-AI-PACT/vibesdk/main/install-vibesdk.ps1).Content
```

---

## 🎯 Was passiert automatisch:

✅ **Repository klonen** nach `~/VibeSDK`  
✅ **Bun installieren** (falls nicht vorhanden)  
✅ **Dependencies installieren** mit `bun install`  
✅ **Projekt bauen** mit `bun run build`  
✅ **Desktop-Verknüpfung erstellen**  
✅ **Terminal-Befehl `vibesdk`** einrichten  
✅ **Autostart konfigurieren** (optional)  
✅ **VibeSDK sofort starten** (optional)  

---

## 🌐 Nach der Installation verfügbar:

- **Frontend**: http://localhost:5174/
- **Backend**: http://localhost:8787/
- **API**: http://localhost:8787/api/*

---

## 💻 Start-Optionen:

1. **Desktop-Verknüpfung** - Einfach doppelklicken
2. **Terminal-Befehl** - `vibesdk` eingeben
3. **Direkt** - `~/VibeSDK/start-vibesdk.sh` ausführen

---

## 🔄 Updates:

Das System aktualisiert sich automatisch beim Start über Git Pull.

---

## 🛠️ Manuelle Installation:

Falls du die manuelle Installation bevorzugst:

```bash
git clone https://github.com/EU-UNION-AI-PACT/vibesdk.git ~/VibeSDK
cd ~/VibeSDK
bun install
bun run build
./start-vibesdk.sh
```

---

## 🔧 Entwicklung:

```bash
cd ~/VibeSDK

# Nur Frontend (empfohlen für UI-Arbeit)
bun run dev:frontend

# Full-Stack mit Backend
bun run dev:fullstack

# Build für Produktion
bun run build
```

---

## 📞 Support:

Bei Problemen erstelle ein Issue: https://github.com/EU-UNION-AI-PACT/vibesdk/issues

---

**Happy Coding! 🎉**

*VibeSDK - Dein privates Development Environment*