# ⚡ BLITZ — Zeiterfassung

> Schnelle Arbeitszeiterfassung für Elektro · Energie & Gebäudetechnik

**[→ App öffnen](https://phoenyxzzz.github.io/BLITZ)**

---

## Features

- **Schnelleingabe** — Datum, Von/Bis, Kunde und Standort auf einen Blick
- **Offline-fähig** — funktioniert ohne Internet (PWA mit Service Worker)
- **Sync** — Daten über GitHub Gist auf mehreren Geräten synchron halten
- **Übersicht** — Wochen- und Monatsauswertung mit Saldo
- **Export** — CSV-Export und druckbarer Stundenzettel (PDF)
- **Stammdaten** — Kunden und Standorte verwalten
- **PIN-Schutz** — optional, für mehr Privatsphäre

## Installation (PWA)

### iPhone / iPad
1. Safari öffnen → [phoenyxzzz.github.io/BLITZ](https://phoenyxzzz.github.io/BLITZ)
2. Teilen-Symbol → „Zum Home-Bildschirm"

### Android
1. Chrome öffnen → [phoenyxzzz.github.io/BLITZ](https://phoenyxzzz.github.io/BLITZ)
2. Menü → „App installieren"

### PC (Chrome)
1. [phoenyxzzz.github.io/BLITZ](https://phoenyxzzz.github.io/BLITZ) öffnen
2. Adressleiste → Install-Symbol → „Installieren"

## Sync einrichten

Die Synchronisation läuft über einen privaten **GitHub Gist** — keine externe Server, keine Cloud-Dienste.

1. [GitHub-Account erstellen](https://github.com/signup) (kostenlos)
2. [Klassisches Access Token erstellen](https://github.com/settings/tokens/new?type=classic) — Scope: nur `gist` anhaken
3. In der App: **Mehr → Sync** → Token einfügen → Verbinden
4. Auf weiteren Geräten: App öffnen → gleichen Token + Gist ID eingeben

## Technik

- Reines HTML/CSS/JS — kein Framework, kein Build-Tool
- Daten lokal in `localStorage`
- Offline via Service Worker (Cache-first)
- Sync via GitHub Gist API
