import 'package:final_project/resources/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

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
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Dynamic Background
          Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1A2E),
                  Color(0xFF16213E),
                  Color(0xFF0F3460),
                ],
              ),
            ),
          ),

          // Background Overlay Pattern (Optional, adds texture)
          Opacity(
            opacity: 0.1,
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(
                    'images/Welcome.png'), // Keeping original image as texture or replace if needed
                fit: BoxFit.cover,
              )),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.08),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),

                  // Logo / Icon (Placeholder if no logo provided)
                  Icon(
                    Icons.music_note_rounded,
                    size: width * 0.2,
                    color: Colors.white,
                  )
                      .animate()
                      .scale(duration: 600.ms, curve: Curves.easeOutBack)
                      .fadeIn(duration: 600.ms),

                  SizedBox(height: height * 0.04),

                  // Title
                  Text(
                    "Feel the Beat,\nShare the Vibe",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: width * 0.09,
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                  )
                      .animate()
                      .slideY(
                          begin: 0.3, end: 0, duration: 600.ms, delay: 200.ms)
                      .fadeIn(duration: 600.ms),

                  SizedBox(height: height * 0.02),

                  // Subtitle
                  Text(
                    "The ultimate entertainment hub for you and your crew. Join rooms, listen together.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                      fontSize: width * 0.038,
                    ),
                  )
                      .animate()
                      .slideY(
                          begin: 0.3, end: 0, duration: 600.ms, delay: 400.ms)
                      .fadeIn(duration: 600.ms),

                  const Spacer(flex: 3),

                  // Action Buttons
                  _buildAnimatedButton(
                    context,
                    label: "Join a Room",
                    icon: Icons.meeting_room_rounded,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    textColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    onTap: () => Get.toNamed(RouteName.joinroomscreen),
                    delay: 600.ms,
                  ),

                  SizedBox(height: height * 0.02),

                  _buildAnimatedButton(
                    context,
                    label: "Create Account",
                    icon: Icons.person_add_rounded,
                    color: Colors.white.withOpacity(0.1),
                    textColor: Colors.white,
                    onTap: () => Get.toNamed(RouteName.signupscreen),
                    delay: 700.ms,
                    isOutlined: true,
                  ),

                  SizedBox(height: height * 0.02),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                            color: Colors.white60, fontSize: width * 0.035),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(RouteName.loginscreen),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.038,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 900.ms),

                  SizedBox(height: height * 0.05),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
    required Duration delay,
    bool isOutlined = false,
  }) {
    final width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: isOutlined ? Border.all(color: Colors.white30) : null,
          boxShadow: isOutlined
              ? null
              : [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.04,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .scale(duration: 400.ms, delay: delay, curve: Curves.easeOutBack)
        .fadeIn(delay: delay);
  }
}
