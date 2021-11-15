import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctionsService {
  Future<dynamic> httpRequestViaServer(Uri uri) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'getDataFromUrl',
    );
    try {
      final HttpsCallableResult result = await callable.call(
        <String, dynamic>{
          'url': uri.toString(),
        },
      );

      return result.data;
    } on FirebaseFunctionsException catch (e) {
      throw 'Caught firebase functions exception ${e.code} ${e.message} ${e.details}';
    } catch (e) {
      throw 'Caught generic exception $e';
    }
  }
}
