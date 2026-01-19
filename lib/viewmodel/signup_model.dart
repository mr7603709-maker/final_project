// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/utills/show_snackmessage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:final_project/model/signup_model.dart';
import 'package:final_project/view/login_screen.dart';

class SignupViewModel extends GetxController {
  final nameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  final nameFocusNode = FocusNode().obs;
  final emailFocusNode = FocusNode().obs;
  final passwordFocusNode = FocusNode().obs;

  RxBool loading = false.obs;

  /// 🔥 SIGNUP METHOD (WITH FULL VALIDATION)
  Future<void> signup(BuildContext context) async {
    final name = nameController.value.text.trim();
    final email = emailController.value.text.trim();
    final password = passwordController.value.text.trim();

    /// ❌ Empty field check
    // if (name.isEmpty || email.isEmpty || password.isEmpty) {
    //   Utils.snackBar(
    //     "Invalid Input",
    //     "All fields are required",
    //   );
    //   return;
    // }

    /// ❌ Gmail validation
    if (!email.endsWith('@gmail.com')) {
      Utils.snackBar(
        "Invalid Email",
        "Only gmail.com emails are allowed",
      );
      return;
    }

    /// ❌ Check if email already exists
    try {
      final emailQuery = await FirebaseFirestore.instance
          .collection("finalUsers")
          .where("email", isEqualTo: email)
          .get();

      if (emailQuery.docs.isNotEmpty) {
        Utils.snackBar(
          "Email ",
          "Please change email",
        );
        return;
      }
    } catch (e) {
      print("❌ Email check error: $e");
      Utils.snackBar(
        "Error",
        "Unable to verify email. Please try again.",
      );
      return;
    }

    try {
      loading.value = true;

      var uid = const Uuid();
      String id = uid.v4();

      UserData data = UserData(
        name: name,
        email: email,
        password: password,
        userId: id,
      );

      await FirebaseFirestore.instance
          .collection("finalUsers")
          .doc(id)
          .set(data.toMap());

      print("✅ User is successfully created");

      /// ✅ CLEAR CONTROLLERS ONLY AFTER SUCCESS
      nameController.value.clear();
      emailController.value.clear();
      passwordController.value.clear();

      /// ✅ Navigate after success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      print("❌ Signup error: $e");
      Get.snackbar(
        "Error",
        "Signup failed. Try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      loading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.value.dispose();
    emailController.value.dispose();
    passwordController.value.dispose();
    super.onClose();
  }
}
