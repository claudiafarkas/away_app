// ABOUT: Page to confirm import, shows parsed info of video: caption and locatino
// link to imported saved page and link to map view
import 'package:flutter/material.dart';
import 'package:away_app_v1/services/import_service.dart';
import 'package:away_app_v1/views/map/map_screen.dart';

class ImportSuccessScreen extends StatefulWidget {
  final String caption;
  final List<Map<String, dynamic>> locations;

  const ImportSuccessScreen({
    super.key,
    required this.caption,
    required this.locations,
  });

  @override
  State<ImportSuccessScreen> createState() => _ImportSuccessScreenState();
}

class _ImportSuccessScreenState extends State<ImportSuccessScreen> {
  // Track selected locations
  late List<bool> _selectedLocations;

  @override
  void initState() {
    super.initState();
    // Initialize selection state for each location
    _selectedLocations = List<bool>.filled(widget.locations.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("🎈Import Success")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "💬 Parsed Caption:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.caption),
              SizedBox(height: 20),
              Text(
                "📍 Select Locations to Pin:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 300, // Set a fixed height for the ListView
                child: ListView.builder(
                  itemCount: widget.locations.length,
                  itemBuilder: (context, index) {
                    final loc = widget.locations[index];
                    final lat = loc['latitude'], lng = loc['longitude'];
                    return Row(
                      children: [
                        // Checkbox on the left
                        Checkbox(
                          value: _selectedLocations[index],
                          onChanged: (bool? value) {
                            setState(() {
                              _selectedLocations[index] = value ?? false;
                            });
                          },
                        ),
                        // Location details in the middle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc['name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(loc['address']),
                            ],
                          ),
                        ),
                        // Latitude and longitude on the right
                        Text(
                          "[$lat, $lng]",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Filter selected locations into List<Map<String, dynamic>>
                  final selectedLocations =
                      widget.locations
                          .asMap()
                          .entries
                          .where((entry) => _selectedLocations[entry.key])
                          .map((entry) {
                            final loc = entry.value;
                            return {
                              'name': loc['name'] as String? ?? 'Unknown',
                              'address': loc['address'] as String? ?? '',
                              'lat':
                                  loc['latitude'] is double
                                      ? loc['latitude']
                                      : (loc['latitude'] as num).toDouble(),
                              'lng':
                                  loc['longitude'] is double
                                      ? loc['longitude']
                                      : (loc['longitude'] as num).toDouble(),
                            };
                          })
                          .toList();
                  // Add these locations to the singleton service
                  ImportService.instance.addLocations(selectedLocations);
                  // Navigate to the map screen (no arguments needed)
                  // Navigator.pushNamed(context, '/map');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MapScreen(showDoneButton: true),
                    ),
                  );
                },
                child: Text("View Selected on Map"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
