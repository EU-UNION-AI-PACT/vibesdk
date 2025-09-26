# VibeSDK - Vollautomatischer Windows PowerShell Installer
# Lädt das Repository herunter, installiert alles und startet das System

param(
    [string]$InstallDir = "$env:USERPROFILE\VibeSDK",
    [switch]$AutoStart
)

# Konfiguration
$RepoUrl = "https://github.com/EU-UNION-AI-PACT/vibesdk.git"
$DesktopName = "VibeSDK"

Write-Host @"

🚀 VibeSDK - Vollautomatischer Windows Installer
================================================

"@ -ForegroundColor Magenta

# Überprüfe Voraussetzungen
function Test-Requirements {
    Write-Host "[1/8] Überprüfe Systemvoraussetzungen..." -ForegroundColor Blue
    
    # Git überprüfen
    if (!(Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Host "❌ Git ist nicht installiert!" -ForegroundColor Red
        Write-Host "Installiere Git von: https://git-scm.com/download/win" -ForegroundColor Yellow
        exit 1
    }
    
    # PowerShell Version überprüfen
    if ($PSVersionTable.PSVersion.Major -lt 5) {
        Write-Host "❌ PowerShell 5.0+ erforderlich!" -ForegroundColor Red
        exit 1
    }
    
    # Bun installieren falls nicht vorhanden
    if (!(Get-Command bun -ErrorAction SilentlyContinue)) {
        Write-Host "⚠️  Bun nicht gefunden. Installiere Bun..." -ForegroundColor Yellow
        
        try {
            # Bun für Windows installieren
            Invoke-RestMethod -Uri "https://bun.sh/install.ps1" | Invoke-Expression
            $env:PATH = "$env:USERPROFILE\.bun\bin;$env:PATH"
            
            if (!(Get-Command bun -ErrorAction SilentlyContinue)) {
                Write-Host "❌ Bun-Installation fehlgeschlagen!" -ForegroundColor Red
                Write-Host "Installiere Bun manuell: https://bun.sh/" -ForegroundColor Yellow
                exit 1
            }
        }
        catch {
            Write-Host "❌ Bun-Installation fehlgeschlagen: $_" -ForegroundColor Red
            exit 1
        }
    }
    
    Write-Host "✅ Alle Voraussetzungen erfüllt" -ForegroundColor Green
}

# Repository klonen oder updaten
function Get-Repository {
    Write-Host "[2/8] Repository herunterladen..." -ForegroundColor Blue
    
    if (Test-Path $InstallDir) {
        Write-Host "Repository existiert bereits. Aktualisiere..." -ForegroundColor Yellow
        Set-Location $InstallDir
        git pull origin main
    }
    else {
        Write-Host "Klone Repository nach $InstallDir..." -ForegroundColor Yellow
        git clone $RepoUrl $InstallDir
        Set-Location $InstallDir
    }
    
    Write-Host "✅ Repository bereit" -ForegroundColor Green
}

# Dependencies installieren
function Install-Dependencies {
    Write-Host "[3/8] Dependencies installieren..." -ForegroundColor Blue
    bun install
    Write-Host "✅ Dependencies installiert" -ForegroundColor Green
}

# Projekt bauen
function Build-Project {
    Write-Host "[4/8] Projekt bauen..." -ForegroundColor Blue
    bun run build
    Write-Host "✅ Projekt gebaut" -ForegroundColor Green
}

# Desktop-Integration
function Set-DesktopIntegration {
    Write-Host "[5/8] Desktop-Integration einrichten..." -ForegroundColor Blue
    
    $DesktopPath = [Environment]::GetFolderPath("Desktop")
    $StartMenuPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"
    
    # Windows Batch-Datei für Desktop
    $BatchContent = @"
@echo off
cd /d "$InstallDir"
call start-vibesdk.bat
"@
    
    $BatchPath = "$DesktopPath\$DesktopName.bat"
    $BatchContent | Out-File -FilePath $BatchPath -Encoding ASCII
    
    # Auch ins Startmenü
    $StartMenuBatch = "$StartMenuPath\$DesktopName.bat"
    Copy-Item $BatchPath $StartMenuBatch -Force
    
    Write-Host "✅ Windows Desktop-Verknüpfung erstellt" -ForegroundColor Green
}

# Terminal-Befehl einrichten
function Set-TerminalCommand {
    Write-Host "[6/8] Terminal-Befehl 'vibesdk' einrichten..." -ForegroundColor Blue
    
    # PowerShell-Profil aktualisieren
    $ProfilePath = $PROFILE
    $AliasCommand = "function vibesdk { Set-Location '$InstallDir'; .\start-vibesdk.bat }"
    
    if (!(Test-Path $ProfilePath)) {
        New-Item -ItemType File -Path $ProfilePath -Force | Out-Null
    }
    
    $ProfileContent = Get-Content $ProfilePath -Raw -ErrorAction SilentlyContinue
    if ($ProfileContent -notmatch "function vibesdk") {
        Add-Content -Path $ProfilePath -Value "`n$AliasCommand"
        Write-Host "✅ PowerShell-Funktion 'vibesdk' hinzugefügt" -ForegroundColor Green
    }
    else {
        Write-Host "⚠️  'vibesdk' Funktion bereits vorhanden" -ForegroundColor Yellow
    }
}

# Autostart konfigurieren
function Set-Autostart {
    Write-Host "[7/8] Autostart-Option..." -ForegroundColor Blue
    
    if (!$AutoStart) {
        $Response = Read-Host "Soll VibeSDK beim Systemstart automatisch starten? (j/N)"
        if ($Response -notmatch "^[JjYy]") {
            Write-Host "⏭️  Autostart übersprungen" -ForegroundColor Blue
            return
        }
    }
    
    # Windows Autostart-Ordner
    $StartupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
    $StartupBatch = "$StartupPath\$DesktopName.bat"
    
    $AutostartContent = @"
@echo off
cd /d "$InstallDir"
start "" start-vibesdk.bat
"@
    
    $AutostartContent | Out-File -FilePath $StartupBatch -Encoding ASCII
    Write-Host "✅ Windows Autostart konfiguriert" -ForegroundColor Green
}

# VibeSDK starten
function Start-VibeSDK {
    Write-Host "[8/8] VibeSDK starten..." -ForegroundColor Blue
    Write-Host ""
    Write-Host "🎉 Installation erfolgreich abgeschlossen!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Verfügbare Start-Optionen:" -ForegroundColor Magenta
    Write-Host "1. Desktop-Verknüpfung (Doppelklick)" -ForegroundColor Yellow
    Write-Host "2. PowerShell: vibesdk" -ForegroundColor Yellow
    Write-Host "3. Direkt: $InstallDir\start-vibesdk.bat" -ForegroundColor Yellow
    Write-Host ""
    
    $Response = Read-Host "VibeSDK jetzt starten? (J/n)"
    
    if ($Response -notmatch "^[Nn]") {
        Write-Host "Starte VibeSDK..." -ForegroundColor Blue
        Write-Host ""
        & "$InstallDir\start-vibesdk.bat"
    }
    else {
        Write-Host "Du kannst VibeSDK später mit 'vibesdk' starten" -ForegroundColor Blue
    }
}

# Hauptinstallation
function Install-VibeSDK {
    try {
        Test-Requirements
        Get-Repository
        Install-Dependencies
        Build-Project
        Set-DesktopIntegration
        Set-TerminalCommand
        Set-Autostart
        Start-VibeSDK
    }
    catch {
        Write-Host "❌ Installation fehlgeschlagen: $_" -ForegroundColor Red
        exit 1
    }
}

# Installation starten
Install-VibeSDK