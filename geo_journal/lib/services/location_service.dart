import 'package:geolocator/geolocator.dart';

class LocationService {
  // Check and request location permissions
  Future<bool> checkAndRequestPermissions() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // Check location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      // Check permissions first
      bool hasPermission = await checkAndRequestPermissions();
      if (!hasPermission) {
        return null;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      return null;
    }
  }

  // Get permission status message
  Future<String?> getPermissionError() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Usługa lokalizacji jest wyłączona. Włącz GPS w ustawieniach.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return 'Brak zgody na dostęp do lokalizacji. Proszę zezwolić na dostęp w ustawieniach.';
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Dostęp do lokalizacji został trwale zablokowany. Odblokuj w ustawieniach aplikacji.';
    }

    return null;
  }
}

