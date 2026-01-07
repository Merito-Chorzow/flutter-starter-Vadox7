class Entry {
  final String id;
  final String title;
  final String description;
  final String createdAt;
  final double? lat;
  final double? lng;
  final double? accelX;
  final double? accelY;
  final double? accelZ;
  final double? gyroX;
  final double? gyroY;
  final double? gyroZ;

  Entry({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.lat,
    this.lng,
    this.accelX,
    this.accelY,
    this.accelZ,
    this.gyroX,
    this.gyroY,
    this.gyroZ,
  });

  factory Entry.fromJson(Map<String, dynamic> json) {
    // Bezpieczne parsowanie String - obsługuje null, String, int, double
    // NIGDY nie rzutujemy na int - zawsze konwertujemy do String
    String parseString(dynamic value, String defaultValue) {
      if (value == null) return defaultValue;
      if (value is String) return value;
      if (value is int) return value.toString();
      if (value is double) return value.toString();
      // Fallback - zawsze String
      return value.toString();
    }

    // Bezpieczne parsowanie opcjonalnego double dla lat/lng
    // Obsługuje String z przecinkami (zamienia na kropki) oraz int/double
    double? parseOptionalDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        if (value.isEmpty) return null;
        // Normalizuj przecinki do kropek dla lat/lng
        final normalized = value.replaceAll(',', '.');
        return double.tryParse(normalized);
      }
      return null;
    }

    // Bezpieczne wyciąganie id - NIGDY nie rzutujemy na int
    final idValue = json['id'];
    final parsedId = parseString(idValue, '');

    return Entry(
      id: parsedId, // Zawsze String, nigdy int
      title: parseString(json['title'], ''),
      description: parseString(json['description'], ''),
      createdAt: parseString(json['createdAt'], ''),
      lat: parseOptionalDouble(json['lat']),
      lng: parseOptionalDouble(json['lng']),
      accelX: parseOptionalDouble(json['accelX']),
      accelY: parseOptionalDouble(json['accelY']),
      accelZ: parseOptionalDouble(json['accelZ']),
      gyroX: parseOptionalDouble(json['gyroX']),
      gyroY: parseOptionalDouble(json['gyroY']),
      gyroZ: parseOptionalDouble(json['gyroZ']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (accelX != null) 'accelX': accelX,
      if (accelY != null) 'accelY': accelY,
      if (accelZ != null) 'accelZ': accelZ,
      if (gyroX != null) 'gyroX': gyroX,
      if (gyroY != null) 'gyroY': gyroY,
      if (gyroZ != null) 'gyroZ': gyroZ,
    };
  }
}
