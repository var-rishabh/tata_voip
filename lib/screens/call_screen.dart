import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../provider/call.dart';

class CallScreen extends StatefulWidget {
  final String contactName;
  final String contactNumber;

  const CallScreen({
    super.key,
    required this.contactName,
    required this.contactNumber,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CallProvider callProvider = Provider.of<CallProvider>(context);

    return CupertinoPageScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                widget.contactName,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.contactNumber,
                style: const TextStyle(
                  fontSize: 24,
                  color: CupertinoColors.systemGrey,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                callProvider.callStatus,
                style: const TextStyle(
                  fontSize: 20,
                  color: CupertinoColors.activeGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconButton(
                callProvider.isSpeakerOn
                    ? CupertinoIcons.volume_up
                    : CupertinoIcons.volume_off,
                callProvider.toggleSpeaker,
              ),
              GestureDetector(
                onTap: () {
                  // callProvider.startCall(widget.contactNumber);
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: CupertinoColors.systemRed,
                  ),
                  child: const Icon(
                    CupertinoIcons.phone,
                    size: 40,
                    color: CupertinoColors.white,
                  ),
                ),
              ),
              _buildIconButton(
                callProvider.isMuted
                    ? CupertinoIcons.mic_slash
                    : CupertinoIcons.mic,
                callProvider.toggleMute,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Function() onPressed) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Icon(
            icon,
            size: 50,
            color: CupertinoColors.activeBlue,
          ),
        ),
      ],
    );
  }
}