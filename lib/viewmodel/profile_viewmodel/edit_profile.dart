import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/static_data.dart';

class EditprofileViewModel extends GetxController {
  final nameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  final nameFocusNode = FocusNode().obs;
  final emailFocusNode = FocusNode().obs;
  final passwordFocusNode = FocusNode().obs;

  // Initialize with current user data
  @override
  void onInit() {
    super.onInit();
    nameController.value.text = StaticData.mymodel?.name ?? '';
    emailController.value.text = StaticData.mymodel?.email ?? '';
    passwordController.value.text = StaticData.mymodel?.password ?? '';
    // Password field can stay empty for security
  }

  // Update user profile
  Future<void> updateProfile(BuildContext context) async {
    final newName = nameController.value.text.trim();
    final newEmail = emailController.value.text.trim();
    final newPassword = passwordController.value.text.trim();

    Map<String, dynamic> updateData = {
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (newName.isNotEmpty) {
      updateData['name'] = newName;
      StaticData.mymodel!.name = newName; // Update static model
    }

    if (newEmail.isNotEmpty) {
      updateData['email'] = newEmail;
      StaticData.mymodel!.email = newEmail; // Update static model
    }

    if (newPassword.isNotEmpty) {
      updateData['password'] = newPassword;
      StaticData.mymodel!.password = newPassword; // Update static model
    }

    try {
      await FirebaseFirestore.instance
          .collection('finalUsers')
          .doc(StaticData.mymodel!.userId)
          .update(updateData);

      // Close the screen and return true for success
      if (context.mounted) Navigator.pop(context, true);
    } catch (e) {
      debugPrint("❌ Error updating profile: $e");
    }
  }
}
