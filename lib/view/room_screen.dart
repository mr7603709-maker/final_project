import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/static_data.dart';
import 'package:final_project/resources/route_name.dart';
import 'package:final_project/viewmodel/room_model/room_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final RoomViewModel roomVM = Get.put(RoomViewModel());
  final PageController _pageController = PageController(viewportFraction: 0.85);
  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  // Curated Hindi Songs
  final List<Map<String, String>> _trendingSongs = [
    {
      'title': 'Kesariya',
      'artist': 'Arijit Singh',
      'videoId': 'BddP6PYo2gs',
      'thumbnail': 'https://img.youtube.com/vi/BddP6PYo2gs/maxresdefault.jpg'
    },
    {
      'title': 'Apna Bana Le',
      'artist': 'Arijit Singh',
      'videoId': 'ElZfdU54Cp8',
      'thumbnail': 'https://img.youtube.com/vi/ElZfdU54Cp8/maxresdefault.jpg'
    },
    {
      'title': 'Jhoome Jo Pathaan',
      'artist': 'Vishal-Shekhar',
      'videoId': 'YxWlaYCA8MU',
      'thumbnail': 'https://img.youtube.com/vi/YxWlaYCA8MU/maxresdefault.jpg'
    },
    {
      'title': 'Maan Meri Jaan',
      'artist': 'King',
      'videoId': 'VuG7ge_8I2Y',
      'thumbnail': 'https://img.youtube.com/vi/VuG7ge_8I2Y/maxresdefault.jpg'
    },
  ];

  @override
  void initState() {
    super.initState();
    roomVM.loadRooms();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final String currentUserId = StaticData.mymodel?.userId ?? '';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Discover',
                        style: GoogleFonts.outfit(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Music & Rooms',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ).animate().slideX(begin: -0.2, end: 0).fade(),
                  GestureDetector(
                    onTap: () => _showAddRoomDialog(context, roomVM),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.blueAccent.withOpacity(0.5)),
                      ),
                      child: const Icon(Icons.add_rounded,
                          color: Colors.white, size: 28),
                    ),
                  ).animate().scale(delay: 200.ms),
                ],
              ),
            ),

            // Carousel Section
            SizedBox(
              height: height * 0.28,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => _currentPage.value = index,
                itemCount: _trendingSongs.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_pageController.position.haveDimensions) {
                        value = _pageController.page! - index;
                        value = (1 - (value.abs() * 0.2)).clamp(0.0, 1.0);
                      }
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: GestureDetector(
                      onTap: () => _playVideo(
                          context, _trendingSongs[index]['videoId']!),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                            image: NetworkImage(
                                _trendingSongs[index]['thumbnail']!),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.8)
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.play_arrow_rounded,
                                    color: Colors.white, size: 30),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _trendingSongs[index]['title']!,
                                    style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _trendingSongs[index]['artist']!,
                                    style: GoogleFonts.outfit(
                                        color: Colors.white70, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ).animate().slideY(begin: 0.2, end: 0).fade(),

            const SizedBox(height: 10),

            // Filters
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text("Explore Rooms",
                      style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Obx(() => _buildMicroFilter(
                        "Public",
                        roomVM.roomType.value ==
                            'public', // Public button selected if roomType is 'public'
                        () => roomVM.setPublic(),
                      )),
                  const SizedBox(width: 10),
                  Obx(() => _buildMicroFilter(
                        "Private",
                        roomVM.roomType.value ==
                            'private', // Private button selected if roomType is 'private'
                        () => roomVM.setPrivate(),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Room List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('finalrooms')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptyState();
                  }

                  // Wrap the ListView in Obx so it reacts to roomVM.roomType changes
                  return Obx(() {
                    final filteredRooms = snapshot.data!.docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>? ?? {};
                      final bool isPrivate = data['private'] ?? false;
                      final String adminId = data['adminId'] ?? '';
                      final members = data['members'] != null
                          ? List<String>.from(
                              (data['members'] as List<dynamic>))
                          : <String>[];

                      if (roomVM.roomType.value == 'public') {
                        return !isPrivate;
                      } else {
                        final currentUserId = StaticData.mymodel?.userId ?? '';
                        return isPrivate &&
                            (adminId == currentUserId ||
                                members.contains(currentUserId));
                      }
                    }).toList();

                    if (filteredRooms.isEmpty) return _buildEmptyState();

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                          bottom: 100, left: 20, right: 20, top: 10),
                      itemCount: filteredRooms.length,
                      itemBuilder: (context, index) {
                        final room = filteredRooms[index];
                        final roomData =
                            room.data() as Map<String, dynamic>? ?? {};
                        return _buildRoomCard(roomData,
                                MediaQuery.of(context).size.width, room.id)
                            .animate(delay: (50 * index).ms)
                            .slideY(begin: 0.2)
                            .fade();
                      },
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

 void _playVideo(BuildContext context, String videoId) {
  final YoutubePlayerController controller = YoutubePlayerController(
    initialVideoId: videoId,
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
      controlsVisibleAtStart: true,
      hideControls: false,
      enableCaption: true,
    ),
  );

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: true,
            onReady: () {
              // Optional: do something when ready
            },
          ),
        ),
      );
    },
  );
}


  Widget _buildMicroFilter(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isSelected ? Colors.black : Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded,
              size: 60, color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 10),
          Text("No Rooms Found",
              style: GoogleFonts.outfit(color: Colors.white54, fontSize: 18)),
        ],
      ),
    ).animate().fade();
  }

  Widget _buildRoomCard(
      Map<String, dynamic> data, double width, String roomId) {
    final roomName = data['roomName'] ?? 'Room';
    final creatorName = data['adminName'] ?? 'Admin';
    final creatorImage = data['adminImage'];

    return GestureDetector(
      onTap: () => Get.toNamed(RouteName.chatroomscreen,
          arguments: {'roomId': roomId, 'roomName': roomName}),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blueAccent)),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.black26,
                backgroundImage: (creatorImage != null && creatorImage != '')
                    ? NetworkImage(creatorImage)
                    : null,
                child: (creatorImage == null || creatorImage == '')
                    ? Text(
                        creatorName.isNotEmpty
                            ? creatorName[0].toUpperCase()
                            : 'A',
                        style: const TextStyle(color: Colors.white))
                    : null,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(roomName,
                      style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600)),
                  Text("by $creatorName",
                      style: GoogleFonts.outfit(
                          color: Colors.white54, fontSize: 13)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward_rounded,
                  color: Colors.white, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddRoomDialog(BuildContext context, RoomViewModel roomVM) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white12),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Create or Join",
                      style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  _buildDialogButton(
                      icon: Icons.add_circle_outline,
                      text: "Create New Room",
                      color: Colors.deepPurple,
                      onTap: () {
                        Navigator.pop(context);
                        _showCreateRoomInput(context, roomVM);
                      }),
                  const SizedBox(height: 10),
                  _buildDialogButton(
                      icon: Icons.login_rounded,
                      text: "Join Existing Room",
                      color: Colors.teal,
                      onTap: () {
                        Navigator.pop(context);
                        _showJoinRoomInput(context);
                      }),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
                .animate(
                    CurvedAnimation(parent: anim1, curve: Curves.easeOutBack)),
            child: child);
      },
    );
  }

  Widget _buildDialogButton(
      {required IconData icon,
      required String text,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.5))),
        child: Row(children: [
          Icon(icon, color: color.withOpacity(0.8)),
          const SizedBox(width: 15),
          Text(text,
              style: GoogleFonts.outfit(color: Colors.white, fontSize: 16)),
          const Spacer(),
          const Icon(Icons.arrow_forward_rounded,
              color: Colors.white30, size: 18)
        ]),
      ),
    );
  }

  void _showCreateRoomInput(BuildContext context, RoomViewModel roomVM) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("New Room",
                  style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                  onChanged: (val) => roomVM.newRoomName.value = val,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: "Enter room name...",
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none))),
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Private Room",
                    style: GoogleFonts.outfit(color: Colors.white70)),
                Obx(() => Switch(
                    value: roomVM.isPrivateRoom.value,
                    onChanged: (val) => roomVM.togglePrivate(),
                    activeColor: Colors.deepPurple))
              ]),
              const SizedBox(height: 20),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () async {
                        await roomVM.createRoom();
                        Get.back();
                      },
                      child: Text("Create Room",
                          style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)))),
            ],
          ),
        ),
      ),
    );
  }

  void _showJoinRoomInput(BuildContext context) {
    final TextEditingController joinController = TextEditingController();
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Join Room",
                  style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                  controller: joinController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: "Enter room ID...",
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none))),
              const SizedBox(height: 20),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        Get.back();
                        roomVM.joinRoom(joinController.text.trim());
                      },
                      child: Text("Join Room",
                          style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)))),
            ],
          ),
        ),
      ),
    );
  }
}
