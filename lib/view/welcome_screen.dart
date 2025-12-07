import 'package:final_project/resources/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('images/Welcome.png'),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: height * 0.15),
            Text(
              "Welcome",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.055,
              ),
            ),
            SizedBox(height: height * 0.02),
            Text(
              "The entertainment hub you and your crew.",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
                fontSize: width * 0.03,
              ),
            ),
            SizedBox(height: height * 0.45),
            InkWell(
              onTap: () {
                Get.toNamed(RouteName.joinroomscreen);
              },
              child: Container(
                height: height * 0.05,
                width: width * 0.7,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(width * 0.03),
                ),
                child: Center(
                  child: Text(
                    "Join a room",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.035,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height*0.03),
            InkWell(
              onTap: () {
                Get.toNamed(RouteName.signupscreen);
              },
              child: Container(
                height: height * 0.05,
                width: width * 0.7,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(width * 0.03),
                ),
                child: Center(
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.035,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height*0.03),
            InkWell(
              onTap: () {
                Get.toNamed(RouteName.loginscreen);
              },
              child: Container(
                height: height * 0.05,
                width: width * 0.7,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(width * 0.03),
                ),
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.035,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
