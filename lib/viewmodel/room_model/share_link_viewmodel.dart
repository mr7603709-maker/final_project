import 'package:final_project/model/room_model_class.dart';
import 'package:final_project/utills/show_snackmessage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class RoomLinkViewModel extends GetxController {
  Rx<RoomModel?> currentRoom = Rx<RoomModel?>(null);

  /// SAFE room link
  String get roomLink {
    final roomId = currentRoom.value?.roomId;
    if (roomId == null || roomId.isEmpty) return '';
    return 'https://Playzone.com/room/$roomId';
  }

  /// SHARE LINK
  void shareRoomLink() {
    if (roomLink.isEmpty) {
      Utils.toastMessage('Room not loaded');
      return;
    }
    Share.share(roomLink);
  }

  /// COPY LINK
  void copyRoomLink() {
    if (roomLink.isEmpty) {
      Utils.toastMessage('Room not loaded');
      return;
    }
    Clipboard.setData(ClipboardData(text: roomLink));
    Utils.toastMessage('Link copied');
  }
}
