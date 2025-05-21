// ABOUT: Page prompt to paste video link to parse
import 'package:flutter/material.dart';
import '../import/link_import_success_screen.dart';
import 'package:away_app_v1/services/api_service.dart';

class ImportLinkScreen extends StatefulWidget {
  const ImportLinkScreen({super.key});

  @override
  State<ImportLinkScreen> createState() => _ImportLinkScreenState();
}

class _ImportLinkScreenState extends State<ImportLinkScreen> {
  final TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  Future<void> _handleImport() async {
    final url = _urlController.text.trim();

    if (url.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final result = await _apiService.parseInstagramUrl(url);
      final caption = result['caption'] as String;
      final locList = result['locations'] as List<dynamic>;
      final locations = {
        for (var loc in locList)
          loc['name'] as String: {
            'address': loc['address'],
            'latitude': loc['lat'],
            'longitude': loc['lng'],
          },
      };
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) =>
                  ImportSuccessScreen(caption: caption, locations: locations),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Import failed: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Import Video")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Paste your Instagram link:"),
            const SizedBox(height: 10),
            TextField(
              controller: _urlController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "https://www.instagram.com/...",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleImport,
              child:
                  _isLoading
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Text("Import"),
            ),
          ],
        ),
      ),
    );
  }
}
