import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/utills/show_snackmessage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:final_project/view/chat_room_screen.dart';

class JoinRoomViewModel extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> joinRoomByLink({
    required String link,
    required BuildContext context,
  }) async {
    if (link.trim().isEmpty) {
      Utils.toastMessage('Please paste room link');

      return;
    }

    /// Extract roomId
    Uri? uri = Uri.tryParse(link.trim());
    if (uri == null || uri.pathSegments.isEmpty) {
      Utils.toastMessage('Invalid room link');

      return;
    }

    String roomId = uri.pathSegments.last;

    try {
      isLoading.value = true;

      final doc = await FirebaseFirestore.instance
          .collection('finalrooms')
          .doc(roomId)
          .get();

      if (!doc.exists) {
        Utils.toastMessage('Room not found');

        return;
      }

      final data = doc.data()!;

      /// Navigate to ChatRoomScreen
      Get.to(
        () => const ChatRoomscreen(),
        arguments: {
          "roomId": roomId,
          "roomName": data['roomName'] ?? "Room Chat",
          "isPrivate": data['private'] ?? false,
          "creatorId": data['adminId'] ?? '',
        },
      );
    } catch (e) {
      Utils.snackBar('Error', "Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
