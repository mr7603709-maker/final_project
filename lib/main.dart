import 'package:final_project/resources/app_route.dart';
import 'package:final_project/theme_data/mytheme.dart';
import 'package:final_project/view/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      getPages:AppRoute.appRoute(),
      home: WelcomeScreen(),
    );
  }
}
