import 'package:flutter/material.dart';

class AddEntryScreen extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodaj Wpis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Tytuł'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Opis'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logika pobierania lokalizacji lub zdjęcia
                // Można dodać funkcje natywne do tego przycisku
              },
              child: Text('Pobierz Lokalizację lub Zrób Zdjęcie'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logika zapisywania wpisu
              },
              child: Text('Zapisz Wpis'),
            ),
          ],
        ),
      ),
    );
  }
}
