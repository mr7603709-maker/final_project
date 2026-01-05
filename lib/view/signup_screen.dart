// ignore_for_file: non_constant_identifier_names

import 'dart:ui';
import 'package:final_project/customwidget/button_widget.dart';
import 'package:final_project/viewmodel/signup_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final SignupVM = Get.put(SignupViewModel());
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
            top: -height * 0.1,
            right: -width * 0.1,
            child: Container(
              height: height * 0.4,
              width: width * 0.7,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade800, Colors.blue.shade900],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
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
          Positioned(
            bottom: -height * 0.1,
            left: -width * 0.1,
            child: Container(
              height: height * 0.4,
              width: width * 0.7,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.shade900,
                    Colors.deepPurple.shade900,
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
                shape: BoxShape.circle,
              ),
            )
                .animate()
                .scale(
                  duration: const Duration(seconds: 2),
                  delay: 500.ms,
                  curve: Curves.easeInOut,
                )
                .fade(),
          ),

          // Glassmorphism Overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(color: Colors.black.withValues(alpha: 0.3)),
          ),

          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: width * 0.08),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Back Button
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white70,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ).animate().fade(delay: 200.ms),

                  SizedBox(height: height * 0.02),

                  // Header
                  Text(
                    "Create Account",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: width * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().slideY(begin: -0.5, end: 0).fade(),

                  SizedBox(height: height * 0.01),

                  Text(
                    "Join us and start chatting!",
                    style: GoogleFonts.outfit(
                      color: Colors.white70,
                      fontSize: width * 0.04,
                    ),
                  ).animate().slideY(begin: -0.5, end: 0, delay: 200.ms).fade(),

                  SizedBox(height: height * 0.06),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildGlassTextField(
                          controller: SignupVM.nameController.value,
                          focusNode: SignupVM.nameFocusNode.value,
                          hint: "Full Name",
                          icon: Icons.person_outline,
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Please enter name'
                              : null,
                        )
                            .animate()
                            .slideX(begin: -1, end: 0, delay: 300.ms)
                            .fade(),
                        SizedBox(height: height * 0.025),
                        _buildGlassTextField(
                          controller: SignupVM.emailController.value,
                          focusNode: SignupVM.emailFocusNode.value,
                          hint: "Email Address",
                          icon: Icons.email_outlined,
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Please enter email'
                              : null,
                        )
                            .animate()
                            .slideX(begin: 1, end: 0, delay: 450.ms)
                            .fade(),
                        SizedBox(height: height * 0.025),
                        _buildGlassTextField(
                          controller: SignupVM.passwordController.value,
                          focusNode: SignupVM.passwordFocusNode.value,
                          hint: "Password",
                          icon: Icons.lock_outline,
                          obscureText: true,
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Please enter password'
                              : null,
                        )
                            .animate()
                            .slideX(begin: -1, end: 0, delay: 600.ms)
                            .fade(),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.06),

                  Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: RoundedButtonWidget(
                        width: width,
                        buttonColor: Colors.teal.shade600,
                        title: 'Sign Up',
                        loading: SignupVM.loading.value,
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            SignupVM.signup(context);
                          }
                        },
                      ),
                    ),
                  ).animate().scale(
                        delay: 800.ms,
                        duration: 400.ms,
                        curve: Curves.elasticOut,
                      ),

                  SizedBox(height: height * 0.04),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: GoogleFonts.outfit(color: Colors.white60),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Text(
                          "Login",
                          style: GoogleFonts.outfit(
                            color: Colors.tealAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fade(delay: 1000.ms),
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
    required FocusNode focusNode,
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
            focusNode: focusNode,
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
