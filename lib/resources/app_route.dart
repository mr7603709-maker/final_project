import 'package:final_project/resources/route_name.dart';
import 'package:final_project/view/home_screen.dart';
import 'package:final_project/view/join_room_screen.dart';
import 'package:final_project/view/login_screen.dart';
import 'package:final_project/view/profile/edit_profile.dart';
import 'package:final_project/view/signup_screen.dart';
import 'package:final_project/view/welcome_screen.dart';
import 'package:get/get.dart';


class AppRoute {
  static appRoute() => [
        // GetPage(
        //     name: RouteName.splashscreen,
        //     page: () => SplashScreen(),
        //     transitionDuration: Duration(milliseconds: 250),
        //     transition: Transition.leftToRight
        //     ),

        GetPage(
            name: RouteName.welcomescreen,
            page: () => WelcomeScreen(),
            transitionDuration: Duration(milliseconds: 200),
            transition: Transition.leftToRight),
        GetPage(
            name: RouteName.joinroomscreen,
            page: () => JoinRoomScreen(),
            transitionDuration: Duration(milliseconds: 200),
            transition: Transition.leftToRight),
        GetPage(
            name: RouteName.loginscreen,
            page: () => LoginScreen(),
            transitionDuration: Duration(milliseconds: 200),
            transition: Transition.leftToRight),

        GetPage(
            name: RouteName.signupscreen,
            page: () => SignupScreen(),
            transitionDuration: Duration(milliseconds: 200),
            transition: Transition.leftToRight),

        GetPage(
            name: RouteName.homescreen,
            page: () => HomeScreen(),
            transitionDuration: Duration(milliseconds: 200),
            transition: Transition.leftToRight),

        GetPage(
            name: RouteName.editprofilecreen,
            page: () => EditProfileScreen(),
            transitionDuration: Duration(milliseconds: 200),
            transition: Transition.leftToRight),

   ];
}
