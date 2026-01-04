import 'package:final_project/view/friendchat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:final_project/model/friend_model.dart';

class FriendchatScreenWrapper extends StatelessWidget {
  const FriendchatScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        Get.arguments as Map<String, dynamic>;

    return FriendchatScreen(
      chatroomId: args['chatroomId'] as String,
      model: args['model'] as FriendModel,
    );
  }
}
