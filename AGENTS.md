# 📘 GLua – Agent Rules & Best Practices

Dieses Dokument definiert die Standards und Best Practices für die Entwicklung von Garry's Mod Addons. Es dient als zentrale Richtlinie für AI-Agents und Entwickler zur Erstellung von performantem, sicherem und wartbarem GLua-Code.

> **Für detaillierte Erklärungen und Code-Beispiele siehe die Dokumente in `ai-docs/`.**

---

## 🏗️ Projekt-Konventionen (Quick Reference)

### Datei-Präfixe & Realms

| Präfix | Realm | Beschreibung |
|--------|-------|-------------|
| `sv_*.lua` | `SERVER` | Nur Server-Code (DB, Gamelogik) |
| `cl_*.lua` | `CLIENT` | Nur Client-Code (UI, HUD, Rendering) |
| `sh_*.lua` | `SERVER` + `CLIENT` | Shared Code (Config, Utils, Enums) |

### Naming-Konventionen

| Was | Stil | Beispiel |
|-----|------|---------|
| Lokale Variablen/Funktionen | `camelCase` | `local playerSpeed = 250` |
| Globale Addon-Tabellen | `PascalCase` | `<AddonName>.PlayerManager` |
| Konstanten | `UPPER_SNAKE_CASE` | `<AddonName>.MAX_HEALTH = 100` |
| Private Funktionen | `_` Prefix | `<AddonName>:_InternalHelper()` |
| Hook/Timer IDs | Addon-Prefix | `<AddonName>_BeschreibenderName` |

### Datei-Reihenfolge (innerhalb einer Datei)

```lua
-- 1. Lokale Variablen / Konstanten
local COOLDOWN_TIME = 5
local COLOR_PRIMARY = Color(52, 152, 219)

-- 2. Lokale Hilfsfunktionen
local function calculateDamage(base, modifier) ... end

-- 3. Öffentliche Funktionen (Addon-Namespace)
function <AddonName>:DealDamage(ply, amount) ... end

-- 4. Hooks & Timer (am Ende der Datei)
hook.Add("PlayerHurt", "<AddonName>_OnHurt", function(...) end)
```

### Kern-Regeln (immer beachten)

1. **`local` verwenden** – Globale Variablen nur für die Addon-API-Tabelle
2. **`IsValid()` prüfen** – Vor jedem Entity/Player-Zugriff, besonders in Timern
3. **Addon-Prefix** – Für alle Hooks, Timer, ConVars, Net Messages, Meta-Methoden
4. **`X = X or {}`** – Für Autorefresh-Kompatibilität bei globalen Tabellen
5. **NW2 statt NW1** – `SetNW2Int` statt `SetNWInt` (NW1 ist Legacy, per-Tick)
6. **Nie dem Client vertrauen** – Alle `net.Receive`-Daten serverseitig validieren
7. **`sql.SQLStr()` nutzen** – Für alle User-Inputs in SQL-Queries
8. **Keine Allokationen in Hot-Loops** – `Color()`, `Vector()`, `Material()` außerhalb cachen
9. **Nie `RunString`/`CompileString` mit externen Daten** – Ermöglicht Remote Code Execution

### Networking-Priorität (effizienteste zuerst)

1. `SetupDataTables` (NetworkVar) → Für eigene SENTs
2. NW2 Vars (`SetNW2*`) → Für Player/Entity States
3. Net Library (`net.Start`) → Für Events / einmalige Daten
4. ~~NW1 Vars~~ → Vermeiden (Legacy)

### Rückgabemuster für API-Funktionen

```lua
-- Erfolg: return true, <result_data>
-- Fehler: return false, <error_message>
local success, result = <AddonName>:GiveItem(ply, "sword_01")
```

---

## 📁 Standard-Ordnerstruktur

```text
<addon_name>/
├── addon.json                       # Workshop-Metadaten
├── config/                          # (Optional) Externe Konfiguration
├── lua/
│   ├── autorun/
│   │   ├── sh_<addon>_init.lua      # Entry Point (lädt alle anderen Dateien)
│   ├── <addon_name>/                # Eigener Namespace-Ordner
│   │   ├── client/                  # cl_*.lua Dateien
│   │   ├── server/                  # sv_*.lua Dateien
│   │   └── shared/                  # sh_*.lua Dateien
│   ├── entities/                    # Custom SENTs
│   └── weapons/                     # Custom SWEPs
├── materials/                       # Texturen & VMTs
├── models/                          # 3D Modelle
├── resource/                        # Fonts
└── sound/                           # Audio-Dateien
```

---

## 📚 Detaillierte Dokumentation (`ai-docs/`)

| Dokument | Inhalt |
|----------|--------|
| [01-project-structure.md](ai-docs/01-project-structure.md) | Ordnerstruktur, File Loading, Realms, dynamisches Laden |
| [02-performance.md](ai-docs/02-performance.md) | Lokale Vars, Hook-Optimierung, Caching, String-Ops, Coroutines, Object-Pooling |
| [03-timers.md](ai-docs/03-timers.md) | Timer-Benennung, `timer.Simple` vs `timer.Create`, IsValid in Timern |
| [04-networking.md](ai-docs/04-networking.md) | Net Library, NW2Vars, DTVars, Rate Limiting, Net-String-Limits |
| [05-error-handling.md](ai-docs/05-error-handling.md) | Defensive Programmierung, pcall, Logging, Debug-Modus, Profiling |
| [06-hooks.md](ai-docs/06-hooks.md) | Hook-IDs, Cleanup, Rückgabewerte, hook.Run vs hook.Call |
| [07-security.md](ai-docs/07-security.md) | IsValid, Namespaces, Enums, SQL-Injection, HTTP-Requests, RunString/CompileString |
| [08-vgui.md](ai-docs/08-vgui.md) | Panel-Management, Skalierung, Animationen, 3D2D Rendering |
| [09-code-style.md](ai-docs/09-code-style.md) | Kommentare, Einrückung, Zeilenlänge, Funktionslänge, Early Returns |
| [10-common-pitfalls.md](ai-docs/10-common-pitfalls.md) | Häufige Fehler, IsFirstTimePredicted, Anti-Patterns, Code Smells |
| [11-data-persistence.md](ai-docs/11-data-persistence.md) | JSON, SQLite, mysqloo, Speicher-Zeitpunkte |
| [12-lifecycle.md](ai-docs/12-lifecycle.md) | Shutdown, Spieler-Lifecycle, Entity Cleanup, CallOnRemove, Map-Cleanup |
| [13-addon-ecosystem.md](ai-docs/13-addon-ecosystem.md) | Kompatibilität, ConVars, ConCommands, Custom Hooks |
| [14-metatables-oop.md](ai-docs/14-metatables-oop.md) | Meta-Tables erweitern, eigene Klassen, Vererbung |
| [15-assets-and-deployment.md](ai-docs/15-assets-and-deployment.md) | Resource Management, Sound, Workshop, addon.json |
