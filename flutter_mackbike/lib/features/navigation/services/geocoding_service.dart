import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/search_result_model.dart';

class GeocodingService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org/';

  Future<List<SearchResultModel>> search(String query) async {
    if (query.isEmpty) {
      return [];
    }

    final uri = Uri.parse(
      '${_baseUrl}search?q=$query&format=json&addressdetails=1&limit=10',
    );

    final response = await http.get(
      uri,
      headers: {
        'User-Agent':
            'MackBikeApp/1.0 (alex.kazuo.kodama@gmail.com)', // Replace with your actual app name and email
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SearchResultModel.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load search results: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
