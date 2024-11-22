import 'package:flutter/cupertino.dart';

import 'screens/home.dart';

void main() {
  runApp(
    const CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(brightness: Brightness.dark),
      home: Home(),
    ),
  );
}
