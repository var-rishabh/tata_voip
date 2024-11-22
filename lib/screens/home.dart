import 'package:flutter/cupertino.dart';

import '../helper/method_channel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String callStatus = 'Idle';

  TextEditingController numberController = TextEditingController();

  void startCall(String number) async {
    changeCallStatus('Dialing ... ');
    String response = await makeCall(number);
    changeCallStatus(response);
  }

  void changeCallStatus(String status) {
    setState(() {
      callStatus = status;
    });
  }

  @override
  void initState() {
    super.initState();
    initLinSDK();
  }

  @override
  void dispose() {
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: CupertinoTextField(
                controller: numberController,
                keyboardType: TextInputType.number,
                placeholder: 'Enter number',
                placeholderStyle: const TextStyle(
                  color: CupertinoColors.inactiveGray,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 36),
            Text(
              callStatus,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 36),
            CupertinoButton(
              borderRadius: BorderRadius.circular(8),
              color: CupertinoColors.activeBlue,
              child: const Text(
                'Call',
                style: TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 24,
                ),
              ),
              onPressed: () {
                startCall('6301450563');
              },
            ),
          ],
        ),
      ),
    );
  }
}
