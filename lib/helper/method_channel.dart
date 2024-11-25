import 'package:flutter/services.dart';

const platform = MethodChannel('com.tata/voip');
const tag = 'LIN_SDK';

Future<void> login() async {
  try {
    String response = await platform.invokeMethod('loginLinSDK');
    print('$tag | $response');
  } catch (e) {
    print('$tag | Failed to login: $e');
  }
}

Future<void> makeCall(String number) async {
  try {
    await platform.invokeMethod(
      'makeCall',
      {'number': number},
    );
  } catch (e) {
    print('$tag | Failed to make call: $e');
  }
}

Future<void> endCall() async {
  try {
    await platform.invokeMethod('endCall');
  } catch (e) {
    print('$tag | Failed to end call: $e');
  }
}
