import 'package:flutter/material.dart';
import '../services/entries_api.dart';
import '../services/location_service.dart';
import '../services/sensor_service.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _api = EntriesApi();
  final _locationService = LocationService();
  final _sensorService = SensorService();
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  bool _saving = false;
  double? _lat;
  double? _lng;
  bool _loadingLocation = false;
  bool _sensorsEnabled = false;

  @override
  void initState() {
    super.initState();
    // Automatycznie włącz czujniki przy otwarciu ekranu
    _sensorService.startListening();
    _sensorsEnabled = true;
  }

  @override
  void dispose() {
    _sensorService.dispose();
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    setState(() => _loadingLocation = true);

    try {
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        setState(() {
          _lat = position.latitude;
          _lng = position.longitude;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lokalizacja pobrana'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        if (!mounted) return;
        final errorMsg = await _locationService.getPermissionError();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg ?? 'Nie udało się pobrać lokalizacji'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Błąd: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    final description = _descriptionCtrl.text.trim();

    if (description.isEmpty && title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wpis nie może być pusty.')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final sensorValues = _sensorService.getCurrentValues();
      await _api.createEntry(
        title: title,
        description: description,
        lat: _lat,
        lng: _lng,
        accelX: sensorValues['accelX'],
        accelY: sensorValues['accelY'],
        accelZ: sensorValues['accelZ'],
        gyroX: sensorValues['gyroX'],
        gyroY: sensorValues['gyroY'],
        gyroZ: sensorValues['gyroZ'],
      );
      if (!mounted) return;
      Navigator.pop(context, true); // true = dodano wpis
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd zapisu: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj wpis'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Zapisz'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionCtrl,
              decoration: const InputDecoration(labelText: 'Opis'),
              maxLines: 5,
              minLines: 3,
            ),
            const SizedBox(height: 16),
            // Sekcja lokalizacji
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Lokalizacja',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_lat != null && _lng != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Szerokość: ${_lat!.toStringAsFixed(6)}'),
                                  Text('Długość: ${_lng!.toStringAsFixed(6)}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      const Text(
                        'Brak lokalizacji',
                        style: TextStyle(color: Colors.grey),
                      ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _loadingLocation ? null : _getLocation,
                      icon: _loadingLocation
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.location_on),
                      label: Text(_loadingLocation
                          ? 'Pobieranie...'
                          : 'Pobierz lokalizację'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Sekcja czujników
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Czujniki',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Switch(
                          value: _sensorsEnabled,
                          onChanged: (value) {
                            setState(() {
                              _sensorsEnabled = value;
                              if (value) {
                                _sensorService.startListening();
                              } else {
                                _sensorService.stopListening();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_sensorsEnabled)
                      StreamBuilder(
                        stream: Stream.periodic(const Duration(milliseconds: 500)),
                        builder: (context, snapshot) {
                          final values = _sensorService.getCurrentValues();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSensorRow('Akcelerometr X:', values['accelX']),
                              _buildSensorRow('Akcelerometr Y:', values['accelY']),
                              _buildSensorRow('Akcelerometr Z:', values['accelZ']),
                              const SizedBox(height: 8),
                              _buildSensorRow('Żyroskop X:', values['gyroX']),
                              _buildSensorRow('Żyroskop Y:', values['gyroY']),
                              _buildSensorRow('Żyroskop Z:', values['gyroZ']),
                            ],
                          );
                        },
                      )
                    else
                      const Text(
                        'Czujniki wyłączone',
                        style: TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorRow(String label, double? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
          Text(
            value != null ? value.toStringAsFixed(3) : '---',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: value != null ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
