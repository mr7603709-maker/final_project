import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/static_data.dart';
import 'package:get/get.dart';

class VideoSyncViewModel extends GetxController {
  final String roomId;
  VideoSyncViewModel(this.roomId);

  RxBool isPlaying = false.obs;
  RxDouble position = 0.0.obs;

  late final DocumentReference videoStateRef;

  @override
  void onInit() {
    super.onInit();

    videoStateRef = FirebaseFirestore.instance
        .collection('finalrooms')
        .doc(roomId)
        .collection('videoState')
        .doc('state');

    _listenVideoState();
  }

  // 🔴 FIRESTORE → APP
  void _listenVideoState() {
    videoStateRef.snapshots().listen((doc) {
      if (!doc.exists) return;

      final data = doc.data() as Map<String, dynamic>;

      isPlaying.value = data['isPlaying'] ?? false;
      position.value = (data['position'] ?? 0).toDouble();
    });
  }

  // 🔵 APP → FIRESTORE
  Future<void> updateState({
    required bool play,
    required double pos,
  }) async {
    final user = StaticData.mymodel;
    if (user == null) return;

    await videoStateRef.set({
      'isPlaying': play,
      'position': pos,
      'updatedBy': user.userId,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
