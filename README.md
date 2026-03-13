# ⚡ BLITZ — Zeiterfassung

> Schnelle Arbeitszeiterfassung für Elektro · Energie & Gebäudetechnik

**[→ App öffnen](https://phoenyxzzz.github.io/BLITZ)**

---

## Features

### Zeiterfassung
- **Schnelleingabe** — Datum, Von/Bis, Kunde und Standort auf einen Blick
- **Live-Timer** — Einstempeln & Ausstempeln mit Pausen-Funktion
- **Tätigkeiten** — Installation, Wartung, Störung, Inbetriebnahme, Planung, Sonstiges
- **Titel & Notizen** — freie Beschreibung pro Eintrag

### Übersicht & Auswertung
- **Wochenansicht** — alle Tage auf einen Blick mit Tages-Saldo
- **Monatsansicht** — Mini-Kalender + Detailliste gruppiert nach Kalenderwochen
- **Jahresansicht** — Monatsbalken und Jahresgesamt-Statistik
- **Auswertung** — Statistiken und Kundenübersicht

### Urlaub & Feiertage
- **Urlaubsverwaltung** — Tage direkt in der Monatsansicht als Urlaub markieren/entfernen
- **Deutsche Feiertage** — automatisch berechnet (bundesweit, inkl. beweglicher Feiertage)
- **Urlaubspanel** — Resturlaub, Fortschrittsbalken, Jahresurlaub konfigurierbar
- **Überstunden-Konto** — Jahres-Saldo inkl. Vortragsminuten, Feiertage & Urlaub werden vom Soll abgezogen

### Saldo & Wochensoll
- **Wochensoll** — konfigurierbar direkt in der App
- **Saldo** — Wochen- und Monatssaldo mit Feiertags- & Urlaubsberücksichtigung
- **Überstunden-Vortrag** — konfigurierbarer Stundenübertrag aus Vorperioden

### Daten & Export
- **Offline-fähig** — funktioniert ohne Internet (PWA mit Service Worker)
- **Sync** — Daten über GitHub Gist auf mehreren Geräten synchron halten
- **PDF Stundenzettel** — druckfertiger Export, filterbar nach Zeitraum und Kunde
- **CSV-Export** — für Excel oder Numbers
- **Stammdaten** — Kunden und Standorte verwalten

### Sonstiges
- **PIN-Schutz** — optional, für mehr Privatsphäre
- **Dark Mode** — automatisch je nach Systemeinstellung
- **Animationen** — Apple-Style Micro-Animationen, respektiert `prefers-reduced-motion`

---

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

---

## Sync einrichten

Die Synchronisation läuft über einen privaten **GitHub Gist** — keine externen Server, keine Cloud-Dienste.

1. [GitHub-Account erstellen](https://github.com/signup) (kostenlos)
2. [Klassisches Access Token erstellen](https://github.com/settings/tokens/new?type=classic) — Scope: nur `gist` anhaken
3. In der App: **Mehr → Sync** → Token einfügen → Verbinden
4. Auf weiteren Geräten: App öffnen → gleichen Token + Gist ID eingeben

---

## Technik

- Reines HTML/CSS/JS — kein Framework, kein Build-Tool
- Daten lokal in `localStorage`
- Offline via Service Worker (Cache-first)
- Sync via GitHub Gist API
- Deutsche Feiertage per Osteralgorithmus berechnet (kein API-Aufruf nötig)
