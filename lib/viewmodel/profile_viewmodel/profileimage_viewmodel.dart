import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/static_data.dart';

class ProfileImageViewModel extends GetxController {
  // ------------------ REACTIVE VARIABLES ------------------
  Rx<File?> selectedImage = Rx<File?>(null);
  RxBool isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();

  // ------------------ PICK IMAGE ------------------
  Future<void> pickImage({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80, // compress image
        maxWidth: 600,
      );

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      debugPrint("❌ Error picking image: $e");
    }
  }

  // ------------------ UPLOAD IMAGE ------------------
  Future<void> uploadProfileImage() async {
    final userId = StaticData.mymodel?.userId;
    if (userId == null || selectedImage.value == null) return;

    isLoading.value = true;

    try {
      // Upload to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("profile_images")
          .child("$userId.jpg");

      await storageRef.putFile(selectedImage.value!);

      // Get download URL
      final downloadUrl = await storageRef.getDownloadURL();

      // Update Firestore user document
      await FirebaseFirestore.instance
          .collection('finalUsers')
          .doc(userId)
          .update({
        'profileImage': downloadUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update StaticData model so UI updates instantly
      StaticData.mymodel!.profileImage = downloadUrl;

      Get.snackbar("Success", "Profile image updated successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      debugPrint("❌ Error uploading profile image: $e");
      Get.snackbar("Error", "Failed to upload image",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------ CLEAR SELECTED IMAGE ------------------
  void clearImage() {
    selectedImage.value = null;
  }
}
