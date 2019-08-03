import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFunction {
  // Cloud function names
  static String sendSelfieRequest = 'sendSelfieRequest';
  static String checkIfOtherUserSentSelfieRequest = 'checkIfOtherUserSentSelfieRequest';
  static String acceptButtonVerify = 'acceptButtonVerify';
  static String getSelfieMatchedLocation = 'getSelfieMatchedLocation';

  static Future<HttpsCallableResult> call(String functionName, {String key = "nothing", String value = "nothing"}) {
    print("ATTEMPING TO CREATE CALLABLE CLOUD FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: functionName,
    );

    try {
      return callable.call(<String, String>{key: value});
    } catch (e) {
      print(e);
      return null;
    }
  }
}
