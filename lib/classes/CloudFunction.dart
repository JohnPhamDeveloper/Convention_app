import 'package:cloud_functions/cloud_functions.dart';

class CloudFunction {
  // Cloud function names
  static String sendSelfieRequest = 'sendSelfieRequest';
  static String checkIfOtherUserSentSelfieRequest = 'checkIfOtherUserSentSelfieRequest';
  static String acceptButtonVerify = 'acceptButtonVerify';
  static String getSelfieMatchedLocation = 'getSelfieMatchedLocation';
  static String finishSelfie = 'finishSelfie';
  static String sendMessage = 'sendMessage';
  static String getEveryoneAround = 'getEveryoneAround';

  static Future<HttpsCallableResult> call(String functionName, {String key = "nothing", String value = "nothing"}) {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: functionName,
    );

    try {
      return callable.call(<String, String>{key: value});
    } catch (e) {
      print(e);
      return e;
    }
  }

  static Future<HttpsCallableResult> call2(String functionName, Map<dynamic, dynamic> argument) {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: functionName,
    );

    try {
      return callable.call(argument);
    } catch (e) {
      print(e);
      return e;
    }
  }
  // end
}
