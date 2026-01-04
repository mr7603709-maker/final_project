import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/friend_model.dart';
import 'package:final_project/model/static_data.dart';
import 'package:final_project/resources/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
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
    List<String> users = [user1, user2];
    users.sort();
    return "${users[0]}_${users[1]}";
  }

  // -------------------- FORMAT TIME --------------------
  String formatLastMessageTime(DateTime? dt) {
    if (dt == null) return "";

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dt.year, dt.month, dt.day);

    if (messageDate == today) {
      // Today → show time
      return DateFormat('hh:mm a').format(dt);
    } else {
      // Older → show date
      return DateFormat('dd/MM/yyyy').format(dt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    // -------------------- CHECK USER LOGGED IN --------------------
    if (StaticData.mymodel == null) {
      return const Scaffold(body: Center(child: Text("User not logged in")));
    }

    final currentUserId = StaticData.mymodel!.userId;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: const Text('Chats'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Get.toNamed(RouteName.addfriendscreen);
            },
            child: CircleAvatar(
              child: Icon(Icons.person_add_alt, size: width * 0.05),
            ),
          ),
          SizedBox(width: width * 0.05),
        ],
      ),

      // -------------------- BODY --------------------
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: [
            Divider(color: Theme.of(context).colorScheme.primaryContainer),

            // -------------------- FRIEND LIST --------------------
            Expanded(
              child: SizedBox(
                width: width * 0.98,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _firestore
                      .collection("finalfriends")
                      .where("userId", isEqualTo: currentUserId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text("Something went wrong"));
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No friends found"));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        FriendModel friendmodel = FriendModel.fromMap(
                          snapshot.data!.docs[index].data(),
                        );

                        final friendId = friendmodel.friendId;
                        if (friendId == null)
                          return const SizedBox(); // skip invalid

                        // -------------------- CHATROOM ID --------------------
                        final chatRoomIdStr = chatRoomId(
                          currentUserId!,
                          friendId,
                        );

                        // -------------------- CHATROOM STREAM --------------------
                        return StreamBuilder<DocumentSnapshot>(
                          stream: _firestore
                              .collection("finalchatroom")
                              .doc(chatRoomIdStr)
                              .snapshots(),
                          builder: (context, chatSnapshot) {
                            String lastMessage = "";
                            DateTime? lastMessageTime;
                            int unreadCount = 0;

                            if (chatSnapshot.hasData &&
                                chatSnapshot.data!.exists) {
                              final data =
                                  chatSnapshot.data!.data()
                                      as Map<String, dynamic>;

                              lastMessage = data['lastMessage'] ?? "";
                              final ts = data['lastMessageTime'] as Timestamp?;
                              lastMessageTime = ts?.toDate();

                              // ✅ Unread messages for current user
                              final unreadMap =
                                  data['unreadCount']
                                      as Map<String, dynamic>? ??
                                  {};
                              unreadCount = unreadMap[currentUserId] ?? 0;
                            }

                            return InkWell(
                              onTap: () {
                                // ✅ Reset unread count when opening chat
                                _firestore
                                    .collection("finalchatroom")
                                    .doc(chatRoomIdStr)
                                    .update({
                                      "unreadCount.${StaticData.mymodel!.userId}":
                                          0,
                                    });

                                // ✅ Open FriendChatScreen

                                Get.toNamed(
                                  RouteName.friendchatScreen,
                                  arguments: {
                                    "chatroomId": chatRoomIdStr,
                                    "model": friendmodel,
                                  },
                                );
                              },
                              child: SizedBox(
                                height: height * 0.1,
                                width: width * 0.98,
                                child: Row(
                                  children: [
                                    // -------------------- FRIEND AVATAR --------------------
                                    CircleAvatar(
                                      radius: width * 0.055,
                                      backgroundColor: index % 2 == 0
                                          ? Colors.purple
                                          : Colors.green,
                                      child: Text(
                                        friendmodel.friendname != null &&
                                                friendmodel
                                                    .friendname!
                                                    .isNotEmpty
                                            ? friendmodel.friendname![0]
                                                  .toUpperCase()
                                            : '?',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: width * 0.03,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width * 0.02),

                                    // -------------------- FRIEND INFO --------------------
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // ✅ Friend Name
                                              Text(
                                                friendmodel.friendname ?? "",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: width * 0.038,
                                                ),
                                              ),

                                              // ✅ Last Message Time
                                              Text(
                                                lastMessage.isNotEmpty
                                                    ? formatLastMessageTime(
                                                        lastMessageTime,
                                                      )
                                                    : "",

                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: width * 0.025,
                                                ),
                                              ),
                                            ],
                                          ),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // ✅ Last Message
                                              Expanded(
                                                child: Text(
                                                  lastMessage.isNotEmpty
                                                      ? lastMessage
                                                      : "Say hi!",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimaryContainer,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: width * 0.03,
                                                  ),
                                                ),
                                              ),

                                              // ✅ Unread Count
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: unreadCount > 0
                                                    ? Container(
                                                        padding: EdgeInsets.all(
                                                          width * 0.01,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                              color: Colors.red,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                        child: Text(
                                                          "$unreadCount",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                width * 0.02,
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox.shrink(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
