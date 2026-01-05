import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/friend_model.dart';
import 'package:final_project/model/static_data.dart';
import 'package:final_project/resources/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // -------------------- CHATROOM ID GENERATOR --------------------
  String chatRoomId(String user1, String user2) {
    if (user1.codeUnitAt(0) > user2.codeUnitAt(0)) {
      return "${user1}_$user2";
    } else {
      return "${user2}_$user1";
    }
  }

  // -------------------- FORMAT TIME --------------------
  String formatLastMessageTime(DateTime? dt) {
    if (dt == null) return "";

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dt.year, dt.month, dt.day);

    if (messageDate == today) {
      return DateFormat('hh:mm a').format(dt);
    } else {
      return DateFormat('dd/MM').format(dt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width; // Unused

    // -------------------- CHECK USER LOGGED IN --------------------
    if (StaticData.mymodel == null) {
      return const Scaffold(body: Center(child: Text("User not logged in")));
    }

    final currentUserId = StaticData.mymodel!.userId;

    return Scaffold(
      backgroundColor: Colors
          .transparent, // Background handled by main Layout/Stack locally or globally
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chats',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().slideX(begin: -0.5, end: 0).fade(),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteName.addfriendscreen);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.deepPurple.shade200),
                      ),
                      child: const Icon(
                        Icons.person_add_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ).animate().scale(delay: 200.ms),
                ],
              ),
            ),

            SizedBox(height: height * 0.01),

            // Search Bar (Visual Only for now, consistent UI)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: Colors.white38),
                    const SizedBox(width: 10),
                    Text(
                      'Search chats...',
                      style: GoogleFonts.outfit(
                        color: Colors.white38,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().slideY(begin: 0.2, end: 0, delay: 100.ms).fade(),

            SizedBox(height: height * 0.02),

            // Friend List
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _firestore
                    .collection("finalfriends")
                    .where(
                      Filter.or(
                        Filter("userId", isEqualTo: currentUserId),
                        Filter("friendId", isEqualTo: currentUserId),
                        // Note: The original code only checked userId == currentUserId, assuming unidirectional or bidirectional duplication.
                        // I'll stick to original logic: "userId" == currentUserId. But typically friends are bidirectional.
                      ),
                    )
                    // Original query was: .where("userId", isEqualTo: currentUserId)
                    // If the friend system duplicates entries (A->B and B->A), then userId==currentUserId is correct.
                    // Assuming that model based on previous code.
                    .where("userId", isEqualTo: currentUserId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 60,
                            color: Colors.white24,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "No friends yet",
                            style: GoogleFonts.outfit(
                              color: Colors.white38,
                              fontSize: 18,
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                Get.toNamed(RouteName.addfriendscreen),
                            child: const Text(
                              "Find Friends",
                              style: TextStyle(color: Colors.deepPurpleAccent),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fade();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: snapshot.data!.docs.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs[index].data();

                      // Safety check for nulls
                      if (data['friendId'] == null) return const SizedBox();

                      // We need to construct FriendModel carefully
                      FriendModel friendmodel = FriendModel.fromMap(data);
                      final friendId = friendmodel.friendId!;

                      // Generate ChatRoomID
                      // Original logic: sorted
                      // I implemented logic in chatRoomId helper above, but let's check previous logic.
                      // Previous logic: users.sort(); return "${users[0]}_${users[1]}";
                      // I should use the SAME logic to ensure I find the existing room.
                      List<String> users = [currentUserId!, friendId];
                      users.sort();
                      final chatRoomIdStr = "${users[0]}_${users[1]}";

                      return StreamBuilder<DocumentSnapshot>(
                        stream: _firestore
                            .collection("finalchatroom")
                            .doc(chatRoomIdStr)
                            .snapshots(),
                        builder: (context, chatSnapshot) {
                          String lastMessage = "Start a conversation";
                          DateTime? lastMessageTime;
                          int unreadCount = 0;
                          // bool hasChatData = false;

                          if (chatSnapshot.hasData &&
                              chatSnapshot.data!.exists) {
                            final chatData = chatSnapshot.data!.data()
                                as Map<String, dynamic>;
                            lastMessage = chatData['lastMessage'] ??
                                "Start a conversation";
                            final ts =
                                chatData['lastMessageTime'] as Timestamp?;
                            lastMessageTime = ts?.toDate();

                            final unreadMap = chatData['unreadCount']
                                    as Map<String, dynamic>? ??
                                {};
                            unreadCount = unreadMap[currentUserId] ?? 0;
                            // hasChatData = true;
                          }

                          return GestureDetector(
                            onTap: () {
                              // Reset unread count
                              _firestore
                                  .collection("finalchatroom")
                                  .doc(chatRoomIdStr)
                                  .update({
                                "unreadCount.${StaticData.mymodel!.userId}": 0,
                              }).catchError((e) {
                                debugPrint("Error updating unread: $e");
                              }); // Safe update

                              Get.toNamed(
                                RouteName.friendchatScreen,
                                arguments: {
                                  "chatroomId": chatRoomIdStr,
                                  "model": friendmodel,
                                },
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: unreadCount > 0
                                    ? Colors.deepPurple.withValues(alpha: 0.15)
                                    : Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: unreadCount > 0
                                      ? Colors.deepPurple.withValues(alpha: 0.3)
                                      : Colors.white.withValues(alpha: 0.05),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 28,
                                        backgroundColor: Colors.primaries[
                                            index % Colors.primaries.length],
                                        child: Text(
                                          friendmodel.friendname != null &&
                                                  friendmodel
                                                      .friendname!.isNotEmpty
                                              ? friendmodel.friendname![0]
                                                  .toUpperCase()
                                              : '?',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (unreadCount > 0)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(
                                              6,
                                            ),
                                            decoration: const BoxDecoration(
                                              color: Colors.redAccent,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              unreadCount > 9
                                                  ? "9+"
                                                  : "$unreadCount",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                friendmodel.friendname ??
                                                    "Unknown",
                                                style: GoogleFonts.outfit(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: unreadCount > 0
                                                      ? FontWeight.bold
                                                      : FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              formatLastMessageTime(
                                                lastMessageTime,
                                              ),
                                              style: TextStyle(
                                                color: unreadCount > 0
                                                    ? Colors.deepPurpleAccent
                                                    : Colors.white38,
                                                fontSize: 12,
                                                fontWeight: unreadCount > 0
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          lastMessage,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.outfit(
                                            color: unreadCount > 0
                                                ? Colors.white
                                                : Colors.white54,
                                            fontSize: 14,
                                            fontWeight: unreadCount > 0
                                                ? FontWeight.w500
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                              .animate(delay: (50 * index).ms)
                              .slideX(begin: 0.2, end: 0)
                              .fade();
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
