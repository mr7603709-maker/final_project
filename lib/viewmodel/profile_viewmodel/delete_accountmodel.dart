import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/static_data.dart';
import 'package:final_project/view/welcome_screen.dart';

class UserViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Deletes the current user from Firestore and navigates to login screen
  Future<void> deleteUser(BuildContext context) async {
    final String? userId = StaticData.mymodel?.userId;

    if (userId == null || userId.isEmpty) {
      debugPrint("❌ User ID is null or empty. Cannot delete user.");
      return;
    }

    _setLoading(true);

    try {
      // Delete Firestore user document
      await FirebaseFirestore.instance.collection("finalUsers").doc(userId).delete();
      debugPrint("✅ User deleted successfully");

      // Clear static model
      StaticData.mymodel = null;

      // Navigate to login screen and remove all previous routes
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        (route) => false,
      );
    } catch (e) {
      debugPrint("❌ Error deleting user: $e");
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
