import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/entry.dart';

class EntriesApi {
  // Android Emulator: 10.0.2.2
  // Windows/Desktop/Web: localhost
  static const String baseUrl = 'http://10.0.2.2:3000';

  Future<List<Entry>> fetchEntries() async {
    final uri = Uri.parse('$baseUrl/entries');
    final res = await http.get(uri);

    if (res.statusCode != 200) {
      throw Exception('GET /entries failed: ${res.statusCode}');
    }

    final data = jsonDecode(res.body) as List<dynamic>;
    return data.map((e) => Entry.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Entry> createEntry({
    required String title,
    required String description,
    double? lat,
    double? lng,
    double? accelX,
    double? accelY,
    double? accelZ,
    double? gyroX,
    double? gyroY,
    double? gyroZ,
  }) async {
    final uri = Uri.parse('$baseUrl/entries');

    final body = <String, dynamic>{
      'title': title,
      'description': description,
      'createdAt': DateTime.now().toIso8601String(),
    };

    // Dodaj lokalizację jeśli jest dostępna
    if (lat != null && lng != null) {
      body['lat'] = lat.toString();
      body['lng'] = lng.toString();
    }

    // Dodaj dane z czujników jeśli są dostępne
    if (accelX != null) body['accelX'] = accelX.toString();
    if (accelY != null) body['accelY'] = accelY.toString();
    if (accelZ != null) body['accelZ'] = accelZ.toString();
    if (gyroX != null) body['gyroX'] = gyroX.toString();
    if (gyroY != null) body['gyroY'] = gyroY.toString();
    if (gyroZ != null) body['gyroZ'] = gyroZ.toString();

    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode != 201) {
      throw Exception('POST /entries failed: ${res.statusCode}');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return Entry.fromJson(data);
  }

  Future<Entry> updateEntry({
    required String id,
    required String title,
    required String description,
  }) async {
    final uri = Uri.parse('$baseUrl/entries/$id');

    final res = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception('PUT /entries/$id failed: ${res.statusCode}');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return Entry.fromJson(data);
  }

  Future<void> deleteEntry(String id) async {
    final uri = Uri.parse('$baseUrl/entries/$id');

    final res = await http.delete(uri);

    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('DELETE /entries/$id failed: ${res.statusCode}');
    }
  }
}

