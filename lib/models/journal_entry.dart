// lib/models/journal_entry.dart
class JournalEntry {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  JournalEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });
}
