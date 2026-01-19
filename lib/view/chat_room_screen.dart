import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/room_model_class.dart';
import 'package:final_project/model/static_data.dart';
import 'package:final_project/view/video_player_screen.dart';
import 'package:final_project/viewmodel/room_model/delete_room_viewmodel.dart';
import 'package:final_project/viewmodel/room_model/share_link_viewmodel.dart';
import 'package:final_project/viewmodel/room_model/video_sync_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
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
  final RoomLinkViewModel linkVM = Get.put(RoomLinkViewModel());
  final RoomDeleteViewModel deleteVM = Get.put(RoomDeleteViewModel());

  late VideoSyncViewModel videoVM;

  String roomId = "";
  String roomName = "";
  String creatorId = "";
  bool isCurrentUserAdmin = false;

  // Video Player
  YoutubePlayerController? _videoController;
  String? currentVideoId;
  StreamSubscription<DocumentSnapshot>? _roomSubscription;
  
  // Reactive variable for video state
  final RxBool _hasVideo = false.obs;

  @override
  void dispose() {
    _roomSubscription?.cancel();
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    msgController.dispose();
    scrollController.dispose();
    // Dispose reactive variable
    _hasVideo.close();
    super.dispose();
  }

  void _videoListener() {
    if (_videoController == null) return;

    final isPlaying = _videoController!.value.isPlaying;
    final position = _videoController!.value.position.inSeconds.toDouble();

    // Update Firestore only if the user is controlling the video
    videoVM.updateState(play: isPlaying, pos: position);
  }

  @override
  void initState() {
    super.initState();

    // Get arguments from previous screen
    final args = Get.arguments;
    if (args != null && args is Map) {
      roomId = args['roomId'] ?? "";
      roomName = args['roomName'] ?? "Room Chat";
      creatorId = args['creatorId'] ?? "";

      // Check admin status for delete functionality
      deleteVM.checkAdminStatus(creatorId);
      isCurrentUserAdmin = deleteVM.isAdmin.value;
      
      // If not admin initially, try again after a short delay (in case user data loads later)
      if (!isCurrentUserAdmin) {
        Future.delayed(const Duration(milliseconds: 500), () {
          deleteVM.checkAdminStatus(creatorId);
          if (deleteVM.isAdmin.value && mounted) {
            setState(() {
              isCurrentUserAdmin = true;
            });
          }
        });
      }
      print("DEBUG: isCurrentUserAdmin set to: $isCurrentUserAdmin");
      
      // Trigger rebuild to show admin-specific UI
      if (mounted) {
        setState(() {});
      }

      // Set current room in RoomLinkViewModel
      linkVM.currentRoom.value = RoomModel(
        roomId: roomId,
        name: roomName,
        creatorId: args['creatorId'] ?? '',
        creatorName: args['creatorName'] ?? '',
        isPrivate: args['isPrivate'] ?? false,
        members:
            args['members'] != null ? List<String>.from(args['members']) : [],
      );
    }

    // Only setup video sync if roomId exists
    if (roomId.isNotEmpty) {
      videoVM = Get.put(VideoSyncViewModel(roomId), tag: roomId);
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
      String newVideoId = YoutubePlayer.convertUrlToId(activeVideo ?? "") ?? "";

      // No active video
      if (newVideoId.isEmpty) {
        if (_videoController != null) {
          _videoController!.removeListener(_videoListener);
          _videoController!.dispose();
          _videoController = null;
          currentVideoId = null;
          _hasVideo.value = false;
          if (mounted) setState(() {});
        }
        return;
      }

      // New video or first time
      if (newVideoId != currentVideoId) {
        currentVideoId = newVideoId;

        if (_videoController != null) {
          _videoController!.load(newVideoId);
          _videoController!.addListener(_videoListener);
        } else {
          // Create new controller
          _videoController = YoutubePlayerController(
            initialVideoId: newVideoId,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
              controlsVisibleAtStart: true,
              hideControls: false,
              enableCaption: true,
            ),
          );
          _videoController!.addListener(_videoListener);
        }

        _hasVideo.value = true;
        if (mounted) setState(() {});
      }
    });
  }
  void _confirmDeleteRoom() {
  Get.dialog(
    AlertDialog(
      backgroundColor: const Color(0xFF1E1E2C),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: const BorderSide(color: Colors.white12),
      ),
      title: const Text(
        "Delete Room?",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        "This action cannot be undone",
        style: TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white70),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: () {
            deleteVM.deleteRoom(
              roomId: roomId,
              creatorId: creatorId,
            );
          },
          child: const Text(
            "Delete",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}


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

      String? videoId = YoutubePlayer.convertUrlToId(msg);
      bool isVideoLink = videoId != null && videoId.isNotEmpty;

      if (isVideoLink) {
        await _firestore.collection('finalrooms').doc(roomId).update(
            {'activeVideo': msg, 'lastMessage': '🎥 Started a Watch Party'});
        messageData['type'] = 'video';
      } else {
        await _firestore.collection('finalrooms').doc(roomId).update({
          "lastMessage": msg,
          "lastMessageTime": FieldValue.serverTimestamp(),
        });
      }

      await _firestore
          .collection('finalrooms')
          .doc(roomId)
          .collection('messages')
          .add(messageData);

      if (type == 'txt') msgController.clear();
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
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1A1A2E),
                    const Color(0xFF16213E),
                    const Color(0xFF0F3460),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // AppBar
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white70),
                        onPressed: () => Get.back(),
                      ),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.deepPurple,
                        child: Text(
                          roomName.isNotEmpty ? roomName[0].toUpperCase() : 'R',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
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
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text("Active Room",
                                style: GoogleFonts.outfit(
                                    color: Colors.greenAccent, fontSize: 12)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                          onPressed: () {
                            linkVM.shareRoomLink(); // opens share dialog
                          },
                          icon: Icon(
                            Icons.share,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          )),
                      SizedBox(
                        width: 40,
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          onSelected: (value) {
                            if (value == 'copy') {
                              linkVM.copyRoomLink();
                            }

                            if (value == 'delete') {
                              _confirmDeleteRoom();
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'copy',
                              child: Row(
                                children: [
                                  Icon(Icons.link, size: 18),
                                  SizedBox(width: 8),
                                  Text("Copy Link"),
                                ],
                              ),
                            ),
                            if (isCurrentUserAdmin)
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, size: 18, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text("Delete Room",
                                        style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Shared Video
                _hasVideo.value && _videoController != null
                  ? SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: Container(
                      color: Colors.black,
                      child: Stack(
                        children: [
                          Center(
                            child: YoutubePlayer(
                              controller: _videoController!,
                              showVideoProgressIndicator: true,
                              aspectRatio: 16 / 9,
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
                              // Properly dispose video controller when closing
                              if (_videoController != null) {
                                _videoController!.removeListener(_videoListener);
                                _videoController!.dispose();
                                _videoController = null;
                                currentVideoId = null;
                              }
                                _hasVideo.value = false;
                                if (mounted) setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : const SizedBox.shrink(),
                // Messages
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
                              horizontal: 15, vertical: 20),
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
                // Input
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(25)),
                    border: Border(
                        top: BorderSide(color: Colors.white.withOpacity(0.1))),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: TextField(
                            controller: msgController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type a message...",
                              hintStyle:
                                  GoogleFonts.outfit(color: Colors.white38),
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
                              color: Colors.redAccent, shape: BoxShape.circle),
                          child: const Icon(Icons.movie_creation_outlined,
                              color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => onsendMessage(msgController.text),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.deepPurple, Colors.blue]),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.send_rounded,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
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
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 4),
                child: Text(senderName,
                    style: GoogleFonts.outfit(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
            if (type == 'video')
              GestureDetector(
                onTap: () => Get.to(() => VideoPlayerScreen(videoUrl: message)),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: Colors.deepPurpleAccent.withOpacity(0.5)),
                    image: DecorationImage(
                      image: NetworkImage(
                        YoutubePlayer.convertUrlToId(message) != null
                            ? "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(message)}/0.jpg"
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
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.play_arrow_rounded,
                        color: Colors.white, size: 40),
                  ),
                ),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                          colors: [Colors.deepPurple, Colors.indigo])
                      : LinearGradient(colors: [
                          Colors.white.withOpacity(0.15),
                          Colors.white.withOpacity(0.15)
                        ]),
                ),
                child: Text(message,
                    style:
                        GoogleFonts.outfit(color: Colors.white, fontSize: 15)),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
              child: Text(
                  time != null ? formatTime(time.toDate()) : "Sending...",
                  style:
                      GoogleFonts.outfit(color: Colors.white30, fontSize: 10)),
            ),
          ],
        ),
      ),
    );
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

