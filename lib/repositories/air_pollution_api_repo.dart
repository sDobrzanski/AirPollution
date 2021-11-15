import 'package:air_pollution_app/models/air_data.dart';
import 'package:air_pollution_app/repositories/services/cloud_functions_service.dart';

const String _apiKey = "545ac0d77fa3f26c404c19b5fe65ee6d";

class AirPollutionApiRepo {
  final CloudFunctionsService _cloudFunctionsService = CloudFunctionsService();
  final String _recipesUrl = 'api.openweathermap.org';

  Future<AirPollutionData>? getAirData(String lat, String long) async {
    final Map<String, dynamic> query = <String, dynamic>{};
    query.addAll({
      'appid': _apiKey,
      'lat': lat,
      'lon': long,
    });
    Uri uri = Uri.https(_recipesUrl, '/data/2.5/air_pollution', query);

    final dynamic result =
        await _cloudFunctionsService.httpRequestViaServer(uri);
    final AirPollutionData airData = AirPollutionData.fromJson(result);
    return airData;
  }
}
