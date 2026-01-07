import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../services/api_service.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_state_widget.dart';

class EntryDetailScreen extends StatefulWidget {
  final String entryId;

  const EntryDetailScreen({super.key, required this.entryId});

  @override
  State<EntryDetailScreen> createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends State<EntryDetailScreen> {
  final ApiService _apiService = ApiService();
  Entry? _entry;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEntry();
  }

  Future<void> _loadEntry() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final entry = await _apiService.getEntry(widget.entryId);
      setState(() {
        _entry = entry;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Szczegóły Wpisu'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget();
    }

    if (_error != null) {
      return ErrorStateWidget(
        error: _error!,
        onRetry: _loadEntry,
      );
    }

    if (_entry == null) {
      return const Center(
        child: Text('Wpis nie został znaleziony'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _entry!.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Opis',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _entry!.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Utworzono: ${_entry!.createdAt}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  if (_entry!.lat != null && _entry!.lng != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 20, color: Colors.blue[600]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Szerokość: ${_entry!.lat}',
                            style: TextStyle(color: Colors.blue[600]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 20, color: Colors.blue[600]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Długość: ${_entry!.lng}',
                            style: TextStyle(color: Colors.blue[600]),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_off, size: 20, color: Colors.grey[400]),
                        const SizedBox(width: 8),
                        Text(
                          'Brak lokalizacji',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ],
                  // Sekcja czujników
                  if (_entry!.accelX != null || _entry!.gyroX != null) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      'Czujniki',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    if (_entry!.accelX != null || _entry!.accelY != null || _entry!.accelZ != null) ...[
                      Text(
                        'Akcelerometr:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (_entry!.accelX != null)
                        Text('  X: ${_entry!.accelX!.toStringAsFixed(3)} m/s²'),
                      if (_entry!.accelY != null)
                        Text('  Y: ${_entry!.accelY!.toStringAsFixed(3)} m/s²'),
                      if (_entry!.accelZ != null)
                        Text('  Z: ${_entry!.accelZ!.toStringAsFixed(3)} m/s²'),
                      const SizedBox(height: 8),
                    ],
                    if (_entry!.gyroX != null || _entry!.gyroY != null || _entry!.gyroZ != null) ...[
                      Text(
                        'Żyroskop:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (_entry!.gyroX != null)
                        Text('  X: ${_entry!.gyroX!.toStringAsFixed(3)} rad/s'),
                      if (_entry!.gyroY != null)
                        Text('  Y: ${_entry!.gyroY!.toStringAsFixed(3)} rad/s'),
                      if (_entry!.gyroZ != null)
                        Text('  Z: ${_entry!.gyroZ!.toStringAsFixed(3)} rad/s'),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

