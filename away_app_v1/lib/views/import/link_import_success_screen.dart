// ABOUT: Page to confirm import, shows parsed info of video: caption and locatino
// link to imported saved page and link to map view
import 'package:flutter/material.dart';
import '/views/map/map_screen.dart';
import 'package:away_app_v1/services/api_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final caption = args['caption'] as String;
    final locations = args['locations'] as List;

    return Scaffold(
      appBar: AppBar(title: Text("🎈Import Success")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("💬 Caption:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(caption),
            SizedBox(height: 20),
            Text(
              "📍 Locations:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children:
                    locations.map((loc) {
                      final lat = loc['lat'], lng = loc['lng'];
                      return ListTile(
                        title: Text(loc['name']),
                        subtitle: Text(loc['address']),
                        trailing: Text("[$lat, $lng]"),
                      );
                    }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed:
                  () => Navigator.pushNamed(
                    context,
                    '/map',
                    arguments: locations,
                  ),
              child: Text("View on Map"),
            ),
          ],
        ),
      ),
    );
  }
}
