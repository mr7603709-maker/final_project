import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Utils{
  static void fielFocusChange(BuildContext context, FocusNode current,FocusNode nextFocus){
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static toastMessage(String message){
    Fluttertoast.showToast(
      msg:message,fontSize: 15,
      backgroundColor: Colors.blue,
      gravity: ToastGravity.TOP
      // textColor: Colors.white
      );
  }
  static snackBar(String title,String message){
    Get.snackbar(
      title, 
      message,
      duration: Duration(seconds: 4),
      colorText:Color(0xFF3E3C75),
      backgroundColor:Colors.teal.shade300

      );
    
  }
}