import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/static_data.dart';
import 'package:final_project/resources/route_name.dart';
import 'package:final_project/viewmodel/friend_model/search_chat_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SearchChatViewModel searchVM = Get.put(SearchChatViewModel());
  final TextEditingController searchController = TextEditingController();

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh friends when app comes back to foreground
      searchVM.manualRefresh();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh friends when screen becomes visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchVM.manualRefresh();
    });
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
                  // Add Friend Icon with Request Count Badge
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection("finalrequests")
                        .where("reciverId", isEqualTo: currentUserId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      int requestCount =
                          snapshot.hasData ? snapshot.data!.docs.length : 0;

                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteName.addfriendscreen);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.deepPurple.shade200),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const Icon(
                                Icons.person_add_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                              if (requestCount > 0)
                                Positioned(
                                  right: -8,
                                  top: -8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Text(
                                      requestCount > 9
                                          ? '9+'
                                          : requestCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ).animate().scale(delay: 200.ms);
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.01),

            // Search Bar
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
                    Expanded(
                      child: Obx(() => TextField(
                            controller: searchController,
                            onChanged: (value) {
                              searchVM.searchFriends(value);
                            },
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: searchVM.isSearching.value
                                  ? ''
                                  : 'Search chats...',
                              hintStyle: GoogleFonts.outfit(
                                color: Colors.white38,
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 12),
                            ),
                          )),
                    ),
                    Obx(() => searchVM.isSearching.value
                        ? GestureDetector(
                            onTap: () {
                              searchController.clear();
                              searchVM.clearSearch();
                            },
                            child: Icon(
                              Icons.clear_rounded,
                              color: Colors.white38,
                              size: 20,
                            ),
                          )
                        : const SizedBox.shrink()),
                  ],
                ),
              ),
            ).animate().slideY(begin: 0.2, end: 0, delay: 100.ms).fade(),

            SizedBox(height: height * 0.02),

            // Friend List
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await searchVM.manualRefresh();
                },
                color: Colors.deepPurpleAccent,
                backgroundColor: Colors.white10,
                child: Obx(() {
                  final friends = searchVM.filteredFriends;

                  if (friends.isEmpty && !searchVM.isSearching.value) {
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

                  if (friends.isEmpty && searchVM.isSearching.value) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 60,
                            color: Colors.white24,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "No chats found",
                            style: GoogleFonts.outfit(
                              color: Colors.white38,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fade();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: friends.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final friendmodel = friends[index];
                      final friendId = friendmodel.friendId!;

                      // Generate ChatRoomID
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
                            }

                            return GestureDetector(
                              onTap: () {
                                // Reset unread count
                                _firestore
                                    .collection("finalchatroom")
                                    .doc(chatRoomIdStr)
                                    .update({
                                  "unreadCount.${StaticData.mymodel!.userId}":
                                      0,
                                }).catchError((e) {
                                  debugPrint("Error updating unread: $e");
                                });

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
                                      ? Colors.deepPurple
                                          .withValues(alpha: 0.15)
                                      : Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: unreadCount > 0
                                        ? Colors.deepPurple
                                            .withValues(alpha: 0.3)
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
                                            bottom: 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: const BoxDecoration(
                                                color: Colors.green,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                          SizedBox(height: height * 0.002),
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
                              )
                                  .animate(delay: (50 * index).ms)
                                  .slideX(begin: 0.2, end: 0)
                                  .fade(),
                            );
                          });
                    },
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
