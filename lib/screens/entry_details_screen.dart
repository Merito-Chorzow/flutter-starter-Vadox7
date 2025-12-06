import 'package:flutter/material.dart';

class EntryDetailsScreen extends StatelessWidget {
  final int entryId;

  // Odbieramy argumenty z nawigacji
  EntryDetailsScreen({Key? key, required this.entryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Szczegóły Wpisu $entryId'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tytuł: Wpis $entryId', style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 8),
            Text('Opis: To jest opis wpisu. Tu będzie miejsce na szczegóły.', style: Theme.of(context).textTheme.bodyText1),
            SizedBox(height: 16),
            Text('Lokalizacja: Tu będzie lokalizacja.', style: Theme.of(context).textTheme.bodyText2),
            SizedBox(height: 16),
            // Przykład zdjęcia
            Image.asset('assets/sample_image.jpg'),
            // Dodaj inne dane związane z wpisem
          ],
        ),
      ),
    );
  }
}
