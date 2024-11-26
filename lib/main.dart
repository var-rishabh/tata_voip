import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'provider/call.dart';
import 'screens/home.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CallProvider()),
      ],
      child: CupertinoApp(
        debugShowCheckedModeBanner: false,
        theme: const CupertinoThemeData(brightness: Brightness.dark),
        navigatorKey: navigatorKey,
        home: const Home(),
      ),
    ),
  );
}
