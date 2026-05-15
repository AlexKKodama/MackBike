import 'package:flutter/material.dart';
import 'package:flutter_mackbike/features/navigation/models/route_model.dart';
import 'package:flutter_mackbike/features/navigation/widgets/map_widget.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Import LatLng
import 'package:flutter_mackbike/features/navigation/widgets/current_instruction_card.dart';

import 'package:provider/provider.dart';
import 'package:flutter_mackbike/features/navigation/view_models/navigation_view_model.dart';

class TurnByTurnScreen extends StatefulWidget {
  final RouteModel route;

  const TurnByTurnScreen({super.key, required this.route});

  @override
  State<TurnByTurnScreen> createState() => _TurnByTurnScreenState();
}

class _TurnByTurnScreenState extends State<TurnByTurnScreen> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NavigationViewModel>(context, listen: false).startNavigation();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = Provider.of<NavigationViewModel>(context, listen: false);
    viewModel.addListener(_onViewModelChange);
  }

  @override
  void dispose() {
    Provider.of<NavigationViewModel>(context, listen: false).removeListener(_onViewModelChange);
    super.dispose();
  }

  void _onViewModelChange() {
    final viewModel = Provider.of<NavigationViewModel>(context, listen: false);
    if (viewModel.currentGpsPosition != null) {
      _mapController.move(
        LatLng(
          viewModel.currentGpsPosition!.latitude,
          viewModel.currentGpsPosition!.longitude,
        ),
        _mapController.camera.zoom,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NavigationViewModel>(context);

    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            mapController: _mapController,
            initialCenter: viewModel.currentGpsPosition != null
                ? LatLng(viewModel.currentGpsPosition!.latitude,
                    viewModel.currentGpsPosition!.longitude)
                : widget.route.polylinePoints.first,
          ),
          if (viewModel.currentRoute != null &&
              viewModel.currentInstructionIndex <
                  viewModel.currentRoute!.instructions.length)
            CurrentInstructionCard(
              instruction: viewModel
                  .currentRoute!.instructions[viewModel.currentInstructionIndex],
            ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                viewModel.stopNavigation();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Cancelar Navegação',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
