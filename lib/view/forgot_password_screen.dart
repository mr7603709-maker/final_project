// ignore_for_file: non_constant_identifier_names

import 'dart:ui';
import 'package:final_project/customwidget/button_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // You might want a dedicated ForgotPasswordViewModel, but simpler to reuse or use text controller directly here
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Elements
          Positioned(
            top: -height * 0.15,
            left: width * 0.2,
            child: Container(
              height: height * 0.4,
              width: width * 0.7,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade800, Colors.red.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
            )
                .animate()
                .scale(
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                )
                .fade(),
          ),

          // Glassmorphism Overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(color: Colors.black.withValues(alpha: 0.3)),
          ),

          // Back Button
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
              onPressed: () => Get.back(),
            ),
          ).animate().fade(delay: 200.ms),

          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: width * 0.08),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_reset,
                      size: 60,
                      color: Colors.white,
                    ),
                  ).animate().scale(delay: 200.ms, curve: Curves.elasticOut),

                  SizedBox(height: height * 0.04),

                  // Header
                  Text(
                    "Forgot Password?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: width * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().slideY(begin: 0.5, end: 0, delay: 300.ms).fade(),

                  SizedBox(height: height * 0.01),

                  Text(
                    "Enter your email address to receive a password reset link.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      color: Colors.white70,
                      fontSize: width * 0.04,
                    ),
                  ).animate().slideY(begin: 0.5, end: 0, delay: 400.ms).fade(),

                  SizedBox(height: height * 0.06),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildGlassTextField(
                          controller: emailController,
                          hint: "Email Address",
                          icon: Icons.email_outlined,
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Please enter email'
                              : null,
                        )
                            .animate()
                            .slideX(begin: -1, end: 0, delay: 500.ms)
                            .fade(),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.06),

                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: RoundedButtonWidget(
                      width: width,
                      buttonColor: Colors.orange.shade800,
                      title: 'Send Reset Link',
                      loading: false, // Integrate with VM if needed
                      onPress: () {
                        if (_formKey.currentState!.validate()) {
                          // Implement reset logic here or call VM
                          Get.snackbar(
                            "Sent",
                            "Check your email for instructions",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.white24,
                            colorText: Colors.white,
                          );
                        }
                      },
                    ),
                  ).animate().scale(
                        delay: 700.ms,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.elasticOut,
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            validator: validator,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.white70),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white38),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
