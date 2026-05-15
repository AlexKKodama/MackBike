import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mackbike/features/navigation/widgets/map_widget.dart';
import 'package:flutter_mackbike/features/navigation/widgets/search_overlay.dart'; // Import SearchOverlay
import 'package:flutter_mackbike/features/navigation/view_models/navigation_view_model.dart';
import 'package:latlong2/latlong.dart'; // Import LatLng
import 'package:flutter_map/flutter_map.dart'; // Import MapController
import 'package:flutter_mackbike/features/navigation/widgets/route_confirmation_panel.dart'; // Import RouteConfirmationPanel

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // Set the map controller in the view model once it's available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NavigationViewModel>(
        context,
        listen: false,
      ).setMapController(_mapController);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NavigationViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('MackBike')),
      body: Stack(
        children: [
          MapWidget(
            mapController: _mapController,
            initialCenter:
                viewModel.currentLocation ??
                const LatLng(-23.5489, -46.6388), // Default to São Paulo
          ),
          const SearchOverlay(), // Add SearchOverlay here
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () => viewModel.fetchCurrentLocation(),
              child: const Icon(Icons.my_location),
            ),
          ),
          if (viewModel.navigationState == NavigationState.preview)
            const RouteConfirmationPanel(),
        ],
      ),
    );
  }
}
