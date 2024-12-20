import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../helper/method_channel.dart';

class CallProvider extends ChangeNotifier {
  String callStatus = 'Dialing ...';
  String formattedTime = '00:00';

  bool isMuted = false;
  bool isSpeakerOn = false;

  TextEditingController numberController = TextEditingController();
  FocusNode numberFocusNode = FocusNode();

  Timer? _timer;
  int _secondsElapsed = 0;

  VoidCallback? onCallReleased;

  void setOnCallReleasedCallback(VoidCallback callback) {
    onCallReleased = callback;
  }

  void startCall(String number) async {
    await makeCall(number);
  }

  void pickUpCall() async {
    await answerCall();
    onCallReleased?.call();
  }

  void hangUpCall() async {
    await endCall();
    stopTime();
  }

  void changeMute() async {
    isMuted = !isMuted;

    await toggleMute(isMuted);
    notifyListeners();
  }

  void changeSpeaker() async {
    isSpeakerOn = !isSpeakerOn;

    await toggleSpeaker(isSpeakerOn);
    notifyListeners();
  }

  void startTime() {
    stopTime();
    changeCallStatus("timer");

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsElapsed++;
      int minutes = (_secondsElapsed % 3600) ~/ 60;
      int seconds = _secondsElapsed % 60;

      formattedTime = '${_formatTime(minutes)}:${_formatTime(seconds)}';
      notifyListeners();
    });
  }

  void stopTime() {
    _timer?.cancel();
    _timer = null;
    _secondsElapsed = 0;
    formattedTime = '00:00';
    notifyListeners();
  }

  String _formatTime(int value) => value.toString().padLeft(2, '0');

  void changeCallStatus(String status) {
    callStatus = status;
    notifyListeners();
  }

  void resetEverything() async {
    stopTime();
    await toggleMute(false);
    changeCallStatus('Dialing ... ');
    isMuted = false;
    isSpeakerOn = false;
    onCallReleased?.call();

    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    numberController.dispose();
    numberFocusNode.dispose();
    super.dispose();
  }
}
