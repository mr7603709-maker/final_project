import 'package:final_project/theme_data/colors.dart';
import 'package:flutter/material.dart';


final ThemeData lightTheme=ThemeData(
  brightness:Brightness.light,
  scaffoldBackgroundColor: lightBgColor,
colorScheme: ColorScheme.light(
  primary: lighthinttextcolor,
  primaryContainer: lightButtonColor,
  onPrimaryContainer: lightbuttonTextColor,
  secondaryContainer: lightDivColor,
  

)  ,
);




final ThemeData darkTheme=ThemeData(
  brightness: Brightness.dark,
  // colorScheme: ColorScheme.dark(
  //   primaryContainer: darkDivColor,
  //   onPrimaryContainer: darkDanicontain
  // )
);