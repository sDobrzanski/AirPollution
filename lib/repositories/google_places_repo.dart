import 'package:air_pollution_app/models/geolocation_data.dart';
import 'package:cloud_functions/cloud_functions.dart';

const String _apiKey = "AIzaSyB-ZGHq8WotXTcHTl2wykuTNAspdGHcA-U";

class GooglePlacesRepo {
  Future<GeolocationData> httpRequestViaServer(String place) async {
    String url = "maps.googleapis.com";
    final Map<String, dynamic> query = <String, dynamic>{};
    query.addAll({
      'address': place,
      'key': _apiKey,
    });
    Uri uri = Uri.https(url, '/maps/api/geocode/json', query);

    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'getDataFromUrl',
    );
    try {
      final HttpsCallableResult result = await callable.call(
        <String, dynamic>{
          'url': uri.toString(),
        },
      );
      final GeolocationData geolocationData =
          GeolocationData.fromJson(result.data);
      return geolocationData;
    } on FirebaseFunctionsException catch (e) {
      throw 'Caught firebase functions exception ${e.code} ${e.message} ${e.details}';
    } catch (e) {
      throw 'Caught generic exception $e';
    }
  }
}
