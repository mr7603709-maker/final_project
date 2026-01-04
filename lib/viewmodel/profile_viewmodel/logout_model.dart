// ignore_for_file: use_build_context_synchronously

import 'package:final_project/view/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  // Singleton instance
  UserPreferences._privateConstructor();
  static final UserPreferences instance = UserPreferences._privateConstructor();

  /// Clears SharedPreferences and navigates to WelcomeScreen
  Future<void> logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Clear all saved data
      await prefs.clear();

      // Navigate safely, removing all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
        (route) => false, // Removes all previous routes
      );
    } catch (e) {
      debugPrint('Logout Error: $e');

      // Optional: Show a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }
}
