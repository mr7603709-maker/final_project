import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/static_data.dart';
import 'package:final_project/utills/show_snackmessage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteFriendMessageViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteMessages(String chatroomId, List<String> messageIds, Map<String, String> senders) async {
    if (StaticData.mymodel == null || StaticData.mymodel!.userId == null) return;

    String currentUserId = StaticData.mymodel!.userId!;

    // Delete the messages
    for (String messageId in messageIds) {
      String senderId = senders[messageId] ?? '';

      if (senderId == currentUserId) {
        // Delete own message completely
        await _firestore
            .collection('finalchatroom')
            .doc(chatroomId)
            .collection('chats')
            .doc(messageId)
            .delete();
      } else {
        // Hide message for current user
        DocumentReference docRef = _firestore
            .collection('finalchatroom')
            .doc(chatroomId)
            .collection('chats')
            .doc(messageId);
        
        DocumentSnapshot doc = await docRef.get();
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        List<String> visibleTo = List<String>.from(data?['visibleTo'] ?? []);
        
        if (visibleTo.isEmpty) {
          // Old message without visibleTo, set to only sender
          await docRef.update({
            'visibleTo': [senderId]
          });
        } else {
          // New message, remove current user
          await docRef.update({
            'visibleTo': FieldValue.arrayRemove([currentUserId])
          });
        }
      }
    }

    // Always update the last message after deletion to ensure it reflects visible messages
    await _updateLastMessage(chatroomId);

    Utils.toastMessage( 'Deleted successfully');
    
  }

  Future<void> _updateLastMessage(String chatroomId) async {
    try {
      String currentUserId = StaticData.mymodel!.userId!;

      // Get all messages ordered by time descending to find the last visible one
      QuerySnapshot allMessages = await _firestore
          .collection('finalchatroom')
          .doc(chatroomId)
          .collection('chats')
          .orderBy('time', descending: true)
          .get();

      String lastMessageText = 'Start a conversation';
      Timestamp? lastMessageTime;
      String? lastMessageBy;

      // Find the most recent message that is visible to current user
      for (var doc in allMessages.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final message = data['message'] ?? '';
        final time = data['time'] as Timestamp?;
        final sendBy = data['sendBy'] ?? '';
        final visibleTo = List<String>.from(data['visibleTo'] ?? []);

        // Check if message is visible to current user
        bool isVisible = false;
        if (visibleTo.isEmpty) {
          // Old message without visibleTo field - visible to everyone
          isVisible = true;
        } else {
          // New message with visibleTo field
          isVisible = visibleTo.contains(currentUserId);
        }

        if (isVisible) {
          lastMessageText = message;
          lastMessageTime = time;
          lastMessageBy = sendBy;
          break; // Found the most recent visible message
        }
      }

      // Update the chatroom document with the new last message
      await _firestore.collection('finalchatroom').doc(chatroomId).update({
        'lastMessage': lastMessageText,
        'lastMessageTime': lastMessageTime,
        'lastMessageBy': lastMessageBy,
      });
    } catch (e) {
      debugPrint('Error updating last message: $e');
    }
  }
}