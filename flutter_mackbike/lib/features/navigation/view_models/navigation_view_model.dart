import 'dart:async'; // For StreamSubscription
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // For Position and LocationPermission
import 'package:latlong2/latlong.dart';
import 'package:flutter_mackbike/features/navigation/services/location_service.dart';
import 'package:flutter_mackbike/features/navigation/services/geocoding_service.dart';
import 'package:flutter_mackbike/features/navigation/services/routing_service.dart';
import 'package:flutter_mackbike/features/navigation/models/search_result_model.dart';
import 'package:flutter_mackbike/features/navigation/models/route_model.dart';
import 'package:flutter_map/flutter_map.dart'; // Import MapController

enum NavigationState { idle, loading, preview, navigating }

class NavigationViewModel extends ChangeNotifier {
  final LocationService _locationService;
  final GeocodingService _geocodingService;
  final RoutingService _routingService;

  NavigationViewModel({
    LocationService? locationService,
    GeocodingService? geocodingService,
    RoutingService? routingService,
  }) : _locationService = locationService ?? LocationService(),
       _geocodingService = geocodingService ?? GeocodingService(),
       _routingService = routingService ?? RoutingService();

  NavigationState _navigationState = NavigationState.idle;

  LatLng? _currentLocation;
  LatLng? _origin;
  LatLng? _destination;
  MapController? _mapController;
  RouteModel? _currentRoute;
  Position? _currentGpsPosition; // New property for live GPS location
  StreamSubscription<Position>? _positionStreamSubscription; // New property for location stream
  int _currentInstructionIndex = 0; // New property for instruction index

  List<SearchResultModel> _originSearchResults = [];
  List<SearchResultModel> _destinationSearchResults = [];

  NavigationState get navigationState => _navigationState;
  int get currentInstructionIndex => _currentInstructionIndex; // New getter
  LatLng? get currentLocation => _currentLocation;
  LatLng? get origin => _origin;
  LatLng? get destination => _destination;
  MapController? get mapController => _mapController;
  RouteModel? get currentRoute => _currentRoute;
  Position? get currentGpsPosition => _currentGpsPosition; // New getter
  List<SearchResultModel> get originSearchResults => _originSearchResults;
  List<SearchResultModel> get destinationSearchResults =>
      _destinationSearchResults;

  void setMapController(MapController controller) {
    _mapController = controller;
  }

  Future<void> fetchCurrentLocation() async {
    try {
      final location = await _locationService.getCurrentLocation();
      if (location != null) {
        final latLng = LatLng(location.latitude, location.longitude);
        _currentLocation = latLng;
        _mapController?.move(latLng, _mapController!.camera.zoom);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching current location: $e');
    }
  }

  Future<void> searchLocation(String query, {required bool isOrigin}) async {
    try {
      final results = await _geocodingService.search(query);
      if (isOrigin) {
        _originSearchResults = results;
      } else {
        _destinationSearchResults = results;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error searching location: $e');
    }
  }

  void clearSearchResults({required bool isOrigin}) {
    if (isOrigin) {
      _originSearchResults = [];
    } else {
      _destinationSearchResults = [];
    }
    notifyListeners();
  }

  Future<void> _fetchRoute() async {
    if (_origin != null && _destination != null) {
      _navigationState = NavigationState.loading;
      notifyListeners();
      try {
        _currentRoute = await _routingService.getRoute(_origin!, _destination!);
        _navigationState = NavigationState.preview;
        notifyListeners();
      } catch (e) {
        debugPrint('Error fetching route: $e');
        _currentRoute = null;
        _navigationState = NavigationState.idle;
        notifyListeners();
      }
    }
  }

  void setCurrentLocation(LatLng location) {
    _currentLocation = location;
    notifyListeners();
  }

  void setOrigin(LatLng location) {
    _origin = location;
    _fetchRoute(); // Fetch route when origin changes
    notifyListeners();
  }

  void setDestination(LatLng location) {
    _destination = location;
    _fetchRoute(); // Fetch route when destination changes
    notifyListeners();
  }

  void cancelRoutePreview() {
    _navigationState = NavigationState.idle;
    _currentRoute = null;
    notifyListeners();
  }

  @visibleForTesting
  void forceState(NavigationState state) {
    _navigationState = state;
    notifyListeners();
  }

  @visibleForTesting
  void forceRoute(RouteModel route) {
    _currentRoute = route;
    notifyListeners();
  }

  Future<void> startNavigation() async {
    _navigationState = NavigationState.navigating;
    _currentInstructionIndex = 0; // Reset index
    notifyListeners();

    final permission = await _locationService.checkPermission();
    if (permission == LocationPermission.denied) {
      final requestResult = await _locationService.requestPermission();
      if (requestResult == LocationPermission.denied ||
          requestResult == LocationPermission.deniedForever) {
        debugPrint('Location permissions denied.');
        // TODO: Handle permission denied gracefully (e.g., show a dialog)
        _navigationState = NavigationState.idle;
        notifyListeners();
        return;
      }
    }

    _positionStreamSubscription = _locationService.getPositionStream().listen(
      (Position position) {
        onPositionUpdate(position);
      },
      onError: (e) {
        debugPrint('Error in position stream: $e');
        // TODO: Handle stream errors
      },
      cancelOnError: true,
    );
  }

  void stopNavigation() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    _navigationState = NavigationState.idle;
    _currentRoute = null;
    _currentGpsPosition = null;
    _currentInstructionIndex = 0; // Reset index
    notifyListeners();
  }

  void onPositionUpdate(Position position) {
    _currentGpsPosition = position;

    if (_currentRoute != null &&
        _currentInstructionIndex < _currentRoute!.instructions.length - 1) {
      final nextInstruction = _currentRoute!.instructions[_currentInstructionIndex + 1];
      final nextManeuverPoint =
          _currentRoute!.polylinePoints[nextInstruction.interval.first];

      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        nextManeuverPoint.latitude,
        nextManeuverPoint.longitude,
      );

      if (distance < 20) { // 20 meter threshold
        _currentInstructionIndex++;
      }
    }

    notifyListeners();
  }
}
