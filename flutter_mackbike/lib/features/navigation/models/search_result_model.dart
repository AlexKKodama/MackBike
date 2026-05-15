import 'package:latlong2/latlong.dart';

class SearchResultModel {
  final int placeId;
  final String displayName;
  final LatLng latLng;
  final String? type;
  final String? icon;

  SearchResultModel({
    required this.placeId,
    required this.displayName,
    required this.latLng,
    this.type,
    this.icon,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      placeId: json['place_id'],
      displayName: json['display_name'],
      latLng: LatLng(double.parse(json['lat']), double.parse(json['lon'])),
      type: json['type'],
      icon: json['icon'],
    );
  }
}
