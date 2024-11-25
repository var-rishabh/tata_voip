import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../helper/method_channel.dart';
import '../provider/call.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, String> contacts = {
    "Anurudh": "7025025081",
    "Radioactive": "7015507141",
    "Rishabh": "7078202575",
    "Vijay": "6301450563",
  };

  @override
  void initState() {
    super.initState();
    login();
  }

  @override
  Widget build(BuildContext context) {
    final CallProvider callProvider =
        Provider.of<CallProvider>(context, listen: false);

    return CupertinoPageScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 25),
                child: Text(
                  'Runo X Tata',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.activeBlue,
                    letterSpacing: 2,
                  ),
                ),
              ),
              for (String name in contacts.keys)
                CupertinoListTile(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () => callProvider.startCall(contacts[name]!),
                    child: const Icon(
                      CupertinoIcons.phone,
                      size: 35,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                  subtitle: Text(
                    "+91 ${contacts[name]!}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
