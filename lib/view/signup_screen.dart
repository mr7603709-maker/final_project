// ignore_for_file: non_constant_identifier_names

import 'package:final_project/customwidget/button_widget.dart';
import 'package:final_project/utills/show_snackmessage.dart';
import 'package:final_project/viewmodel/signup_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final SignupVM = Get.put(SignupViewModel());
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('images/signup.png'),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.15),
              Text(
                "Sign Up",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.06,
                ),
              ),
              SizedBox(height: height * 0.01),
              Text(
                "Create Your Account",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  fontWeight: FontWeight.w500,
                  fontSize: width * 0.04,
                ),
              ),
              SizedBox(height: height * 0.15),
        
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      width: width * 0.85,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        borderRadius: BorderRadius.circular(width * 0.025),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                        child: TextFormField(
                          controller: SignupVM.nameController.value,
                          focusNode: SignupVM.nameFocusNode.value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              Utils.snackBar('Name', 'please enter name');
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            hintStyle: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Container(
                      width: width * 0.85,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        borderRadius: BorderRadius.circular(width * 0.025),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                        child: TextFormField(
                          controller: SignupVM.emailController.value,
                          focusNode: SignupVM.emailFocusNode.value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              Utils.snackBar(
                                'Email',
                                'please enter correct email',
                              );
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                            hintStyle: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Container(
                      width: width * 0.85,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        borderRadius: BorderRadius.circular(width * 0.025),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                        child: TextFormField(
                          controller: SignupVM.passwordController.value,
                          focusNode: SignupVM.passwordFocusNode.value,
                          obscureText: true,
                          obscuringCharacter: '*',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              Utils.snackBar(
                                'Password',
                                'please enter correct password',
                              );
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your password',
                            hintStyle: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.2),
              Obx(
                () => RoundedButtonWidget(
                  width: width * 0.85,
                  buttonColor: Theme.of(context).colorScheme.primaryContainer,
                  title: 'Sign up',
                  loading: SignupVM.loading.value,
                  onPress: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
