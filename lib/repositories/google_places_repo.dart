import 'package:cloud_functions/cloud_functions.dart';

const String _apiKey = "AIzaSyB-ZGHq8WotXTcHTl2wykuTNAspdGHcA-U";

class GooglePlacesRepo {

  Future httpRequestViaServer(String place) async {
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
      return (result.data);
    } on FirebaseFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e.code);
      print(e.message);
      print(e.details);
      return null;
    } catch (e) {
      print('caught generic exception');
      print(e);
      return null;
    }
  }
}
