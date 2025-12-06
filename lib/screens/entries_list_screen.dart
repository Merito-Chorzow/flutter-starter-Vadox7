import 'package:flutter/material.dart';

import '../models/journal_entry.dart';
import 'add_entry_screen.dart';
import 'entry_details_screen.dart';

class EntriesListScreen extends StatefulWidget {
  const EntriesListScreen({super.key});

  static const routeName = '/';

  @override
  State<EntriesListScreen> createState() => _EntriesListScreenState();
}

class _EntriesListScreenState extends State<EntriesListScreen> {
  final List<JournalEntry> _entries = [];

  void _openAddEntry() async {
    final newEntry = await Navigator.of(context).pushNamed<JournalEntry>(
      AddEntryScreen.routeName,
    );

    if (newEntry != null) {
      setState(() => _entries.add(newEntry));
    }
  }

  void _openDetails(JournalEntry entry) {
    Navigator.of(context).pushNamed(
      EntryDetailsScreen.routeName,
      arguments: entry,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geo Journal'),
      ),
      body: _entries.isEmpty
          ? const Center(
              child: Text(
                'Brak wpisów.\nDodaj pierwszy za pomocą przycisku +',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (ctx, i) {
                final e = _entries[i];
                return ListTile(
                  title: Text(e.title),
                  subtitle: Text(
                    'Data: ${e.createdAt.toLocal().toString().substring(0, 16)}',
                  ),
                  onTap: () => _openDetails(e),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddEntry,
        child: const Icon(Icons.add),
      ),
    );
  }
}
