import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../helper/native_channel.dart';
import '../provider/call.dart';
import 'call_screen.dart';
import 'home.dart';

class IncomingCall extends StatefulWidget {
  final String contactNumber;

  const IncomingCall({
    super.key,
    required this.contactNumber,
  });

  @override
  State<IncomingCall> createState() => _IncomingCallState();
}

class _IncomingCallState extends State<IncomingCall> {
  late CallProvider callProvider;

  @override
  void initState() {
    super.initState();
    callProvider = Provider.of<CallProvider>(context, listen: false);

    NativeChannel.startListening(
      (event) {
        String key = event.keys.first.toString();
        switch (key) {
          case "CALL_CONNECTED":
            callProvider.startTime();
            callProvider.setOnCallReleasedCallback(() {
              if (mounted) {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => CallScreen(
                      contactName: "Unknown",
                      contactNumber: widget.contactNumber,
                    ),
                  ),
                );
              }
            });
            break;

          case "CALL_RELEASED":
            callProvider.setOnCallReleasedCallback(() {
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(
                    builder: (_) => const Home(),
                  ),
                  (route) => false,
                );
              }
            });
            callProvider.resetEverything();
            break;
        }
      },
    );
  }

  @override
  void dispose() {
    callProvider.setOnCallReleasedCallback(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CallProvider callProvider = Provider.of<CallProvider>(context);

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 120),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Call from',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 30),
              const Text(
                "Unknown",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.activeBlue,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "+91 ${widget.contactNumber}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.systemGrey,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CupertinoButton(
                    onPressed: () {
                      callProvider.pickUpCall();
                    },
                    color: CupertinoColors.activeGreen,
                    padding: const EdgeInsets.all(25),
                    borderRadius: BorderRadius.circular(50),
                    child: const Icon(
                      CupertinoIcons.phone_fill,
                      size: 50,
                      color: CupertinoColors.white,
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      callProvider.hangUpCall();
                    },
                    color: CupertinoColors.destructiveRed,
                    padding: const EdgeInsets.all(25),
                    borderRadius: BorderRadius.circular(50),
                    child: const Icon(
                      CupertinoIcons.phone_down_fill,
                      size: 50,
                      color: CupertinoColors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
