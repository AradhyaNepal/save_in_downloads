import 'package:flutter/material.dart';
import 'package:save_in_downloads/download_screen.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  static GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child:  MaterialApp(
        debugShowCheckedModeBanner: false,
        title:"Save in Downloads",
        navigatorKey: MyApp.navKey,
        home: const DownloadScreen(),
      ),
    );
  }
}
