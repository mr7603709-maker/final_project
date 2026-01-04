// ignore_for_file: unused_field, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/friend_model.dart';
import 'package:final_project/model/static_data.dart';
import 'package:flutter/material.dart';
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
      print("Enter Some Text");
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
  // Add this function here
  String formatTime(DateTime dt) {
    return DateFormat('hh:mm a').format(dt); // 12-hour AM/PM format
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: width * 0.05,
              backgroundImage: AssetImage("images/profile.jpg"),
            ),
            SizedBox(width: width * 0.02),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.model.friendname!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.035,
                  ),
                ),
                StreamBuilder<DocumentSnapshot>(
                  stream: _firestore
                      .collection('users')
                      .doc(widget.model.friendId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.exists) {
                      bool isOnline = snapshot.data!['isOnline'] ?? false;
                      return Text(
                        isOnline ? "Online" : "Offline",
                        style: TextStyle(fontSize: width * 0.025),
                      );
                    } else {
                      return Text(
                        "Offline",
                        style: TextStyle(fontSize: width * 0.025),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Divider(color: Theme.of(context).colorScheme.primaryContainer),

          // -------------------- MESSAGES --------------------
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('finalchatroom')
                  .doc(widget.chatroomId)
                  .collection('chats')
                  .orderBy("time", descending: false) // messages sorted by time
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  // Auto scroll to last message
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (scrollController.hasClients) {
                      scrollController.jumpTo(
                        scrollController.position.maxScrollExtent,
                      );
                    }
                  });

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> map =
                          snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;
                      return messages(context, map);
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),

          // -------------------- MESSAGE INPUT --------------------
          Container(
            height: height * 0.09,
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(width * 0.03),
                    ),
                    child: TextField(
                      controller: msgController,
                      minLines: 1,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Write your message",
                      ),
                    ),
                  ),
                ),

                SizedBox(width: width * 0.02),
                InkWell(
                  onTap: () {
                    onsendMessage(msgController.text, "txt");
                  },
                  child: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer,
                    radius: width * 0.055,
                    child: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- MESSAGE WIDGET --------------------
  /// ✅ Message widget for text-only chat bubbles
  Widget messages(BuildContext context, Map<String, dynamic> map) {
    Size size = MediaQuery.of(context).size;

    // ✅ Check if the message is sent by current user
    bool isMyMessage = map['sendBy'] == StaticData.mymodel!.userId;

    // ✅ Text message bubble
    Widget messageContent = Container(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isMyMessage ? Colors.black : Colors.grey[200],
      ),
      child: Text(
        map['message'],
        style: TextStyle(
          fontSize: 14,
          color: isMyMessage ? Colors.white : Colors.black,
        ),
      ),
    );

    return Container(
      width: size.width,
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: messageContent,
    );
  }
}
