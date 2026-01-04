import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:final_project/model/static_data.dart';

class ProfileImageViewScreen extends StatelessWidget {
  final File? localImage;

  const ProfileImageViewScreen({super.key, this.localImage});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Profile Photo",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Hero(
          tag: "profile_image",
          child: localImage != null
              ? Image.file(localImage!, fit: BoxFit.contain)
              : (StaticData.mymodel?.profileImage != null &&
                    StaticData.mymodel!.profileImage!.isNotEmpty)
              ? Image.network(
                  StaticData.mymodel!.profileImage!,
                  fit: BoxFit.contain,
                )
              : CircleAvatar(
                  radius: width * 0.25,
                  backgroundColor: Colors.grey.shade700,
                  child: Text(
                    (StaticData.mymodel?.name != null &&
                            StaticData.mymodel!.name!.isNotEmpty)
                        ? StaticData.mymodel!.name![0].toUpperCase()
                        : "?",
                    style: TextStyle(
                      fontSize: width * 0.2,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
