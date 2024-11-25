import 'package:flutter/material.dart';

import '../helper/method_channel.dart';

class CallProvider extends ChangeNotifier {
  String callStatus = 'Dialing ... ';

  String timer = '00:00:00';

  bool isMuted = false;
  bool isSpeakerOn = false;

  TextEditingController numberController = TextEditingController();
  FocusNode numberFocusNode = FocusNode();

  void startCall(String number) async {
    String response = await makeCall(number);
    changeCallStatus(response);
  }

  void toggleMute() {
    isMuted = !isMuted;
    notifyListeners();
  }

  void toggleSpeaker() {
    isSpeakerOn = !isSpeakerOn;
    notifyListeners();
  }

  void startTime() {
    int seconds = 0;
    int minutes = 0;
    int hours = 0;
    Future.delayed(const Duration(seconds: 1), () {
      seconds++;
      if (seconds == 60) {
        seconds = 0;
        minutes++;
      }
      if (minutes == 60) {
        minutes = 0;
        hours++;
      }
      timer = '$hours:$minutes:$seconds';
      notifyListeners();
      startTime();
    });
  }

  void resetTime() {
    timer = '00:00:00';
    notifyListeners();
  }

  void changeCallStatus(String status) {
    callStatus = status;
    notifyListeners();
  }

  @override
  void dispose() {
    numberController.dispose();
    numberFocusNode.dispose();
    super.dispose();
  }
}
