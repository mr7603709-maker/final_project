import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/static_data.dart';
import 'package:final_project/view/video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatRoomscreen extends StatefulWidget {
  const ChatRoomscreen({super.key});

  @override
  State<ChatRoomscreen> createState() => _ChatRoomscreenState();
}

class _ChatRoomscreenState extends State<ChatRoomscreen> {
  final TextEditingController msgController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController scrollController = ScrollController();

  String roomId = "";
  String roomName = "";

  // Video Player
  YoutubePlayerController? _videoController;
  String? currentVideoId;
  StreamSubscription<DocumentSnapshot>? _roomSubscription;

  @override
  void dispose() {
    _roomSubscription?.cancel();
    _videoController
        ?.close(); // Note: close() instead of dispose() for iframe controller usually
    msgController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Retrieve arguments from GetX
    final args = Get.arguments;
    if (args != null && args is Map) {
      roomId = args['roomId'] ?? "";
      roomName = args['roomName'] ?? "Room Chat";
    }

    if (roomId.isNotEmpty) {
      _listenToRoomUpdates();
    }
  }

  void _listenToRoomUpdates() {
    _roomSubscription = _firestore
        .collection('finalrooms')
        .doc(roomId)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) return;

      var roomData = snapshot.data() as Map<String, dynamic>;
      String? activeVideo = roomData['activeVideo'];
      String newVideoId =
          YoutubePlayerController.convertUrlToId(activeVideo ?? "") ?? "";

      if (newVideoId.isNotEmpty) {
        if (newVideoId != currentVideoId) {
          // New video started
          currentVideoId = newVideoId;

          if (_videoController != null) {
            _videoController!.loadVideoById(videoId: newVideoId);
          } else {
            _videoController = YoutubePlayerController.fromVideoId(
              videoId: newVideoId,
              autoPlay:
                  false, // Disabled autoplay to prevent browser blocking errors
              params: const YoutubePlayerParams(
                showControls: true,
                showFullscreenButton: true,
                strictRelatedVideos: true,
              ),
            );
          }

          if (mounted) setState(() {});
        }
      } else {
        // Video closed
        if (_videoController != null) {
          _videoController!.close();
          _videoController = null;
          currentVideoId = null;
          if (mounted) setState(() {});
        }
      }
    });
  }

  // -------------------- SEND MESSAGE --------------------
  // -------------------- SEND MESSAGE --------------------
  void onsendMessage(String msg, {String type = 'txt'}) async {
    if (msg.isNotEmpty && roomId.isNotEmpty) {
      Map<String, dynamic> messageData = {
        "sendBy": StaticData.mymodel!.userId,
        "senderName": StaticData.mymodel!.name ?? "Unknown",
        "senderImage": StaticData.mymodel!.profileImage ?? "",
        "message": msg,
        "type": type,
        "time": FieldValue.serverTimestamp(),
      };

      // Check for YouTube link
      String? videoId = YoutubePlayerController.convertUrlToId(msg);
      bool isVideoLink = videoId != null && videoId.isNotEmpty;

      if (isVideoLink) {
        await _firestore.collection('finalrooms').doc(roomId).update(
            {'activeVideo': msg, 'lastMessage': '🎥 Started a Watch Party'});
        messageData['type'] = 'video';
      } else {
        await _firestore.collection('finalrooms').doc(roomId).update({
          "lastMessage": isVideoLink ? '🎥 Started a Watch Party' : msg,
          "lastMessageTime": FieldValue.serverTimestamp(),
        });
      }

      await _firestore
          .collection('finalrooms')
          .doc(roomId)
          .collection('messages')
          .add(messageData);

      if (type == 'txt') {
        msgController.clear();
      }
    }
  }

  String formatTime(DateTime dt) {
    return DateFormat('hh:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    if (roomId.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "Room ID not found.\nPlease go back and rejoin.",
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Premium Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1A1A2E), // Dark Navy
                    const Color(0xFF16213E), // Dark Blue
                    const Color(0xFF0F3460), // Deep Blue
                  ],
                ),
              ),
            ),
          ),

          // Animated Shapes
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withValues(alpha: 0.2),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 80,
                    color: Colors.purple.withValues(alpha: 0.2),
                  ),
                ],
              ),
            ),
          ).animate().scale(
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOut,
              ),

          SafeArea(
            child: Column(
              children: [
                // -------------------- APP BAR --------------------
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white70,
                        ),
                        onPressed: () => Get.back(),
                      ),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.deepPurple,
                        child: Text(
                          roomName.isNotEmpty ? roomName[0].toUpperCase() : 'R',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              roomName,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "Active Room",
                              style: GoogleFonts.outfit(
                                color: Colors.greenAccent,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().slideY(begin: -1, end: 0),

                // -------------------- SHARED VIDEO PLAYER --------------------
                if (_videoController != null)
                  Container(
                    height: 220,
                    width: double.infinity,
                    color: Colors.black,
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: YoutubePlayer(
                              controller: _videoController!,
                              aspectRatio: 16 / 9,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              _firestore
                                  .collection('finalrooms')
                                  .doc(roomId)
                                  .update({'activeVideo': FieldValue.delete()});
                            },
                          ),
                        )
                      ],
                    ),
                  ),

                // -------------------- MESSAGES --------------------
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('finalrooms')
                        .doc(roomId)
                        .collection('messages')
                        .orderBy("time", descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // Auto scroll
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 20,
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final data = snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                            return _buildMessageBubble(data);
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),

                // -------------------- INPUT --------------------
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                    border: Border(
                      top: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1)),
                    ),
                  ),
                  child: Row(
                    children: [
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
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type a message...",
                              hintStyle: GoogleFonts.outfit(
                                color: Colors.white38,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => _showVideoInput(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.movie_creation_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ).animate().scale(curve: Curves.elasticOut),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => onsendMessage(msgController.text),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.deepPurple, Colors.blue],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ).animate().scale(curve: Curves.elasticOut),
                    ],
                  ),
                ).animate().slideY(begin: 1, end: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> data) {
    bool isMe = data['sendBy'] == StaticData.mymodel!.userId;
    String senderName = data['senderName'] ?? "Unknown";
    String message = data['message'] ?? "";
    String type = data['type'] ?? "txt";
    Timestamp? time = data['time'] as Timestamp?;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Name for others
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 4),
                child: Text(
                  senderName,
                  style: GoogleFonts.outfit(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            if (type == 'video')
              GestureDetector(
                onTap: () {
                  Get.to(() => VideoPlayerScreen(videoUrl: message));
                },
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.deepPurpleAccent.withValues(alpha: 0.5),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        YoutubePlayerController.convertUrlToId(message) != null
                            ? "https://img.youtube.com/vi/${YoutubePlayerController.convertUrlToId(message)}/0.jpg"
                            : "https://via.placeholder.com/150",
                      ),
                      fit: BoxFit.cover,
                      opacity: 0.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: isMe
                        ? const Radius.circular(20)
                        : const Radius.circular(0),
                    bottomRight: isMe
                        ? const Radius.circular(0)
                        : const Radius.circular(20),
                  ),
                  gradient: isMe
                      ? const LinearGradient(
                          colors: [Colors.deepPurple, Colors.indigo],
                        )
                      : LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.15),
                            Colors.white.withValues(alpha: 0.15),
                          ],
                        ),
                ),
                child: Text(
                  message,
                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 15),
                ),
              ),

            // Time
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
              child: Text(
                time != null ? formatTime(time.toDate()) : "Sending...",
                style: GoogleFonts.outfit(color: Colors.white30, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    ).animate().fade().slideX(begin: isMe ? 0.2 : -0.2, end: 0);
  }

  void _showVideoInput(BuildContext context) {
    final TextEditingController videoUrlController = TextEditingController();
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Watch Together",
                  style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: videoUrlController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Paste YouTube Link...",
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15)),
                  onPressed: () {
                    if (videoUrlController.text.isNotEmpty) {
                      _firestore.collection('finalrooms').doc(roomId).update({
                        'activeVideo': videoUrlController.text.trim(),
                        'lastMessage': '🎥 Started a Watch Party'
                      });
                      Get.back();
                    }
                  },
                  child: const Text("Start Watching",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
