import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/signup_model.dart';
import 'package:final_project/model/static_data.dart';
import 'package:final_project/view/home_screen.dart';
import 'package:final_project/view/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final String? userId = prefs.getString('userId');

    if (!mounted) return;

    if (isLoggedIn && userId != null) {
      try {
        // ✅ Firestore se user data fetch
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("finalUsers")
            .doc(userId)
            .get();

        if (userDoc.exists) {
          StaticData.mymodel =
              UserData.fromMap(userDoc.data() as Map<String, dynamic>);
        }
      } catch (e) {
        debugPrint("Error fetching user data: $e");
      }

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: height * 0.15,
          width: width * 0.35,
          child: Column(
            children: [
              Text(
                "C",
                style: TextStyle(
                  color: const Color.fromARGB(255, 2, 145, 7),
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.12,
                ),
              ),
              Text(
                "Chatbox",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.05,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
