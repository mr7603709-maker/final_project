// ignore_for_file: unused_field, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/friend_model.dart';
import 'package:final_project/model/static_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FriendchatScreen extends StatefulWidget {
  final String chatroomId;
  final FriendModel model;

  const FriendchatScreen({
    super.key,
    required this.chatroomId,
    required this.model,
  });

  @override
  State<FriendchatScreen> createState() => _FriendchatScreenState();
}

class _FriendchatScreenState extends State<FriendchatScreen> {
  TextEditingController msgController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _markMessagesAsRead(); // ✅ Mark unread messages as read when chat opens
  }

  // -------------------- SEND MESSAGE --------------------
  void onsendMessage(String msg, String type, {String? fileName}) async {
    if (msg.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendBy": StaticData.mymodel!.userId, // sender ID
        "message": msg,
        "filename": fileName,
        "type": type,
        "time": FieldValue.serverTimestamp(),
        "readBy": [StaticData.mymodel!.userId], // sender has read the message
      };

      // Add message to chats subcollection
      await _firestore
          .collection('finalchatroom')
          .doc(widget.chatroomId)
          .collection('chats')
          .add(messages);

      msgController.clear();

      // -------------------- UPDATE LAST MESSAGE --------------------
      await _firestore.collection('finalchatroom').doc(widget.chatroomId).set({
        "users": [StaticData.mymodel!.userId, widget.model.friendId],
        "lastMessage": msg,
        "lastMessageTime": FieldValue.serverTimestamp(),
        "lastMessageBy": StaticData.mymodel!.userId,
        // ✅ Increment unread for the other user
        "unreadCount": {
          widget.model.friendId!: FieldValue.increment(1),
          StaticData.mymodel!.userId: 0, // sender has read it
        },
      }, SetOptions(merge: true));
    } else {
      debugPrint("Enter Some Text");
    }
  }

  // -------------------- MARK UNREAD MESSAGES AS READ --------------------
  void _markMessagesAsRead() async {
    var where = _firestore
        .collection('finalchatroom')
        .doc(widget.chatroomId)
        .collection('chats')
        .where("readBy", arrayContains: StaticData.mymodel!.userId);
    QuerySnapshot unread = await where.get();

    for (var doc in unread.docs) {
      doc.reference.update({
        "readBy": FieldValue.arrayUnion([StaticData.mymodel!.userId]),
      });
    }
  }

  // -------------------- FORMAT TIME --------------------
  String formatTime(DateTime dt) {
    return DateFormat('hh:mm a').format(dt); // 12-hour AM/PM format
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withValues(alpha: 0.3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withValues(alpha: 0.3),
                    blurRadius: 100,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withValues(alpha: 0.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.2),
                    blurRadius: 100,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // -------------------- CUSTOM APP BAR --------------------
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    border: Border(bottom: BorderSide(color: Colors.white10)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white70,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blueGrey,
                        backgroundImage: AssetImage(
                          "images/profile.jpg",
                        ), // Should be NetworkImage if available
                        child: widget.model.friendname == null
                            ? Text("?", style: TextStyle(color: Colors.white))
                            : null,
                      ),
                       SizedBox(width:width*0.025),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.model.friendname ?? "Unknown",
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize:width*0.035,
                              color: Colors.white,
                            ),
                          ),
                          StreamBuilder<DocumentSnapshot>(
                            stream: _firestore
                                .collection('users')
                                .doc(widget.model.friendId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              String status = "Offline";
                              if (snapshot.hasData && snapshot.data!.exists) {
                                bool isOnline =
                                    snapshot.data!['isOnline'] ?? false;
                                status = isOnline ? "Online" : "Offline";
                              }
                              return Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                    
                                      shape: BoxShape.circle,
                                      color: status == "Online"
                                          ? Colors.greenAccent
                                          : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    status,
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      color: Colors.white60,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().slideY(begin: -1, end: 0, curve: Curves.easeOut),

                // -------------------- MESSAGES --------------------
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('finalchatroom')
                        .doc(widget.chatroomId)
                        .collection('chats')
                        .orderBy(
                          "time",
                          descending: false,
                        ) // messages sorted by time
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        // Auto scroll to last message
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (scrollController.hasClients) {
                            scrollController.animateTo(
                              scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        });

                        return ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> map =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            // Animate new messages
                            return messages(context, map)
                                .animate()
                                .fade(duration: 300.ms)
                                .slideY(
                                  begin: 0.2,
                                  end: 0,
                                  curve: Curves.easeOutQuad,
                                );
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),

                // -------------------- MESSAGE INPUT --------------------
                Container(
                  padding:  EdgeInsets.all(width*0.035),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    border: Border(top: BorderSide(color: Colors.white10)),
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        // Text Field
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: TextField(
                              controller: msgController,
                              style: const TextStyle(color: Colors.white),
                              minLines: 1,
                              maxLines: 4,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Write your message...",
                                hintStyle: GoogleFonts.outfit(
                                  color: Colors.white38,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Send Button
                        InkWell(
                          onTap: () {
                            onsendMessage(msgController.text, "txt");
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Colors.deepPurple,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurpleAccent,
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ).animate().scale(curve: Curves.elasticOut),
                        ),
                      ],
                    ),
                  ),
                ).animate().slideY(begin: 1, end: 0, curve: Curves.easeOut),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- MESSAGE WIDGET --------------------
  Widget messages(BuildContext context, Map<String, dynamic> map) {
    Size size = MediaQuery.of(context).size;

    // Check if the message is sent by current user
    bool isMyMessage = map['sendBy'] == StaticData.mymodel!.userId;

    return Container(
      width: size.width,
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      child: Column(
        crossAxisAlignment:
            isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            margin: isMyMessage
                ? const EdgeInsets.only(left: 50)
                : const EdgeInsets.only(right: 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: isMyMessage
                    ? const Radius.circular(20)
                    : const Radius.circular(0),
                bottomRight: isMyMessage
                    ? const Radius.circular(0)
                    : const Radius.circular(20),
              ),
              gradient: isMyMessage
                  ? const LinearGradient(
                      colors: [Colors.deepPurple, Colors.purpleAccent],
                    )
                  : LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.white.withValues(alpha: 0.1),
                      ],
                    ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Text(
              map['message'],
              style: GoogleFonts.outfit(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          // Time
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
            child: Text(
              map['time'] != null
                  ? formatTime((map['time'] as Timestamp).toDate())
                  : "Sending...",
              style: GoogleFonts.outfit(color: Colors.white38, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
