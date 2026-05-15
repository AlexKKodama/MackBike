import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import '../models/route_model.dart';

class RoutingService {
  final http.Client _client;

  RoutingService({http.Client? client}) : _client = client ?? http.Client();

  static const String _routingApiBaseUrl = 'http://10.0.2.2:8081/route';

  Future<RouteModel> getRoute(LatLng origin, LatLng destination) async {
    final uri = Uri.parse(
      '$_routingApiBaseUrl?from=${origin.latitude},${origin.longitude}&to=${destination.latitude},${destination.longitude}',
    );

    try {
      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return RouteModel.fromJson(data);
      } else {
        throw Exception(
          'Failed to load route: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching route: $e');
    }
  }
}
