import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xGPT/chat/presentation/pages/chat_page.dart';

Future<void> main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('onError::exception: ${details.exception}');
    debugPrint('onError::stack: ${details.stack}');

  };
  runZonedGuarded(() async {
    runApp(const MyApp());
  }, (error, stackTrace) async {
    debugPrint('runZonedGuarded::error: $error');
    debugPrint('runZonedGuarded::stackTrace: $stackTrace');

    Get.snackbar('Error', 'An unexpected error occurred');
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AI APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const ChatPage(),
    );

  }
}
