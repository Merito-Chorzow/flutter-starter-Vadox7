import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/entry.dart';

class ApiService {
  // API base URL for Android emulator
  static const String baseUrl = 'http://10.0.2.2:3000';

  // GET all entries
  Future<List<Entry>> getEntries() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/entries'));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body) as List<dynamic>;
        return jsonList.map((json) => Entry.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load entries: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching entries: $e');
    }
  }

  // POST new entry
  Future<Entry> createEntry(Entry entry) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/entries'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(entry.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Entry.fromJson(json.decode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception('Failed to create entry: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating entry: $e');
    }
  }

  // GET single entry by ID
  Future<Entry> getEntry(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/entries/$id'));
      
      if (response.statusCode == 200) {
        return Entry.fromJson(json.decode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load entry: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching entry: $e');
    }
  }
}

