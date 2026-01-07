import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../models/entry.dart';
import '../services/entries_api.dart';
import 'add_entry_screen.dart';
import 'edit_entry_screen.dart';

class EntriesListScreen extends StatefulWidget {
  const EntriesListScreen({super.key});

  @override
  State<EntriesListScreen> createState() => _EntriesListScreenState();
}

class _EntriesListScreenState extends State<EntriesListScreen> {
  final _api = EntriesApi();
  late Future<List<Entry>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchEntries();
  }

  void _refresh() {
    setState(() {
      _future = _api.fetchEntries();
    });
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd.MM.yyyy HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _openInGoogleMaps(double lat, double lng) async {
    try {
      // Najpierw spróbuj geo: URI (działa najlepiej na Androidzie z Google Maps)
      try {
        final geoUrl = Uri.parse('geo:$lat,$lng?q=$lat,$lng');
        await launchUrl(geoUrl, mode: LaunchMode.externalApplication);
        return;
      } catch (_) {
        // Jeśli geo: nie działa, spróbuj web URL
      }
      
      // Fallback: Google Maps web URL - zawsze otworzy się w przeglądarce
      final webUrl = Uri.parse('https://www.google.com/maps?q=$lat,$lng');
      await launchUrl(webUrl, mode: LaunchMode.platformDefault);
      
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Błąd otwierania mapy: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _copyToClipboard(String text, String message) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showCopyMenu(Entry entry) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.content_copy),
              title: const Text('Kopiuj cały wpis'),
              onTap: () {
                final text = '${entry.title}\n\n${entry.description}\n\nData: ${_formatDate(entry.createdAt)}${entry.lat != null && entry.lng != null ? '\nLokalizacja: ${entry.lat}, ${entry.lng}' : ''}';
                _copyToClipboard(text, 'Wpis skopiowany do schowka');
                Navigator.pop(context);
              },
            ),
            if (entry.lat != null && entry.lng != null)
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Kopiuj współrzędne'),
                onTap: () {
                  _copyToClipboard('${entry.lat}, ${entry.lng}', 'Współrzędne skopiowane do schowka');
                  Navigator.pop(context);
                },
              ),
            if (entry.lat != null && entry.lng != null)
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('Kopiuj link do mapy'),
                onTap: () {
                  _copyToClipboard('https://www.google.com/maps?q=${entry.lat},${entry.lng}', 'Link do mapy skopiowany');
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteEntry(Entry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Usuń wpis'),
        content: Text('Czy na pewno chcesz usunąć wpis "${entry.title.isEmpty ? '(bez tytułu)' : entry.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Anuluj'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Usuń'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _api.deleteEntry(entry.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wpis został usunięty'),
          backgroundColor: Colors.green,
        ),
      );
      _refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Błąd usuwania: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geo Journal'),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder<List<Entry>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Błąd: ${snapshot.error}'),
              ),
            );
          }

          final entries = snapshot.data ?? [];

          if (entries.isEmpty) {
            return const Center(child: Text('Brak wpisów. Dodamy pierwszy 🙂'));
          }

          return ListView.separated(
            itemCount: entries.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final e = entries[i];
              final hasLocation = e.lat != null && e.lng != null;
              
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: GestureDetector(
                  onTap: hasLocation
                      ? () => _openInGoogleMaps(e.lat!, e.lng!)
                      : null,
                  child: Icon(
                    hasLocation ? Icons.location_on : Icons.notes,
                    color: hasLocation ? Colors.blue : Colors.grey,
                    size: 28,
                  ),
                ),
                title: Text(
                  e.title.isEmpty ? '(bez tytułu)' : e.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      e.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(e.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Kopiuj',
                      onPressed: () => _showCopyMenu(e),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Edytuj',
                      onPressed: () async {
                        final updated = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditEntryScreen(entry: e),
                          ),
                        );
                        if (updated == true) {
                          _refresh();
                        }
                      },
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      color: Colors.red,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Usuń',
                      onPressed: () => _deleteEntry(e),
                    ),
                  ],
                ),
                onLongPress: () => _showCopyMenu(e),
                onTap: hasLocation
                    ? () => _openInGoogleMaps(e.lat!, e.lng!)
                    : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const AddEntryScreen()),
          );

          if (added == true) {
            _refresh();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
