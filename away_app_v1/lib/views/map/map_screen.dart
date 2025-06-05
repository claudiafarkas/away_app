import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

// --------------------------------MAP SETTINGS-------------------------------
class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);
  final String _mapStyle = '''
      [
    {
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#f5f5f5"
        }
      ]
    },
    {
      "elementType": "labels.icon",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#616161"
        }
      ]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#f5f5f5"
        }
      ]
    },
    {
      "featureType": "administrative.land_parcel",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#bdbdbd"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#eeeeee"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#757575"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#e5e5e5"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#9e9e9e"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#ffffff"
        }
      ]
    },
    {
      "featureType": "road.arterial",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#757575"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#dadada"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#616161"
        }
      ]
    },
    {
      "featureType": "road.local",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#9e9e9e"
        }
      ]
    },
    {
      "featureType": "transit.line",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#e5e5e5"
        }
      ]
    },
    {
      "featureType": "transit.station",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#eeeeee"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#c9c9c9"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#9e9e9e"
        }
      ]
    }
  ]
      ''';
  // ---------------------------------------------------------------------------

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // ----------------------------MAP FUNCTIONALITY------------------------------
  @override
  Widget build(BuildContext context) {
    final raw = ModalRoute.of(context)!.settings.arguments;
    final locs =
        (raw is List)
            ? raw.cast<Map<String, dynamic>>()
            : <Map<String, dynamic>>[];
    debugPrint("Locations received: $locs");

    final tempList =
        locs.map((l) {
          final name = l['name'] as String? ?? 'Unknown';
          final latValue = l['lat'];
          final lngValue = l['lng'];
          double lat = 0.0;
          double lng = 0.0;
          try {
            lat =
                (latValue is double ? latValue : (latValue as num).toDouble());
            lng =
                (lngValue is double ? lngValue : (lngValue as num).toDouble());
          } catch (_) {
            debugPrint("Skipping marker with non-numeric coordinates: $name");
            return null;
          }
          final address = l['address'] as String? ?? 'No address available';

          debugPrint("Creating marker: $name at ($lat, $lng)");
          if (lat == 0.0 && lng == 0.0) {
            debugPrint("Skipping marker with invalid coordinates: $name");
            return null;
          }
          return Marker(
            markerId: MarkerId(name),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: name, snippet: address),
          );
        }).toList();
    // Filter out any nulls and convert to a Set<Marker>
    final markers = tempList.where((m) => m != null).cast<Marker>().toSet();

    if (markers.isEmpty) {
      print('No markers available. Using default center.');
    }

    final center = markers.isNotEmpty ? markers.first.position : _center;

    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: center,
          zoom: markers.isNotEmpty ? 12 : 2,
        ),
        markers: markers,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        style: _mapStyle,
      ),
    );
  }
}
