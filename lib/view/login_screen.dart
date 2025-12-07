// ignore_for_file: non_constant_identifier_names

import 'package:final_project/customwidget/button_widget.dart';
import 'package:final_project/resources/route_name.dart';
import 'package:final_project/utills/show_snackmessage.dart';
import 'package:final_project/viewmodel/login_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginVM = Get.put(LoginViewModel());
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
              image:AssetImage('images/signup.png'),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.15),
              Text(
                "Login",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.062,
                ),
              ),
              SizedBox(height: height * 0.01),
              Text(
                "Welcome Back!",
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
                          controller: LoginVM.emailController.value,
                          focusNode: LoginVM.emailFocusNode.value,
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
                          controller: LoginVM.passwordController.value,
                          focusNode: LoginVM.passwordFocusNode.value,
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
                  buttonColor:Theme.of(context).colorScheme.primaryContainer,
                  title: 'Login',
                  loading: LoginVM.loading.value,
                  onPress: () {
                    if (_formKey.currentState!.validate()) {
                      Get.toNamed(RouteName.homescreen);
                    }
                  },
                ),
              ),
              SizedBox(height: height * 0.03),
              InkWell(
                onTap: () {
                  
                },
                child: Container(
                  height: height * 0.06,
                  width: width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(width * 0.055),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage('images/google.png')),
                      SizedBox(width: width * 0.03),
                      Text(
                        'Continue with google',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          fontSize: width * 0.032,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
