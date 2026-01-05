import 'package:final_project/customwidget/button_widget.dart';
import 'package:final_project/model/static_data.dart';
import 'package:final_project/viewmodel/profile_viewmodel/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final editprofileVM = Get.put(EditprofileViewModel());
  final formKey = GlobalKey<FormState>();

  // Password visibility
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: [
            Divider(color: Theme.of(context).colorScheme.primaryContainer),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                children: [
                  SizedBox(height: height * 0.08),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        // ---------------- Name ----------------
                        Obx(() => TextFormField(
                              controller: editprofileVM.nameController.value,
                              focusNode: editprofileVM.nameFocusNode.value,
                              cursorColor: Colors.amber,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer),
                              decoration: InputDecoration(
                                hintText:
                                    StaticData.mymodel?.name ?? 'Your name',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.025),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.025),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                ),
                              ),
                            )),
                        SizedBox(height: height * 0.03),

                        // ---------------- Email ----------------
                        Obx(() => TextFormField(
                              controller: editprofileVM.emailController.value,
                              focusNode: editprofileVM.emailFocusNode.value,
                              cursorColor: Colors.amber,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer),
                              decoration: InputDecoration(
                                hintText:
                                    StaticData.mymodel?.email ?? 'Your email',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.025),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.025),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                ),
                              ),
                            )),
                        SizedBox(height: height * 0.03),

                        // ---------------- Password ----------------
                        Obx(() => TextFormField(
                              controller:
                                  editprofileVM.passwordController.value,
                              focusNode: editprofileVM.passwordFocusNode.value,
                              cursorColor: Colors.amber,
                              obscureText: _obscurePassword,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer),
                              decoration: InputDecoration(
                                hintText: 'Enter new password',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.025),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.025),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.15),

                  // ---------------- Save Button ----------------
                  RoundedButtonWidget(
                    onPress: () async {
                      await editprofileVM.updateProfile(context);
                    },
                    title: 'Save',
                    textColor: Theme.of(context).colorScheme.primaryContainer,
                    buttonColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
