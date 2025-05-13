// ABOUT: Page prompt to paste video link to parse
import 'package:flutter/material.dart';
import 'link_import_success_screen.dart';

class ImportLinkScreen extends StatefulWidget {
  const ImportLinkScreen({super.key});

  @override
  State<ImportLinkScreen> createState() => _ImportLinkScreenState();
}

class _ImportLinkScreenState extends State<ImportLinkScreen> {
  final TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleImport() async {
    final url = _urlController.text.trim();

    if (url.isEmpty) return;

    setState(() => _isLoading = false);

    //TODO: Replace with API call here
    await Future.delayed(const Duration(seconds: 2));

    final String fakeCaption = "Exploring Island... ";
    final Map<String, Map<String, dynamic>> fakeLocations = {
      "mentawai islands": {
        "address": "Mentawai Islands Regency, Indonesia",
        "latitude": -2.133,
        "longitude": 99.733,
      },
    };

    setState(() => _isLoading = true);

    final caption = "Exploring Island...";
    final locations = {
      "mentawai islands": {
        "address": "Mentawai Islands Regency, Indonesia",
        "latitude": -2.133,
        "longitude": 99.733,
      },
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ImportSuccessScreen(caption: caption, locations: locations),
      ),
    );
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
                      ? const CircularProgressIndicator()
                      : const Text("Import"),
            ),
          ],
        ),
      ),
    );
  }
}
