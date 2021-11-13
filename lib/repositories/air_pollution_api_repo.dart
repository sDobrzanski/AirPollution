import 'dart:convert';

import 'package:air_pollution_app/models/air_data.dart';
import 'package:http/http.dart' as http;

class AirPollutionApiRepo {
  final String _recipesUrl = 'api.openweathermap.org';
  final String _apiKey = "545ac0d77fa3f26c404c19b5fe65ee6d";
  final Map<String, String> _headers = {"Content-type": "application/json"};

  Future<AirData>? getAirData(String lat, String long) async {
    final Map<String, dynamic> query = <String, dynamic>{};
    query.addAll({
      'appid': _apiKey,
      'lat': lat,
      'long': long,
    });
    Uri uri = Uri.https(_recipesUrl, '/data/2.5/air_pollution', query);
    final http.Response _response = await http.get(uri, headers: _headers);

    if (_response.statusCode == 200) {
      final AirData airData = AirData.fromJson(json.decode(_response.body));
      return airData;
    } else {
      throw '${_response.statusCode} Problem with the get request';
    }
  }
}
