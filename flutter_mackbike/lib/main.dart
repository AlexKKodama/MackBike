import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MackBike',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const OSMMapPage(),
    );
  }
}

class OSMMapPage extends StatelessWidget {
  const OSMMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MackBike')),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(-23.5489, -46.6388),
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.mackbike.app',
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                '© OpenStreetMap contributors',
                onTap: () {
                  // Opens OSM in a browser if tapped
                  debugPrint('Attribution tapped');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
