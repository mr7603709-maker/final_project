import 'package:final_project/customwidget/button_widget.dart';
import 'package:final_project/viewmodel/edit_profile.dart';
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
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: Text('Edit Profile'),
        centerTitle: true,
      ),

      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: [
            Divider(color: Theme.of(context).colorScheme.primaryContainer),
           
            Expanded(
              child: SizedBox(
                height: height,
                width: width,
                child: ListView(
                  children: [
                    Column(
                      children: [
                        SizedBox(height: height * 0.08),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Container(
                                width: width * 0.85,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    width * 0.025,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03,
                                  ),
                                  child: TextFormField(
                                    controller:
                                        editprofileVM.namecontroller.value,
                                    focusNode:
                                        editprofileVM.nameFocusNode.value,
                                    cursorColor: Colors.amber,
                                    decoration: InputDecoration(
                                      hintText: 'your name',
                                      hintStyle: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryContainer,
                                      ),

                                      border: InputBorder.none,
                                    ),
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.03),
                              Container(
                                width: width * 0.85,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    width * 0.025,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03,
                                  ),
                                  child: TextFormField(
                                    controller:
                                        editprofileVM.emailcontroller.value,
                                    focusNode:
                                        editprofileVM.emailFocusNode.value,
                                    cursorColor: Colors.amber,
                                    decoration: InputDecoration(
                                      hintText: 'your email',
                                      hintStyle: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryContainer,
                                      ),

                                      border: InputBorder.none,
                                    ),
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.03),
                              Container(
                                width: width * 0.85,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    width * 0.025,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03,
                                  ),
                                  child: TextFormField(
                                    controller:
                                        editprofileVM.passwordcontroller.value,
                                    focusNode:
                                        editprofileVM.passwordFocusNode.value,
                                    cursorColor: Colors.amber,
                                    decoration: InputDecoration(
                                      hintText: 'your password',
                                      hintStyle: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryContainer,
                                      ),

                                      border: InputBorder.none,
                                    ),
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.15),
                        RoundedButtonWidget(
                          onPress: () {},
                          title: 'Save',
                          textColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                          buttonColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
