import 'package:final_project/model/static_data.dart';
import 'package:final_project/resources/route_name.dart';
import 'package:final_project/view/profile/image_view_screen.dart';
import 'package:final_project/viewmodel/profile_viewmodel/logout_model.dart';
import 'package:final_project/viewmodel/profile_viewmodel/profileimage_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final profileImageVM = Get.put(ProfileImageViewModel());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("My Profile",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background
          Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A1A2E),
                  Color(0xFF16213E),
                  Color(0xFF0F3460),
                ],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: height * 0.02),
                  // Profile Image
                  Obx(() {
                    ImageProvider? backgroundImage;
                    if (profileImageVM.selectedImage.value != null) {
                      backgroundImage =
                          FileImage(profileImageVM.selectedImage.value!);
                    } else if (StaticData.mymodel?.profileImage != null &&
                        StaticData.mymodel!.profileImage!.isNotEmpty) {
                      backgroundImage =
                          NetworkImage(StaticData.mymodel!.profileImage!);
                    }

                    return Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (profileImageVM.selectedImage.value != null) {
                              Get.to(() => ProfileImageViewScreen(
                                  localImage:
                                      profileImageVM.selectedImage.value));
                            } else if (backgroundImage != null) {
                              // Handle network image view if needed
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueAccent.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  )
                                ]),
                            child: CircleAvatar(
                              radius: width * 0.15,
                              backgroundImage: backgroundImage,
                              backgroundColor: Colors.white10,
                              child: (backgroundImage == null)
                                  ? Text(
                                      (StaticData.mymodel?.name != null &&
                                              StaticData
                                                  .mymodel!.name!.isNotEmpty)
                                          ? StaticData.mymodel!.name![0]
                                              .toUpperCase()
                                          : "?",
                                      style: TextStyle(
                                        fontSize: width * 0.12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showImagePicker(context);
                          },
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.blueAccent,
                            child: const Icon(Icons.camera_alt,
                                color: Colors.white, size: 18),
                          ),
                        ).animate().scale(delay: 500.ms),
                      ],
                    )
                        .animate()
                        .scale(duration: 600.ms, curve: Curves.easeOutBack);
                  }),

                  SizedBox(height: height * 0.02),
                  Text(
                    StaticData.mymodel?.name ?? "Guest User",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.06,
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),

                  Text(
                    StaticData.mymodel?.email ?? "No Email",
                    style: const TextStyle(color: Colors.white54),
                  ).animate().fadeIn(delay: 400.ms),

                  SizedBox(height: height * 0.05),

                  // Menu Items
                  _buildProfileTile(
                    context,
                    icon: Icons.person_outline_rounded,
                    title: "Edit Profile",
                    onTap: () => Get.toNamed(RouteName.editprofilescreen),
                    delay: 500.ms,
                  ),
                  _buildProfileTile(
                    context,
                    icon: Icons.lock_outline_rounded,
                    title: "Access & Security",
                    onTap: () => Get.toNamed(RouteName
                        .editprofilescreen), // Assuming same screen for simplicity
                    delay: 600.ms,
                  ),
                  _buildProfileTile(
                    context,
                    icon: Icons.delete_outline_rounded,
                    title: "Data Deletion",
                    onTap: () => Get.toNamed(RouteName.deleteaccountscreen),
                    delay: 700.ms,
                    isDestructive: true,
                  ),

                  SizedBox(height: height * 0.05),

                  // Logout Button
                  InkWell(
                    onTap: () {
                      UserPreferences.instance.logout(context);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Colors.redAccent.withOpacity(0.5)),
                      ),
                      child: const Center(
                        child: Text(
                          "Log Out",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, end: 0),

                  SizedBox(height: height * 0.05),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16213E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Change Profile Photo",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blueAccent),
              title: const Text("Take a photo",
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                profileImageVM.pickImage(source: ImageSource.camera);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: Colors.purpleAccent),
              title: const Text("Choose from gallery",
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                profileImageVM.pickImage(source: ImageSource.gallery);
              },
            ),
            if (profileImageVM.selectedImage.value != null)
              ListTile(
                leading:
                    const Icon(Icons.cloud_upload, color: Colors.greenAccent),
                title: const Text("Upload Photo",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  profileImageVM.uploadProfileImage();
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Duration delay,
    bool isDestructive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDestructive
                          ? Colors.red.withOpacity(0.1)
                          : Colors.blueAccent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon,
                        color: isDestructive
                            ? Colors.redAccent
                            : Colors.blueAccent,
                        size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: isDestructive ? Colors.redAccent : Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white30, size: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: delay).slideX(begin: 0.1, end: 0, delay: delay);
  }
}
