import 'package:flutter/services.dart';

const platform = MethodChannel('com.tata/voip');
const tag = 'LIN_SDK';

Future<void> initLinSDK() async {
  try {
    String response = await platform.invokeMethod('initLinSDK');
    print('$tag | $response');
    await login();
  } on PlatformException catch (e) {
    print('$tag | Failed to initialize SDK: ${e.message}');
  }
}

Future<void> login() async {
  try {
    String response = await platform.invokeMethod('loginLinSDK');
    print('$tag | $response');
  } catch (e) {
    print('$tag | Failed to login: $e');
  }
}

Future<String> makeCall(String number) async {
  try {
    String response = await platform.invokeMethod(
      'makeCall',
      {'number': number},
    );
    print('$tag | $response');
    return response;
  } catch (e) {
    print('$tag | Failed to make call: $e');
    return e.toString();
  }
}
