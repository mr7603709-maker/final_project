import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupViewModel extends GetxController{
  final nameController= TextEditingController().obs;
  final emailController= TextEditingController().obs;
  final passwordController= TextEditingController().obs;

  final nameFocusNode =FocusNode().obs;
  final emailFocusNode =FocusNode().obs;
  final passwordFocusNode=FocusNode().obs;
  RxBool loading =false.obs;
}