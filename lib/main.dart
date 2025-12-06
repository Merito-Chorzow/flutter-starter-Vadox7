import 'package:flutter/material.dart';

import 'screens/entries_list_screen.dart';
import 'screens/add_entry_screen.dart';
import 'screens/entry_details_screen.dart';

void main() {
  runApp(const GeoJournalApp());
}

class GeoJournalApp extends StatelessWidget {
  const GeoJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: EntriesListScreen.routeName,
      routes: {
        EntriesListScreen.routeName: (ctx) => const EntriesListScreen(),
        AddEntryScreen.routeName: (ctx) => const AddEntryScreen(),
        EntryDetailsScreen.routeName: (ctx) => const EntryDetailsScreen(),
      },
    );
  }
}
