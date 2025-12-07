import 'package:final_project/customwidget/button_widget.dart';
import 'package:final_project/resources/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: [
            CircleAvatar(
              radius: width * 0.1,
              backgroundImage: AssetImage('images/profile.jpg'),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: width * 0.135,
                      left: width * 0.12,
                    ),
                    child: CircleAvatar(
                      radius: width * 0.035,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer,
                      child: InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.add_a_photo,
                          color: Theme.of(context).colorScheme.primary,
                          size: width * 0.04,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.03),
            Text(
              "Mr Dani",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
                letterSpacing: width * 0.003,
                fontSize: width * 0.045,
              ),
            ),
            SizedBox(height: height * 0.08),
            InkWell(
              onTap: () {
                Get.toNamed(RouteName.editprofilecreen);
              },
              child: Container(
                height: height * 0.07,
                width: width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * 0.02),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: width * 0.03),
                    Icon(
                      Icons.account_box_outlined,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: width * 0.045,
                    ),
                    SizedBox(width: width * 0.015),
                    SizedBox(
                      width: width * 0.75,
                      child: Text(
                        "Display name",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: width * 0.035,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: width * 0.04,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: height * 0.04),
            InkWell(
              onTap: () {
                Get.toNamed(RouteName.editprofilecreen);
              },
              child: Container(
                height: height * 0.07,
                width: width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * 0.02),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: width * 0.03),
                    Icon(
                      Icons.email_outlined,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: width * 0.045,
                    ),
                    SizedBox(width: width * 0.015),
                    SizedBox(
                      width: width * 0.75,
                      child: Text(
                        "Email",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: width * 0.035,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: width * 0.04,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: height * 0.04),
            InkWell(
              onTap: () {
                Get.toNamed(RouteName.editprofilecreen);
              },
              child: Container(
                height: height * 0.07,
                width: width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * 0.02),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: width * 0.03),
                    Icon(
                      Icons.lock_outline,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: width * 0.045,
                    ),
                    SizedBox(width: width * 0.015),
                    SizedBox(
                      width: width * 0.75,
                      child: Text(
                        "Password",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: width * 0.035,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: width * 0.04,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: height*0.05),
            RoundedButtonWidget(
              onPress: () {},
              title: 'Log out',
              textColor: Theme.of(context).colorScheme.primaryContainer,
              buttonColor: Theme.of(context).colorScheme.onPrimary,
            ),
            SizedBox(height: height*0.04),
             InkWell(
              onTap: () {},
              child: Container(
                height: height * 0.065,
                width: width * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * 0.02),
                  border: Border.all(
                    color:Colors.red,
                  ),
                ),
                child: Center(
                  child: Text(
                    "Data deletion",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: width * 0.035,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
