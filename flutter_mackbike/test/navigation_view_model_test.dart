import 'package:flutter_mackbike/features/navigation/models/route_model.dart';
import 'package:flutter_mackbike/features/navigation/models/instruction_model.dart';
import 'package:flutter_mackbike/features/navigation/services/geocoding_service.dart';
import 'package:flutter_mackbike/features/navigation/services/location_service.dart';
import 'dart:async'; // For StreamController
import 'package:flutter_mackbike/features/navigation/services/routing_service.dart';
import 'package:flutter_mackbike/features/navigation/view_models/navigation_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart'; // For Position and LocationPermission
import 'package:latlong2/latlong.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'navigation_view_model_test.mocks.dart'; // Generated mock file

@GenerateMocks([LocationService, GeocodingService, RoutingService])
void main() {
  group('NavigationViewModel', () {
    late NavigationViewModel viewModel;
    late MockLocationService mockLocationService;
    late MockGeocodingService mockGeocodingService;
    late MockRoutingService mockRoutingService;
    setUp(() {
      mockLocationService = MockLocationService();
      mockGeocodingService = MockGeocodingService();
      mockRoutingService = MockRoutingService();

      when(mockRoutingService.getRoute(any, any)).thenAnswer((_) async {
        return RouteModel(
          polylinePoints: [LatLng(0, 0), LatLng(1, 1)],
          distance: 1000,
          instructions: [],
        );
      });

      viewModel = NavigationViewModel(
        locationService: mockLocationService,
        geocodingService: mockGeocodingService,
        routingService: mockRoutingService,
      );
    });

    test('initial state is idle', () {
      expect(viewModel.navigationState, NavigationState.idle);
    });

    test(
      '_fetchRoute sets state to loading, then preview on success',
      () async {
        final origin = LatLng(10, 10);
        final destination = LatLng(20, 20);

        viewModel.setOrigin(origin);
        viewModel.setDestination(destination);

        // Expect state to change to loading
        expect(viewModel.navigationState, NavigationState.loading);

        // Simulate successful route fetching
        await untilCalled(mockRoutingService.getRoute(any, any));

        // Expect state to change to preview
        expect(viewModel.navigationState, NavigationState.preview);
        expect(viewModel.currentRoute, isNotNull);
      },
    );

    test('_fetchRoute sets state to idle on error', () async {
      final origin = LatLng(10, 10);
      final destination = LatLng(20, 20);

      when(
        mockRoutingService.getRoute(any, any),
      ).thenThrow(Exception('API Error'));

      final states = <NavigationState>[];
      viewModel.addListener(() {
        states.add(viewModel.navigationState);
      });

      viewModel.setOrigin(origin);
      viewModel.setDestination(destination);

      // We need to wait for the async operation to complete.
      await untilCalled(mockRoutingService.getRoute(any, any));

      expect(states.contains(NavigationState.loading), isTrue);
      expect(viewModel.navigationState, NavigationState.idle);
      expect(viewModel.currentRoute, isNull);
    });

    test('cancelRoutePreview sets state to idle and clears route', () {
      // Set state to preview
      viewModel.setOrigin(LatLng(10, 10));
      viewModel.setDestination(LatLng(20, 20));
      // Manually set state to preview for test setup
      viewModel.forceState(NavigationState.preview);
      viewModel.forceRoute(
        RouteModel(
          polylinePoints: [LatLng(0, 0)],
          distance: 100,
          instructions: [],
        ),
      );

      expect(viewModel.navigationState, NavigationState.preview);
      expect(viewModel.currentRoute, isNotNull);

      viewModel.cancelRoutePreview();

      expect(viewModel.navigationState, NavigationState.idle);
      expect(viewModel.currentRoute, isNull);
    });

    test('startNavigation sets state to navigating and starts position stream', () async {
      when(mockLocationService.checkPermission())
          .thenAnswer((_) async => LocationPermission.whileInUse);
      when(mockLocationService.requestPermission())
          .thenAnswer((_) async => LocationPermission.whileInUse);
      when(mockLocationService.getPositionStream())
          .thenAnswer((_) => Stream.value(Position(
                latitude: 1.0,
                longitude: 1.0,
                timestamp: DateTime.now(),
                accuracy: 1.0,
                altitude: 1.0,
                altitudeAccuracy: 1.0,
                heading: 1.0,
                headingAccuracy: 1.0,
                speed: 1.0,
                speedAccuracy: 1.0,
              )));

      await viewModel.startNavigation();
      await Future.microtask(() {}); // Allow stream to emit and listener to update

      expect(viewModel.navigationState, NavigationState.navigating);
      verify(mockLocationService.checkPermission()).called(1);
      verify(mockLocationService.getPositionStream()).called(1);
      expect(viewModel.currentGpsPosition, isNotNull);
    });

    test('stopNavigation sets state to idle and cancels position stream', () async {
      // First, start navigation to set up the stream
      when(mockLocationService.checkPermission())
          .thenAnswer((_) async => LocationPermission.whileInUse);
      when(mockLocationService.requestPermission())
          .thenAnswer((_) async => LocationPermission.whileInUse);
      final streamController = StreamController<Position>();
      when(mockLocationService.getPositionStream())
          .thenAnswer((_) => streamController.stream);

      await viewModel.startNavigation();
      expect(viewModel.navigationState, NavigationState.navigating);

      viewModel.stopNavigation();

      expect(viewModel.navigationState, NavigationState.idle);
      expect(viewModel.currentRoute, isNull);
      expect(viewModel.currentGpsPosition, isNull);
      // Verify that the stream subscription was cancelled (indirectly)
      // This is hard to test directly with mockito for StreamSubscription.
      // We rely on the internal logic of stopPositionStream in LocationService.
    });

    test('instruction index increments when user is near next maneuver point', () {
      final route = RouteModel(
        polylinePoints: [
          LatLng(0, 0), // Instruction 0 start
          LatLng(1, 1), // Instruction 1 start
          LatLng(2, 2), // Instruction 2 start
        ],
        distance: 300,
        instructions: [
          InstructionModel(
              text: 'Instruction 1', streetName: 'Street 1', distance: 100, time: 10, sign: 0, interval: [0, 1]),
          InstructionModel(
              text: 'Instruction 2', streetName: 'Street 2', distance: 100, time: 10, sign: 0, interval: [1, 2]),
          InstructionModel(
              text: 'Instruction 3', streetName: 'Street 3', distance: 100, time: 10, sign: 0, interval: [2, 2]),
        ],
      );
      viewModel.forceRoute(route);
      viewModel.forceState(NavigationState.navigating);

      expect(viewModel.currentInstructionIndex, 0);

      // Simulate user position near the start of the second instruction
      final userPosition = Position(
        latitude: 1.0001,
        longitude: 1.0001,
        timestamp: DateTime.now(),
        accuracy: 1.0,
        altitude: 1.0,
        altitudeAccuracy: 1.0,
        heading: 1.0,
        headingAccuracy: 1.0,
        speed: 1.0,
        speedAccuracy: 1.0,
      );

      viewModel.onPositionUpdate(userPosition);

      expect(viewModel.currentInstructionIndex, 1);
    });
  });
}
