import 'package:final_project/customwidget/button_widget.dart';
import 'package:final_project/viewmodel/profile_viewmodel/delete_accountmodel.dart';
import 'package:flutter/material.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '"Are you sure you want to delete your account?\n This action is permanent and cannot be undone."',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height * 0.1),
            RoundedButtonWidget(
              onPress: () async {
                final userViewModel = UserViewModel();
                userViewModel.deleteUser(context);
              },
              title: 'Delete',
              buttonColor: Theme.of(context).colorScheme.onPrimaryContainer,
              textColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}
