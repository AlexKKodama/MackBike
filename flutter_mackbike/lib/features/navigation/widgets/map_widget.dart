import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mackbike/features/navigation/view_models/navigation_view_model.dart';

class MapWidget extends StatelessWidget {
  final LatLng initialCenter;
  final double initialZoom;
  final MapController? mapController;

  const MapWidget({
    super.key,
    required this.initialCenter,
    this.initialZoom = 13.0,
    this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationViewModel>(
      builder: (context, viewModel, child) {
        final List<Polyline> polylines = [];
        if (viewModel.currentRoute != null) {
          polylines.add(
            Polyline(
              points: viewModel.currentRoute!.polylinePoints,
              color: Colors.blue,
              strokeWidth: 5.0,
            ),
          );
        }

        final List<Marker> markers = [];
        if (viewModel.origin != null) {
          markers.add(
            Marker(
              point: viewModel.origin!,
              width: 80.0,
              height: 80.0,
              child: const Icon(
                Icons.location_on,
                color: Colors.green,
                size: 40.0,
              ),
            ),
          );
        }
        if (viewModel.destination != null) {
          markers.add(
            Marker(
              point: viewModel.destination!,
              width: 80.0,
              height: 80.0,
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40.0,
              ),
            ),
          );
        }

        // Add current GPS position marker if available and navigating
        if (viewModel.currentGpsPosition != null &&
            viewModel.navigationState == NavigationState.navigating) {
          markers.add(
            Marker(
              point: LatLng(
                viewModel.currentGpsPosition!.latitude,
                viewModel.currentGpsPosition!.longitude,
              ),
              width: 40.0,
              height: 40.0,
              child: const Icon(
                Icons.navigation, // Or a custom icon for current location
                color: Colors.blueAccent,
                size: 30.0,
              ),
            ),
          );
        }
        return FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: viewModel.currentLocation ?? initialCenter,
            initialZoom: initialZoom,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.mackbike',
            ),
            PolylineLayer(polylines: polylines),
            MarkerLayer(markers: markers),
          ],
        );
      },
    );
  }
}
