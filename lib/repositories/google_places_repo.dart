import 'package:air_pollution_app/models/geolocation_data.dart';
import 'package:air_pollution_app/repositories/services/cloud_functions_service.dart';

const String _apiKey = "AIzaSyB-ZGHq8WotXTcHTl2wykuTNAspdGHcA-U";

class GooglePlacesRepo {
  final CloudFunctionsService _cloudFunctionsService = CloudFunctionsService();

  Future<GeolocationData> getLocationLatLong(String place) async {
    String url = "maps.googleapis.com";
    final Map<String, dynamic> query = <String, dynamic>{};
    query.addAll({
      'address': place,
      'key': _apiKey,
    });
    Uri uri = Uri.https(url, '/maps/api/geocode/json', query);

    final dynamic result =
        await _cloudFunctionsService.httpRequestViaServer(uri);

    final GeolocationData geolocationData = GeolocationData.fromJson(result);
    return geolocationData;
  }
}
