import 'package:latlong2/latlong.dart';
import 'instruction_model.dart';

class RouteModel {
  final List<LatLng> polylinePoints;
  final double distance; // in meters
  final List<InstructionModel> instructions;

  RouteModel({
    required this.polylinePoints,
    required this.distance,
    required this.instructions,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    // The API returns a list of paths, we'll take the first one.
    final path = json['paths'][0];
    final pointsData = path['points']['coordinates'] as List;
    final instructionsData = path['instructions'] as List;

    final List<LatLng> points = pointsData.map((pointJson) {
      // API is [lon, lat]
      return LatLng(pointJson[1], pointJson[0]);
    }).toList();

    final List<InstructionModel> instructions = instructionsData.map((
      instructionJson,
    ) {
      return InstructionModel.fromJson(instructionJson);
    }).toList();

    return RouteModel(
      polylinePoints: points,
      distance: (path['distance'] as num).toDouble(),
      instructions: instructions,
    );
  }
}
