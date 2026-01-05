import 'package:final_project/resources/app_route.dart';
import 'package:final_project/theme_data/mytheme.dart';
import 'package:final_project/view/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'package:final_project/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ REQUIRED
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FYP',
      theme: lightTheme,
      darkTheme: darkTheme,
      getPages: AppRoute.appRoute(),
      home: Splashscreen(),
    );
  }
}
