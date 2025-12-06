import 'package:flutter/material.dart';
import 'entries_list_screen.dart';
import 'entry_details_screen.dart';
import 'add_entry_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Geo Journal',
      initialRoute: '/',
      routes: {
        '/': (context) => EntriesListScreen(),
        '/entryDetails': (context) => EntryDetailsScreen(entryId: ModalRoute.of(context)!.settings.arguments as int),
        '/addEntry': (context) => AddEntryScreen(),
      },
    );
  }
}
