import 'package:flutter/material.dart';

class EntriesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista Wpisów'),
      ),
      body: ListView.builder(
        itemCount: 10, // Zmień na dynamiczną liczbę po połączeniu z API
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Wpis $index'), // Tytuł wpisu
            subtitle: Text('Data: 2025-12-06'), // Data wpisu
            trailing: Icon(Icons.location_on), // Ikona lokalizacji
            onTap: () {
              // Nawigacja do szczegółów wpisu
              Navigator.pushNamed(context, '/entryDetails', arguments: index);
            },
          );
        },
      ),
    );
  }
}
