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

Future<bool> toggleSpeaker(bool speakerStatus) async {
  try {
    bool isSpeakerOn = await platform.invokeMethod('toggleSpeaker', {
      "isSpeakerOn": speakerStatus,
    });
    return isSpeakerOn;
  } catch (e) {
    print('$tag | Failed to toggle speaker: $e');
    return false;
  }
}

Future<bool> toggleMute(bool isMute) async {
  try {
    bool isMuted =
        await platform.invokeMethod('toggleMute', {"isMute": isMute});
    return isMuted;
  } catch (e) {
    print('$tag | Failed to toggle mute: $e');
    return false;
  }
}

Future<int> answerCall() async {
  try {
    int callAnswered = await platform.invokeMethod('answerCall');
    return callAnswered;
  } catch (e) {
    print('$tag | Failed to answer call: $e');
    return 0;
  }
}

Future<void> endIncomingCall() async {
  try {
    await platform.invokeMethod('endIncomingCall');
  } catch (e) {
    print('$tag | Failed to end incoming call: $e');
  }
}

Future<void> endCall() async {
  try {
    await platform.invokeMethod('endCall');
  } catch (e) {
    print('$tag | Failed to end call: $e');
  }
}
