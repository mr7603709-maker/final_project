import 'package:final_project/customwidget/button_widget.dart';
import 'package:final_project/model/static_data.dart';
import 'package:final_project/resources/route_name.dart';
import 'package:final_project/view/profile/image_view_screen.dart';
import 'package:final_project/viewmodel/profile_viewmodel/logout_model.dart';
import 'package:final_project/viewmodel/profile_viewmodel/profileimage_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: [
            Obx(() {
              return Stack(
                alignment: Alignment.bottomRight,
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(
                        () => ProfileImageViewScreen(
                          localImage: profileImageVM.selectedImage.value,
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: width * 0.1,

                      backgroundImage:
                          profileImageVM.selectedImage.value != null
                          ? FileImage(profileImageVM.selectedImage.value!)
                          : (StaticData.mymodel?.profileImage != null &&
                                    StaticData.mymodel!.profileImage!.isNotEmpty
                                ? NetworkImage(
                                    StaticData.mymodel!.profileImage!,
                                  )
                                : null),

                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,

                      child:
                          (profileImageVM.selectedImage.value == null &&
                              (StaticData.mymodel?.profileImage == null ||
                                  StaticData.mymodel!.profileImage!.isEmpty))
                          ? Text(
                              (StaticData.mymodel?.name != null &&
                                      StaticData.mymodel!.name!.isNotEmpty)
                                  ? StaticData.mymodel!.name![0].toUpperCase()
                                  : "?",
                              style: TextStyle(
                                fontSize: width * 0.08,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                  ),

                  CircleAvatar(
                    radius: width * 0.035,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer,
                    child: PopupMenuButton<int>(
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Theme.of(context).colorScheme.primary,
                        size: width * 0.04,
                      ),
                      onSelected: (value) async {
                        if (value == 0) {
                          await profileImageVM.pickImage(
                            source: ImageSource.camera,
                          );
                        } else if (value == 1) {
                          await profileImageVM.pickImage(
                            source: ImageSource.gallery,
                          );
                        } else if (value == 2) {
                          await profileImageVM.uploadProfileImage();
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 0, child: Text("Camera")),
                        PopupMenuItem(value: 1, child: Text("Gallery")),
                        if (profileImageVM.selectedImage.value != null)
                          PopupMenuItem(value: 2, child: Text("Upload")),
                      ],
                    ),
                  ),
                ],
              );
            }),
            SizedBox(height: height * 0.03),
            Text(
              StaticData.mymodel?.name ?? "",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
                letterSpacing: width * 0.003,
                fontSize: width * 0.045,
              ),
            ),
            SizedBox(height: height * 0.08),

            // Display name, Email, Password Rows
            buildProfileRow(
              context,
              icon: Icons.account_box_outlined,
              label: "Display name",
              onTap: () => Get.toNamed(RouteName.editprofilescreen),
            ),
            SizedBox(height: height * 0.04),
            buildProfileRow(
              context,
              icon: Icons.email_outlined,
              label: "Email",
              onTap: () => Get.toNamed(RouteName.editprofilescreen),
            ),
            SizedBox(height: height * 0.04),
            buildProfileRow(
              context,
              icon: Icons.lock_outline,
              label: "Password",
              onTap: () => Get.toNamed(RouteName.editprofilescreen),
            ),
            SizedBox(height: height * 0.05),

            // Logout Button
            RoundedButtonWidget(
              onPress: () {
                UserPreferences.instance.logout(context);
              },
              title: 'Log out',
              textColor: Theme.of(context).colorScheme.primaryContainer,
              buttonColor: Theme.of(context).colorScheme.onPrimary,
            ),
            SizedBox(height: height * 0.04),

            // Data Deletion Button
            InkWell(
              onTap: () {
                Get.toNamed(RouteName.deleteaccountscreen);
              },
              child: Container(
                height: height * 0.065,
                width: width * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * 0.02),
                  border: Border.all(color: Colors.red),
                ),
                child: Center(
                  child: Text(
                    "Data deletion",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: width * 0.035,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: height * 0.07,
        width: width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width * 0.02),
          border: Border.all(color: Theme.of(context).colorScheme.onPrimary),
        ),
        child: Row(
          children: [
            SizedBox(width: width * 0.03),
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onPrimary,
              size: width * 0.045,
            ),
            SizedBox(width: width * 0.015),
            SizedBox(
              width: width * 0.75,
              child: Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: width * 0.035,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
              size: width * 0.04,
            ),
          ],
        ),
      ),
    );
  }
}
