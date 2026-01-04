// ignore_for_file: unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/signup_model.dart';
import 'package:final_project/model/static_data.dart';
import 'package:final_project/resources/route_name.dart';
import 'package:final_project/utills/show_snackmessage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends GetxController {
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  final emailFocusNode = FocusNode().obs;
  final passwordFocusNode = FocusNode().obs;

  RxBool loading = false.obs;

  Future<void> login() async {
    final email = emailController.value.text.trim();
    final password = passwordController.value.text.trim();

    try {
      loading.value = true;

      // Fetch user by email & password
      final snapshot = await FirebaseFirestore.instance
          .collection("finalUsers")
          .where("email", isEqualTo: email)
          .where("password", isEqualTo: password)
          .get();

      if (snapshot.docs.isEmpty) {
        Utils.snackBar('Login Failed', 'Invalid email or password');
      } else {
        // Use first document
        StaticData.mymodel = UserData.fromMap(
          snapshot.docs[0].data() as Map<String, dynamic>,
        );

        /// ✅ Save login state safely (no null crash)
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', StaticData.mymodel?.userId ?? "");

        // Navigate to home
        Get.offAllNamed(RouteName.homescreen);

        // Clear controllers
        emailController.value.clear();
        passwordController.value.clear();
      }
    } catch (e) {
      Utils.snackBar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }
}
