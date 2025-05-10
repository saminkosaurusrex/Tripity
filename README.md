# Tripity
### Description
Trip planner app

This product is final project for IZA at Faculty of Information Technology Brno University of Technology

app struct:

Tripity/
│
├── Models/                  # Priečinok pre dátové modely
│   └── TripModel.swift       # Model výletu (Trip)
|   |---Place,swift
│
├── ViewModels/              # Priečinok pre ViewModely
│   └── TripViewModel.swift  # ViewModel pre Trip
│
├── Views/                   # Priečinok pre Views (obrazovky)
│   ├── WhereView.swift       # Obrazovka "Where" - výber spôsobu prepravy
│   ├── FromView.swift        # Obrazovka "From" - výber miesta odchodu
│   ├── ToView.swift          # Obrazovka "To" - výber cieľového miesta
│   ├── DateView.swift        # Obrazovka "Date" - výber dátumov
│   ├── TripCardView.swift    # Zobrazenie karty tripu na hlavnej obrazovke
│   └── TripDetailView.swift  # Detail výletu (zobrazenie miesta, počasia, atrakcií a dátumov)
│
├── Services/                # Priečinok pre služby (API, uloženie dát, atď.)
│   └── WeatherService.swift  # Služba na získanie počasia z API
│   └── PhotoService.swift    # Služba na získanie fotiek miest z API
│   └── LocationService.swift # Služba na získanie miest na návštevu z API
│
├── Resources/               # Priečinok pre statické zdroje (obrázky, assets)
│   ├── Assets.xcassets      # Assety (ikony, obrázky, atď.)
│   └── Localizable.strings  # Preklady pre lokalizácie aplikácie
│
├── Utilities/               # Priečinok pre pomocné funkcie
│   └── DateFormatter.swift  # Pomocná trieda na formátovanie dátumov
│   └── Extensions.swift     # Rozšírenia pre bežné Swift funkcie
│
├── TripityApp.swift         # Hlavný bod aplikácie, spúšťa aplikáciu
└── ContentView.swift        # Počiatočná obrazovka aplikácie

name by : Mario Horvath
