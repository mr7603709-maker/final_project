import 'package:flutter/material.dart';
import 'package:final_project/model/room_model_class.dart';
import 'package:final_project/model/static_data.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomViewModel extends GetxController {
  RxString newRoomName = ''.obs;
  RxBool isPrivateRoom = false.obs;
  RxBool isLoading = false.obs;

  // filter
  RxString roomType = 'public'.obs;

  // data
  RxList<RoomModel> allRooms = <RoomModel>[].obs;
  RxList<RoomModel> filteredRooms = <RoomModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRooms();
    ever(roomType, (_) => filterRooms());
  }

  void setPublic() => roomType.value = 'public';
  void setPrivate() => roomType.value = 'private';

  void togglePrivate() {
    isPrivateRoom.value = !isPrivateRoom.value;
  }

  // ================= LOAD ROOMS =================
  Future<void> loadRooms() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('finalrooms').get();

      allRooms.assignAll(
        snapshot.docs.map((doc) {
          final data = doc.data();

          return RoomModel(
            roomId: doc.id,
            name: data['roomName'] ?? '',
            creatorId: data['adminId'] ?? '',
            creatorName: data['adminName'] ?? '',
            isPrivate: data['private'] ?? false,
            members: data['members'] != null
                ? List<String>.from(data['members'])
                : <String>[],
          );
        }).toList(),
      );

      filterRooms();
    } catch (e) {
      debugPrint("❌ Error loading rooms: $e");
    }
  }

  // ================= FILTER =================
  void filterRooms() {
    if (roomType.value == 'public') {
      filteredRooms.assignAll(
        allRooms.where((r) => r.isPrivate == false),
      );
    } else {
      filteredRooms.assignAll(
        allRooms.where((r) => r.isPrivate == true),
      );
    }
  }

  // ================= CREATE ROOM =================
  Future<void> createRoom() async {
    if (newRoomName.value.trim().isEmpty) return;

    try {
      final user = StaticData.mymodel;
      if (user == null || user.userId == null) return;

      final doc =
          await FirebaseFirestore.instance.collection('finalrooms').add({
        'roomName': newRoomName.value,
        'adminId': user.userId!,
        'adminName': user.name ?? '',
        'private': isPrivateRoom.value,
        'members': [user.userId!],
        'lastMsg': '',
      });

      allRooms.insert(
        0,
        RoomModel(
          roomId: doc.id,
          name: newRoomName.value,
          creatorId: user.userId!,
          creatorName: user.name ?? '',
          isPrivate: isPrivateRoom.value,
          members: [user.userId!],
        ),
      );

      filterRooms();

      newRoomName.value = '';
      isPrivateRoom.value = false;
    } catch (e) {
      debugPrint("❌ Create room error: $e");
    }
  }

  // ================= JOIN ROOM =================
  Future<void> joinRoom(String roomId) async {
    try {
      final user = StaticData.mymodel;
      if (user == null || user.userId == null) return;

      final doc =
          FirebaseFirestore.instance.collection('finalrooms').doc(roomId);

      final snap = await doc.get();
      if (!snap.exists) {
        Get.snackbar("Error", "Room not found");
        return;
      }

      await doc.update({
        'members': FieldValue.arrayUnion([user.userId!])
      });

      await loadRooms();
    } catch (e) {
      debugPrint("❌ Join room error: $e");
    }
  }
}
  