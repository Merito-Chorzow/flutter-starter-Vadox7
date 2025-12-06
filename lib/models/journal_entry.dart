import 'package:uuid/uuid.dart';

class JournalEntry {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  JournalEntry({
    String? id,
    required this.title,
    required this.description,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();
}
