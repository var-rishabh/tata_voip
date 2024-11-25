import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'provider/call.dart';
import 'screens/home.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CallProvider()),
      ],
      child: const CupertinoApp(
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(brightness: Brightness.dark),
        home: Home(),
      ),
    ),
  );
}
