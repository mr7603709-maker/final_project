import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/friend_model.dart';
import 'package:final_project/model/request_model.dart';
import 'package:final_project/model/signup_model.dart';
import 'package:final_project/model/static_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class AddfriendScreen extends StatefulWidget {
  const AddfriendScreen({super.key});

  @override
  State<AddfriendScreen> createState() => _AddfriendScreenState();
}

class _AddfriendScreenState extends State<AddfriendScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchText = "";

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchText = searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We'll trust the parent or global theme, but for this standalone screen we ensure dark/premium feel
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A), // Deep dark background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Find Friends',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.02),

              // Search Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.amber,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search for people...',
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                        icon: Icon(
                          Icons.search_rounded,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                ),
              ).animate().slideY(begin: -0.5, end: 0).fade(),

              SizedBox(height: height * 0.04),

              // Friend Requests Section
              _buildSectionHeader("Friend Requests"),
              SizedBox(height: height * 0.02),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("finalrequests")
                    .where(
                      "reciverId",
                      isEqualTo: StaticData.mymodel?.userId ?? "",
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptySection("No pending requests");
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      RequestModel reqmodel = RequestModel.fromMap(
                        snapshot.data!.docs[index].data(),
                      );
                      return _buildRequestCard(reqmodel)
                          .animate(delay: (100 * index).ms)
                          .slideX(begin: 0.5, end: 0)
                          .fade();
                    },
                  );
                },
              ),

              SizedBox(height: height * 0.04),

              // Find Friends Section
              _buildSectionHeader("Suggested People"),
              SizedBox(height: height * 0.02),

              // We need a constrained height for this list or use shrinkWrap if list is small.
              // Since it filters locally, it might be safer to use shrinkWrap or a fixed container if large.
              // Assuming moderate number of users, shrinkWrap is fine inside SingleChildScrollView.
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("finalUsers")
                    .where(
                      "email",
                      isNotEqualTo: StaticData.mymodel?.email ?? "",
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (StaticData.mymodel == null) return const SizedBox();
                  if (!snapshot.hasData)
                    return const Center(child: CircularProgressIndicator());

                  List<UserData> users = snapshot.data!.docs
                      .map((doc) => UserData.fromMap(doc.data()))
                      .where(
                        (user) =>
                            user.name != null &&
                            user.name!.toLowerCase().contains(searchText),
                      )
                      .toList();

                  if (users.isEmpty) {
                    return _buildEmptySection("No users found");
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return _buildUserCard(users[index], height, width)
                          .animate(delay: (50 * index).ms)
                          .slideY(begin: 0.2, end: 0)
                          .fade();
                    },
                  );
                },
              ),

              SizedBox(height: height * 0.1), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ).animate().fade(delay: 200.ms);
  }

  Widget _buildEmptySection(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(text,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.4))),
    ).animate().fade();
  }

  Widget _buildRequestCard(RequestModel reqmodel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.indigoAccent,
            child: Text(
              reqmodel.senderName != null && reqmodel.senderName!.isNotEmpty
                  ? reqmodel.senderName![0].toUpperCase()
                  : '?',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              reqmodel.senderName ?? "Unknown",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),

          // Accept Button
          GestureDetector(
            onTap: () async {
              var uid = const Uuid();
              String fdId = uid.v4();
              FriendModel fdmodel = FriendModel(
                friendname: reqmodel.senderName,
                friendId: reqmodel.senderId,
                userId: reqmodel.reciverId,
                fdId: fdId,
              );
              await FirebaseFirestore.instance
                  .collection("finalfriends")
                  .doc(fdId)
                  .set(fdmodel.toMap());

              String fd2Id = uid.v4();
              FriendModel friend = FriendModel(
                friendname: reqmodel.reciverName,
                friendId: reqmodel.reciverId,
                userId: reqmodel.senderId,
                fdId: fd2Id,
              );
              await FirebaseFirestore.instance
                  .collection("finalfriends")
                  .doc(fd2Id)
                  .set(friend.toMap());

              await FirebaseFirestore.instance
                  .collection("finalrequests")
                  .doc(reqmodel.reqId)
                  .delete();
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade600, Colors.teal.shade600],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check, color: Colors.white, size: 16),
                  SizedBox(width: 5),
                  Text(
                    "Accept",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(UserData model, double height, double width) {
    if (model.userId == null || model.userId!.isEmpty) {
      return const SizedBox();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("finalrequests")
          .where("senderId", isEqualTo: StaticData.mymodel?.userId ?? "")
          .where("reciverId", isEqualTo: model.userId)
          .snapshots(),
      builder: (context, reqSnap) {
        bool requested = reqSnap.hasData && reqSnap.data!.docs.isNotEmpty;
        String? reqId = requested ? reqSnap.data!.docs.first["reqId"] : null;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.transparent, // Minimalist list
            border: Border(
              bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.blueGrey.shade800,
                child: Text(
                  model.name != null && model.name!.isNotEmpty
                      ? model.name![0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  model.name ?? "Unknown",
                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 16),
                ),
              ),

              // Add/Cancel Button
              GestureDetector(
                onTap: () async {
                  if (requested) {
                    await FirebaseFirestore.instance
                        .collection("finalrequests")
                        .doc(reqId)
                        .delete();
                  } else {
                    var uid = const Uuid();
                    String newReqId = uid.v4();
                    RequestModel reqModel = RequestModel(
                      senderId: StaticData.mymodel!.userId,
                      senderName: StaticData.mymodel!.name,
                      reqId: newReqId,
                      reciverId: model.userId,
                      reciverName: model.name,
                    );
                    await FirebaseFirestore.instance
                        .collection("finalrequests")
                        .doc(newReqId)
                        .set(reqModel.toMap());
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(
                    horizontal: requested ? 15 : 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: requested
                        ? Colors.red.withValues(alpha: 0.2)
                        : Colors.deepPurple.shade700,
                    borderRadius: BorderRadius.circular(20),
                    border: requested
                        ? Border.all(color: Colors.red.withValues(alpha: 0.5))
                        : null,
                  ),
                  child: Text(
                    requested ? "Cancel" : "Add",
                    style: GoogleFonts.outfit(
                      color: requested ? Colors.red.shade200 : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
