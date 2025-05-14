// ABOUT: Page to confirm import, shows parsed info of video: caption and locatino
// link to imported saved page and link to map view
import 'package:flutter/material.dart';

class ImportSuccessScreen extends StatelessWidget {
  final String caption;
  final Map<String, Map<String, dynamic>> locations;

  const ImportSuccessScreen({
    super.key,
    required this.caption,
    required this.locations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Import Success')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📀 Video Imported!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            const Text(
              '💬 Caption:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(caption.isNotEmpty ? caption : 'No caption provided'),
            const SizedBox(height: 20),

            const Text(
              '📍 Locations Found:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...locations.entries.map((entry) {
              final locName = entry.key;
              final data = entry.value;
              return ListTile(
                title: Text(locName),
                subtitle: Text(data['address'] ?? 'No address available'),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Lat: ${data['latitude'] ?? '–'}'),
                    Text('Lng: ${data['longitude'] ?? '–'}'),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 20),
            const Text(
              '🎞 Video:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Placeholder(fallbackHeight: 150),

            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed:
                      () =>
                          Navigator.pushNamed(context, '/imported_tab_screen'),
                  child: const Text("Check Out Imported Videos!"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/map_screen'),
                  child: const Text("View on Map!"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
