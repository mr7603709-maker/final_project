// ignore_for_file: non_constant_identifier_names

import 'dart:ui';
import 'package:final_project/customwidget/button_widget.dart';
import 'package:final_project/view/forgot_password_screen.dart';
import 'package:final_project/view/signup_screen.dart';
import 'package:final_project/viewmodel/login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginVM = Get.put(LoginViewModel());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black, // Dark theme base
      body: Stack(
        children: [
          // Background Elements
          Positioned(
            top: -height * 0.2,
            left: -width * 0.2,
            child: Container(
              height: height * 0.5,
              width: width * 0.8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.shade900,
                    Colors.blue.shade900,
                  ],
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
          Positioned(
            bottom: -height * 0.2,
            right: -width * 0.2,
            child: Container(
              height: height * 0.5,
              width: width * 0.8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.shade900,
                    Colors.pink.shade900,
                  ],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
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
                  // Animated Header
                  Text(
                    "Welcome Back",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: width * 0.09,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().slideY(begin: -0.5, end: 0).fade(),

                  SizedBox(height: height * 0.01),

                  Text(
                    "Sign in to continue",
                    style: GoogleFonts.outfit(
                      color: Colors.white70,
                      fontSize: width * 0.045,
                    ),
                  ).animate().slideY(begin: -0.5, end: 0, delay: 200.ms).fade(),

                  SizedBox(height: height * 0.08),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildGlassTextField(
                          controller: LoginVM.emailController.value,
                          focusNode: LoginVM.emailFocusNode.value,
                          hint: "Email Address",
                          icon: Icons.email_outlined,
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Please enter email'
                              : null,
                        )
                            .animate()
                            .slideX(begin: -1, end: 0, delay: 400.ms)
                            .fade(),
                        SizedBox(height: height * 0.025),
                        _buildGlassTextField(
                          controller: LoginVM.passwordController.value,
                          focusNode: LoginVM.passwordFocusNode.value,
                          hint: "Password",
                          icon: Icons.lock_outline,
                          obscureText: true,
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Please enter password'
                              : null,
                        )
                            .animate()
                            .slideX(begin: 1, end: 0, delay: 600.ms)
                            .fade(),
                        SizedBox(height: height * 0.02),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                Get.to(() => const ForgotPasswordScreen()),
                            child: Text(
                              "Forgot Password?",
                              style: GoogleFonts.outfit(
                                color: Colors.blueAccent.shade100,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ).animate().fade(delay: 800.ms),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.05),

                  Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: RoundedButtonWidget(
                        width: width,
                        buttonColor: Colors.blue.shade600,
                        title: 'Login',
                        loading: LoginVM.loading.value,
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            LoginVM.login();
                          }
                        },
                      ),
                    ),
                  ).animate().scale(
                        delay: 1000.ms,
                        duration: 400.ms,
                        curve: Curves.elasticOut,
                      ),

                  SizedBox(height: height * 0.04),

                  Row(
                    children: [
                      const Expanded(child: Divider(color: Colors.white24)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Or continue with",
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                      const Expanded(child: Divider(color: Colors.white24)),
                    ],
                  ).animate().fade(delay: 1200.ms),

                  SizedBox(height: height * 0.03),

                  _buildSocialButton(
                    width,
                    height,
                  ).animate().fade(delay: 1400.ms).slideY(begin: 1, end: 0),

                  SizedBox(height: height * 0.04),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.outfit(color: Colors.white60),
                      ),
                      GestureDetector(
                        onTap: () => Get.to(() => const SignupScreen()),
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.outfit(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fade(delay: 1600.ms),
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

  Widget _buildSocialButton(double width, double height) {
    return Container(
      height: 55,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {}, // Add Google Sign-in logic
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/google.png', height: 24),
              const SizedBox(width: 15),
              Text(
                'Continue with Google',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
