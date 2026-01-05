import 'package:flutter/material.dart';
import 'package:final_project/model/room_model_class.dart';
import 'package:final_project/model/static_data.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomViewModel extends GetxController {
  RxString newRoomName = ''.obs;
  RxBool isPrivateRoom = false.obs;
  RxBool isLoading = false.obs;

  // room type filter
  RxString roomType = 'public'.obs;

  void setPublic() {
    roomType.value = 'public';
  }

  void setPrivate() {
    roomType.value = 'private';
  }

  // RxList of RoomModel
  RxList<RoomModel> rooms = <RoomModel>[].obs;

  // Toggle private room
  void togglePrivate() {
    isPrivateRoom.value = !isPrivateRoom.value;
  }

  // Load rooms from Firestore
  Future<void> loadRooms() async {
    final userId = StaticData.mymodel?.userId;
    if (userId == null) return;

    try {
      // 🔹 Collection changed to 'finalrooms'
      final querySnapshot =
          await FirebaseFirestore.instance.collection('finalrooms').get();

      rooms.value = querySnapshot.docs.map((doc) {
        final data = doc.data();

        return RoomModel(
          roomId: doc.id,
          name: data['roomName'] ?? '',
          creatorId: data['adminId'] ?? '',
          creatorName: data['adminName'] ?? '',
          isPrivate: data['private'] ?? false,
          members: data['members'] != null
              ? List<String>.from((data['members'] as List<dynamic>))
              : [],
        );
      }).toList();
    } catch (e) {
      debugPrint("❌ Error loading rooms: $e");
    }
  }

  // Create room
  Future<void> createRoom() async {
    if (newRoomName.value.trim().isEmpty) return;

    isLoading.value = true;
    try {
      final currentUser = StaticData.mymodel;
      if (currentUser == null) return;

      // Ensure userId is non-null before adding to members list
      final membersList = <String>[];
      if (currentUser.userId != null && currentUser.userId!.isNotEmpty) {
        membersList.add(currentUser.userId!);
      }

      // 🔹 Collection changed to 'finalrooms'
      final docRef =
          await FirebaseFirestore.instance.collection('finalrooms').add({
        'roomName': newRoomName.value,
        'adminId': currentUser.userId ?? '',
        'adminName': currentUser.name ?? '',
        'private': isPrivateRoom.value,
        'members': membersList,
        'lastMsg': '',
      });

      // Update local list
      rooms.insert(
        0,
        RoomModel(
          roomId: docRef.id,
          name: newRoomName.value,
          creatorId: currentUser.userId ?? '',
          creatorName: currentUser.name ?? '',
          isPrivate: isPrivateRoom.value,
          members: membersList,
        ),
      );

      // Reset input
      newRoomName.value = '';
      isPrivateRoom.value = false;
    } catch (e) {
      debugPrint("❌ Room create error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Join room
  Future<void> joinRoom(String roomIdOrCode) async {
    if (roomIdOrCode.trim().isEmpty) return;

    isLoading.value = true;
    try {
      final currentUser = StaticData.mymodel;
      if (currentUser == null) return;

      // 1. Check if room exists
      final docRef =
          FirebaseFirestore.instance.collection('finalrooms').doc(roomIdOrCode);
      final docSnap = await docRef.get();

      if (!docSnap.exists) {
        Get.snackbar("Error", "Room not found",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
        return;
      }

      // 2. Add user to members list
      await docRef.update({
        'members': FieldValue.arrayUnion([currentUser.userId])
      });

      Get.snackbar("Success", "Joined room successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);

      // Refresh list
      await loadRooms();
    } catch (e) {
      debugPrint("❌ Join room error: $e");
      Get.snackbar("Error", "Failed to join room",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
