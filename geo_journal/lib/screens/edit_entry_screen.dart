import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../services/entries_api.dart';

class EditEntryScreen extends StatefulWidget {
  final Entry entry;

  const EditEntryScreen({super.key, required this.entry});

  @override
  State<EditEntryScreen> createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
  final _api = EntriesApi();
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl.text = widget.entry.title;
    _descriptionCtrl.text = widget.entry.description;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
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
      await _api.updateEntry(
        id: widget.entry.id,
        title: title,
        description: description,
      );
      if (!mounted) return;
      Navigator.pop(context, true); // true = zaktualizowano wpis
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
        title: const Text('Edytuj wpis'),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _descriptionCtrl,
                decoration: const InputDecoration(labelText: 'Opis'),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

