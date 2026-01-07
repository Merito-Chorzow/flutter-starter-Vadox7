# Geo Journal 📱

Aplikacja mobilna Flutter do tworzenia, edytowania i przeglądania wpisów dziennika z opcjonalną lokalizacją GPS i danymi z czujników urządzenia. Wpisy są przechowywane w lokalnym serwerze JSON (json-server).

## 📋 Wymagania

- Flutter SDK (wersja 3.10.4 lub nowsza)
- Node.js i npm (dla backendu)
- Android Studio / Xcode (dla emulatora/urządzenia)
- Emulator Android lub fizyczne urządzenie

## 🚀 Instalacja

### Szybki start

```bash
# 1. Uruchom backend
cd backend
npm install
npm start

# 2. W nowym terminalu - uruchom aplikację
cd geo_journal
flutter pub get
flutter run
```

### Szczegółowa instalacja

#### 1. Backend (json-server)

```bash
cd backend
npm install
npm start
```

Backend będzie dostępny pod adresem: `http://localhost:3000`

**Uwaga:** Backend musi działać podczas używania aplikacji!

#### 2. Aplikacja Flutter

```bash
cd geo_journal
flutter pub get
flutter run -d <device-id>
```

Aby zobaczyć dostępne urządzenia: `flutter devices`

## 📱 Funkcje

### ✨ Główne funkcje

- ✅ **Dodawanie wpisów** - Tworzenie nowych wpisów z tytułem i opisem
- 📍 **Pobieranie lokalizacji** - Automatyczne zapisywanie współrzędnych GPS przy tworzeniu wpisu
- ✏️ **Edycja wpisów** - Modyfikacja istniejących wpisów (ikona ołówka)
- 🗑️ **Usuwanie wpisów** - Usuwanie wpisów z potwierdzeniem (ikona kosza)
- 🗺️ **Otwieranie w Google Maps** - Kliknięcie w ikonę lokalizacji otwiera mapę z zaznaczoną lokalizacją
- 📋 **Kopiowanie do schowka** - Kopiowanie wpisów, współrzędnych lub linków do mapy (ikona kopiowania)
- 📱 **Czujniki urządzenia** - Automatyczne zapisywanie danych z akcelerometru i żyroskopu
- 🔄 **Odświeżanie listy** - Przycisk odświeżania w pasku aplikacji
- 📅 **Formatowanie dat** - Czytelne wyświetlanie dat w formacie dd.MM.yyyy HH:mm

### 🗺️ Lokalizacja

- Aplikacja prosi o uprawnienia do lokalizacji przy pierwszym użyciu
- Lokalizacja jest opcjonalna - możesz zapisać wpis bez lokalizacji
- Wpisy z lokalizacją mają niebieską ikonę pinezki 📍
- Wpisy bez lokalizacji mają szarą ikonę notatki 📝

## 🎯 Jak używać

### Dodawanie nowego wpisu

1. Kliknij przycisk **+** (FloatingActionButton) w prawym dolnym rogu
2. Wpisz **tytuł** i **opis** w odpowiednich polach
3. (Opcjonalnie) Kliknij **"Pobierz lokalizację"** aby zapisać aktualną lokalizację GPS
   - Aplikacja poprosi o uprawnienia do lokalizacji przy pierwszym użyciu
   - Po pobraniu lokalizacji zobaczysz współrzędne w zielonym polu
4. (Opcjonalnie) Włącz/wyłącz **czujniki** przełącznikiem w sekcji "Czujniki"
   - Dane z czujników są odczytywane automatycznie i wyświetlane na żywo
5. Kliknij **"Zapisz"** w prawym górnym rogu
6. Po zapisaniu automatycznie wrócisz do listy wpisów

### Edycja wpisu

1. W liście wpisów kliknij ikonę **ołówek** przy wybranym wpisie
2. Zmień tytuł lub opis
3. Kliknij **"Zapisz"**

### Usuwanie wpisu

1. W liście wpisów kliknij czerwoną ikonę **kosza** przy wybranym wpisie
2. Potwierdź usunięcie w oknie dialogowym

### Otwieranie lokalizacji w mapach

1. Kliknij niebieską ikonę **pinezki** przy wpisie z lokalizacją
2. Lub kliknij cały wpis z lokalizacją
3. Aplikacja otworzy Google Maps z zaznaczoną lokalizacją

### Kopiowanie do schowka

1. Kliknij ikonę **kopiowania** (dwie kartki) przy wpisie
2. Wybierz z menu:
   - **Kopiuj cały wpis** - kopiuje tytuł, opis, datę i lokalizację
   - **Kopiuj współrzędne** - kopiuje tylko współrzędne GPS (lat, lng)
   - **Kopiuj link do mapy** - kopiuje link do Google Maps
3. Alternatywnie: przytrzymaj wpis (długie naciśnięcie) aby otworzyć menu kopiowania

### Czujniki urządzenia

1. W ekranie dodawania wpisu sekcja **"Czujniki"** jest domyślnie włączona
2. Aplikacja automatycznie odczytuje dane z:
   - **Akcelerometru** (X, Y, Z) - przyspieszenie w m/s²
   - **Żyroskopu** (X, Y, Z) - prędkość kątowa w rad/s
3. Możesz wyłączyć czujniki przełącznikiem w sekcji
4. Dane z czujników są zapisywane razem z wpisem
5. W szczegółach wpisu możesz zobaczyć zapisane wartości czujników

## ⚙️ Konfiguracja

### Adres backendu

Domyślnie aplikacja łączy się z backendem pod adresem:
- **Emulator Android**: `http://10.0.2.2:3000`
- **Fizyczne urządzenie**: Zmień adres w `lib/services/entries_api.dart`

### Uprawnienia

Aplikacja wymaga następujących uprawnień:
- **Lokalizacja** - do pobierania współrzędnych GPS (prośba pojawia się przy pierwszym użyciu)
- **Internet** - do komunikacji z backendem

**Uwaga:** Czujniki (akcelerometr, żyroskop) nie wymagają dodatkowych uprawnień - są dostępne domyślnie.

## 🐛 Rozwiązywanie problemów

### Backend nie odpowiada

- Sprawdź czy `json-server` działa: `npm start` w folderze `backend`
- Sprawdź czy port 3000 nie jest zajęty
- W emulatorze użyj adresu `10.0.2.2:3000`

### Lokalizacja nie działa

- Sprawdź uprawnienia aplikacji w ustawieniach urządzenia
- W emulatorze ustaw lokalizację w Extended Controls (⋮) → Location
- Upewnij się, że GPS jest włączony

### Google Maps się nie otwiera

- Zainstaluj Google Maps z Google Play Store
- Lub użyj przeglądarki - aplikacja automatycznie otworzy mapy w przeglądarce jako fallback

### Aplikacja się wywala

- Upewnij się, że backend działa
- Sprawdź logi: `flutter run` w terminalu
- Zrestartuj aplikację: zatrzymaj i uruchom ponownie
- Wykonaj `flutter clean` i `flutter pub get` jeśli problemy z zależnościami

### Czujniki nie działają

- Niektóre emulatory mogą nie mieć wsparcia dla czujników
- Przetestuj na fizycznym urządzeniu
- Sprawdź czy urządzenie ma akcelerometr i żyroskop

## 📁 Struktura projektu

```
geo_journal/
├── lib/
│   ├── main.dart                      # Punkt wejścia aplikacji
│   ├── models/
│   │   └── entry.dart                # Model wpisu (id, title, description, lat, lng, czujniki)
│   ├── screens/
│   │   ├── entries_list_screen.dart   # Lista wpisów z ikonami i akcjami
│   │   ├── add_entry_screen.dart      # Dodawanie wpisu (lokalizacja + czujniki)
│   │   └── edit_entry_screen.dart     # Edycja wpisu
│   ├── services/
│   │   ├── entries_api.dart          # API do komunikacji z backendem (GET, POST, PUT, DELETE)
│   │   ├── location_service.dart     # Serwis lokalizacji GPS
│   │   └── sensor_service.dart       # Serwis czujników (akcelerometr, żyroskop)
│   └── widgets/                       # Komponenty UI (loading, error, empty states)
└── android/                           # Konfiguracja Android (AndroidManifest.xml)

backend/
├── db.json                            # Baza danych JSON (wpisy)
└── package.json                       # Konfiguracja Node.js (json-server)
```

## 🔧 Technologie

- **Flutter** - Framework mobilny
- **Dart** - Język programowania
- **json-server** - Backend REST API
- **geolocator** - Pobieranie lokalizacji GPS
- **url_launcher** - Otwieranie zewnętrznych aplikacji (Google Maps)
- **sensors_plus** - Odczyt danych z czujników urządzenia (akcelerometr, żyroskop)
- **http** - Komunikacja HTTP z API

## 📝 Format danych

### Backend (db.json)

Wpisy są przechowywane w formacie JSON:

```json
{
  "entries": [
    {
      "id": "ba83",
      "title": "Tytuł wpisu",
      "description": "Opis wpisu",
      "createdAt": "2026-01-07T18:44:33.113942",
      "lat": "37.4219983",
      "lng": "-122.084",
      "accelX": "0.123",
      "accelY": "-0.456",
      "accelZ": "9.789",
      "gyroX": "0.001",
      "gyroY": "-0.002",
      "gyroZ": "0.003"
    }
  ]
}
```

### Pola opcjonalne

- `lat`, `lng` - Współrzędne GPS (string z przecinkiem lub kropką)
- `accelX`, `accelY`, `accelZ` - Dane z akcelerometru (m/s²)
- `gyroX`, `gyroY`, `gyroZ` - Dane z żyroskopu (rad/s)

**Uwaga:** Wszystkie pola numeryczne są zapisywane jako stringi w backendzie (json-server).

## 🎨 Ikony i oznaczenia

- 📍 **Niebieska pinezka** - Wpis ma zapisaną lokalizację (klikalna - otwiera mapy)
- 📝 **Szara notatka** - Wpis bez lokalizacji
- ✏️ **Ołówek** - Edycja wpisu
- 🗑️ **Czerwony kosz** - Usuwanie wpisu
- 📋 **Dwie kartki** - Kopiowanie do schowka
- ➕ **Plus** - Dodawanie nowego wpisu
- 🔄 **Strzałka w kółko** - Odświeżanie listy

## 📞 Wsparcie

W razie problemów:
1. Sprawdź logi aplikacji w terminalu (`flutter run`)
2. Sprawdź czy backend działa poprawnie (`npm start` w folderze `backend`)
3. Sprawdź uprawnienia aplikacji w ustawieniach urządzenia
4. Upewnij się, że wszystkie zależności są zainstalowane (`flutter pub get`)
5. Sprawdź czy port 3000 nie jest zajęty przez inną aplikację

## 💡 Przykłady użycia

### Przykład 1: Wpis z lokalizacją

1. Kliknij **+** → Wpisz tytuł i opis
2. Kliknij **"Pobierz lokalizację"**
3. Kliknij **"Zapisz"**
4. Wpis pojawi się w liście z niebieską ikoną pinezki
5. Kliknij ikonę pinezki → Otworzy się Google Maps

### Przykład 2: Wpis z czujnikami

1. Kliknij **+** → Wpisz tytuł i opis
2. Upewnij się, że czujniki są włączone (przełącznik ON)
3. Potrząśnij urządzeniem - zobaczysz zmiany w wartościach czujników
4. Kliknij **"Zapisz"**
5. Dane z czujników zostaną zapisane razem z wpisem

### Przykład 3: Kopiowanie współrzędnych

1. Znajdź wpis z lokalizacją (niebieska pinezka)
2. Kliknij ikonę **kopiowania** (dwie kartki)
3. Wybierz **"Kopiuj współrzędne"**
4. Współrzędne są w schowku - możesz je wkleić gdziekolwiek

## 📄 Licencja

Projekt edukacyjny - użyj zgodnie z potrzebami.

---

**Miłego użytkowania! 🎉**

