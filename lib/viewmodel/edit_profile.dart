import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditprofileViewModel extends GetxController{

  final namecontroller=TextEditingController().obs;
  final emailcontroller=TextEditingController().obs;
  final passwordcontroller=TextEditingController().obs;
  

  final nameFocusNode=FocusNode().obs;
  final emailFocusNode=FocusNode().obs;
  final passwordFocusNode=FocusNode().obs;
}