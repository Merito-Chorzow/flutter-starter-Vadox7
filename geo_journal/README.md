# Geo Journal

Aplikacja mobilna do zapisywania wpisów dziennika z opcjonalną lokalizacją GPS.

## 🚀 Szybki start

### 1. Zainstaluj zależności

```bash
flutter pub get
```

### 2. Uruchom backend

W osobnym terminalu:

```bash
cd ../backend
npm install
npm start
```

### 3. Uruchom aplikację

```bash
flutter run
```

## 📱 Funkcje

- ✅ Dodawanie, edycja i usuwanie wpisów
- 📍 Pobieranie i zapisywanie lokalizacji GPS
- 🗺️ Otwieranie lokalizacji w Google Maps
- 🔄 Odświeżanie listy wpisów
- 📝 Czytelne formatowanie dat i tekstu

## ⚙️ Konfiguracja

### Backend URL

Domyślnie aplikacja łączy się z:
- **Emulator Android**: `http://10.0.2.2:3000`
- **Fizyczne urządzenie**: Zmień w `lib/services/entries_api.dart`

### Uprawnienia

Aplikacja wymaga:
- Lokalizacji (GPS)
- Internetu (do komunikacji z backendem)

## 📖 Dokumentacja

Szczegółowa dokumentacja znajduje się w głównym pliku `README.md` w katalogu projektu.

## 🛠️ Rozwój

### Struktura projektu

```
lib/
├── main.dart                    # Punkt wejścia
├── models/
│   └── entry.dart             # Model danych
├── screens/
│   ├── entries_list_screen.dart
│   ├── add_entry_screen.dart
│   └── edit_entry_screen.dart
└── services/
    ├── entries_api.dart       # API client
    └── location_service.dart  # GPS service
```

### Zależności

- `flutter` - Framework UI
- `http` - HTTP client
- `geolocator` - Lokalizacja GPS
- `url_launcher` - Otwieranie zewnętrznych aplikacji
- `intl` - Formatowanie dat

## 📄 Licencja

Projekt edukacyjny.
