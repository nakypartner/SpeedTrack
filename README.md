# SpeedTrack - iOS appka na sledování rychlosti a tras

Appka ukazuje aktuální rychlost, maximální rychlost dosaženou za jízdu a
uchovává historii jízd (max/prům. rychlost, vzdálenost, doba trvání, mapa
start/cíl).

## Co je v repozitáři

```
SpeedTrack/
├── project.yml        <- XcodeGen specifikace (vygeneruje .xcodeproj bez Xcode)
├── codemagic.yaml      <- CI konfigurace pro build na cloudu
└── Sources/
    ├── SpeedTrackApp.swift
    ├── Models/Trip.swift
    ├── Managers/LocationManager.swift   (GPS, rychlost)
    ├── Managers/TripStore.swift          (ukládání historie do JSON)
    └── Views/
        ├── ContentView.swift
        ├── TrackingView.swift    (živá obrazovka - rychloměr)
        ├── HistoryView.swift     (seznam jízd)
        └── TripDetailView.swift  (detail jízdy)
```

## Krok 1 - nahrát na GitHub

1. Založ si zdarma účet na github.com (pokud nemáš).
2. Vytvoř nový **prázdný** repozitář, např. `speedtrack`.
3. Nahraj do něj celý obsah této složky `SpeedTrack/` (přes webové rozhraní
   "Add file → Upload files", nebo přes GitHub Desktop appku - obojí jde
   udělat bez terminálu).

## Krok 2 - napojit Codemagic (build appky v cloudu)

1. Jdi na **codemagic.io** a zaregistruj se přes GitHub účet (zdarma, 500
   build minut/měsíc stačí na desítky buildů).
2. "Add application" → vyber svůj `speedtrack` repozitář.
3. Codemagic automaticky najde `codemagic.yaml` v repozitáři - workflow se
   jmenuje **ios-unsigned**.
4. Klikni **Start new build**, vyber workflow `ios-unsigned` a spusť.
5. Build trvá cca 5-10 minut. Po dokončení si v sekci **Artifacts** stáhneš
   `SpeedTrack.ipa` do telefonu/počítače.

Tenhle build **nic nepodepisuje** (žádný Apple Developer účet, žádné
platby) - podpis se udělá až při instalaci přes AltStore.

## Krok 3 - instalace přes AltStore

### Pokud jsi v EU: AltStore PAL (nejjednodušší, bez počítače)
1. Nainstaluj AltStore PAL z altstore.io přímo na iPhonu (přes odkaz v
   Safari, Apple to v EU povoluje).
2. V AltStore PAL najdi možnost přidat vlastní `.ipa` (import ze
   Souborů/Files appky) a nainstaluj `SpeedTrack.ipa`.
3. Appky nainstalované přes AltStore PAL neexpirují po 7 dnech.

### Mimo EU: AltStore Classic
1. Stáhni AltServer (na Windows/Mac/Linux) a **jednou** ho spusť na
   počítači, abys spároval telefon s Apple ID (potřeba jen jednorázově,
   nebo pro obnovu appky).
2. V AltStore appce na iPhonu nainstaluj stažené `SpeedTrack.ipa`.
3. Appka s **free** Apple ID vydrží 7 dní, pak ji musíš v AltStore appce
   tlačítkem "Refresh" obnovit (AltServer musí běžet na stejné Wi-Fi, nebo
   použij nový "Remote AltServer" v AltStore Classic 2.3+, který obnovu
   umí i bez zapnutého počítače).
4. S free Apple ID můžeš mít najednou max. 3 sideloadnuté appky.

## Oprávnění k poloze

Při prvním spuštění appka požádá o přístup k poloze ("Při používání
appky"). Pro sledování na pozadí (obrazovka vypnutá) by bylo potřeba
zapnout "Always" oprávnění v Nastavení telefonu - appka na to má
připravený `UIBackgroundModes: location` v `project.yml`.

## Známé zjednodušení / co se dá dál rozšířit

- V detailu jízdy se teď kreslí jen start a cíl, ne celá čára trasy -
  plná trasa (polyline) by šla přidat přes `MKPolyline` a
  `UIViewRepresentable` obalení `MKMapView`.
- Appka nemá ikonu (výchozí Xcode ikona) - dá se přidat přes
  `Sources/Assets.xcassets` a odkaz v `project.yml`.
- Historie se ukládá jen lokálně na telefonu (soubor `trips.json` v
  Documents) - bez cloudové synchronizace.

Klidně napiš, co z toho chceš doladit nebo rozšířit (např. celá trasa na
mapě, export jízd, widget na plochu apod.).
