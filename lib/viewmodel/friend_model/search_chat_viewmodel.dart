import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/friend_model.dart';
import 'package:final_project/model/static_data.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class SearchChatViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable variables
  var searchQuery = ''.obs;
  var filteredFriends = <FriendModel>[].obs;
  var allFriends = <FriendModel>[].obs;
  var isSearching = false.obs;

  StreamSubscription<QuerySnapshot>? _friendsSubscription;

  @override
  void onInit() {
    super.onInit();
    setupFriendsStream();
  }

  @override
  void onClose() {
    _friendsSubscription?.cancel();
    super.onClose();
  }

  // Setup real-time friends stream
  void setupFriendsStream() {
    if (StaticData.mymodel == null || StaticData.mymodel!.userId == null) {
      return;
    }

    final currentUserId = StaticData.mymodel!.userId!;

    // Cancel previous subscription if exists
    _friendsSubscription?.cancel();

    _friendsSubscription = _firestore
        .collection("finalfriends")
        .where("userId", isEqualTo: currentUserId)
        .snapshots()
        .listen(
      (snapshot) {
        allFriends.value = snapshot.docs
            .map((doc) => FriendModel.fromMap(doc.data()))
            .toList();
        updateFilteredFriends();
      },
      onError: (error) {
        debugPrint('Error in friends stream: $error');
      },
    );
  }

  // Manual refresh method for immediate updates
  Future<void> manualRefresh() async {
    setupFriendsStream();
  }

  // Update filtered friends based on current search
  void updateFilteredFriends() {
    if (searchQuery.value.isEmpty) {
      filteredFriends.value = allFriends;
    } else {
      filteredFriends.value = allFriends.where((friend) {
        final friendName = friend.friendname?.toLowerCase() ?? '';
        return friendName.contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }

  // Search friends by name
  void searchFriends(String query) {
    searchQuery.value = query;
    isSearching.value = query.isNotEmpty;
    updateFilteredFriends();
  }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
    isSearching.value = false;
    updateFilteredFriends();
  }

  // Get chat room ID for a friend
  String getChatRoomId(String friendId) {
    final currentUserId = StaticData.mymodel!.userId!;
    List<String> users = [currentUserId, friendId];
    users.sort();
    return "${users[0]}_${users[1]}";
  }
}
