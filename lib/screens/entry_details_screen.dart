import 'package:flutter/material.dart';

import '../models/journal_entry.dart';

class EntryDetailsScreen extends StatelessWidget {
  const EntryDetailsScreen({super.key});

  static const routeName = '/entry-details';

  @override
  Widget build(BuildContext context) {
    final entry =
        ModalRoute.of(context)!.settings.arguments as JournalEntry;

    return Scaffold(
      appBar: AppBar(
        title: Text(entry.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              entry.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Data: ${entry.createdAt.toLocal().toString().substring(0, 16)}',
            ),
          ],
        ),
      ),
    );
  }
}
