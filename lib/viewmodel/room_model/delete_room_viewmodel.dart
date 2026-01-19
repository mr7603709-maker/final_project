import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/static_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoomDeleteViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxBool isAdmin = false.obs;

  void checkAdminStatus(String creatorId) {
    if (StaticData.mymodel == null || StaticData.mymodel!.userId == null) {
      isAdmin.value = false;
      return;
    }
    isAdmin.value = StaticData.mymodel!.userId == creatorId;
  }

  bool isRoomAdmin(String creatorId) {
    if (StaticData.mymodel == null || StaticData.mymodel!.userId == null) {
      return false;
    }
    return StaticData.mymodel!.userId == creatorId;
  }

  Future<void> deleteRoom({
    required String roomId,
    required String creatorId,
  }) async {
    if (!isRoomAdmin(creatorId)) {
      Get.snackbar(
        "Not Allowed",
        "Only room admin can delete this room",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    await _firestore.collection('finalrooms').doc(roomId).delete();

    Get.back(); // dialog close
    Get.back(); // room screen close

    Get.snackbar(
      "Room Deleted",
      "Room deleted successfully",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
