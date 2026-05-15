import 'package:flutter_mackbike/features/navigation/models/route_model.dart';
import 'package:flutter_mackbike/features/navigation/services/routing_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'routing_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('RoutingService', () {
    late RoutingService routingService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      routingService = RoutingService(client: mockClient);
    });

    test('getRoute returns a RouteModel on successful API call', () async {
      final origin = LatLng(52.52, 13.405);
      final destination = LatLng(52.53, 13.41);
      final url = Uri.parse(
        'http://10.0.2.2:8081/route?from=${origin.latitude},${origin.longitude}&to=${destination.latitude},${destination.longitude}',
      );

      when(mockClient.get(url)).thenAnswer(
        (_) async => http.Response('''
          {
              "paths": [
                  {
                      "distance": 1891.18,
                      "points": {
                          "type": "LineString",
                          "coordinates": [
                              [13.405, 52.52],
                              [13.41, 52.53]
                          ]
                      },
                      "instructions": [
                          {
                              "time": 33986,
                              "interval": [0, 1],
                              "sign": 0,
                              "text": "Continue na Friedrichstraße",
                              "street_name": "Friedrichstraße",
                              "distance": 187.412
                          }
                      ]
                  }
              ]
          }
          ''', 200),
      );

      final route = await routingService.getRoute(origin, destination);

      expect(route, isA<RouteModel>());
      expect(route.polylinePoints.length, 2);
      expect(route.polylinePoints[0].latitude, 52.52);
      expect(route.polylinePoints[0].longitude, 13.405);
      expect(route.distance, 1891.18);
      expect(route.instructions.length, 1);
      expect(route.instructions[0].text, 'Continue na Friedrichstraße');
    });

    test('getRoute throws an exception on failed API call', () async {
      final origin = LatLng(52.52, 13.405);
      final destination = LatLng(52.53, 13.41);
      final url = Uri.parse(
        'http://10.0.2.2:8081/route?from=${origin.latitude},${origin.longitude}&to=${destination.latitude},${destination.longitude}',
      );

      when(
        mockClient.get(url),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(routingService.getRoute(origin, destination), throwsException);
    });
  });
}
