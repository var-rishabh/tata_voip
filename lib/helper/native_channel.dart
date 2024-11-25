import 'package:flutter/services.dart';

class NativeChannel {
  static const MethodChannel _channel = MethodChannel('com.tata/voip');

  static void startListening(Function(dynamic) callback) {
    _channel.setMethodCallHandler((call) async {
      Map<dynamic, dynamic> args = {};
      args[call.method] = call.arguments;
      callback(args);
    });
  }
}
