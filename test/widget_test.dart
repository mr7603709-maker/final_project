// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:final_project/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
// import 'package:final_project/view/home_screen.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:final_project/main.dart';
// import 'package:final_project/view/welcome_screen.dart';

// void main() {
//   group('MyApp Widget Tests', () {
//     testWidgets('Shows WelcomeScreen when not logged in', (WidgetTester tester) async {
//       // Build app with isLoggedIn = false
//       await tester.pumpWidget(const MyApp(isLoggedIn: false));

//       // Trigger a frame
//       await tester.pumpAndSettle();

//       // Verify WelcomeScreen is displayed
//       expect(find.byType(WelcomeScreen), findsOneWidget);

//       // Optional: check some text in WelcomeScreen
//       expect(find.text('Welcome'), findsOneWidget); // adjust text as per your WelcomeScreen
//     });

//     testWidgets('Shows HomeScreen when already logged in', (WidgetTester tester) async {
//       // Build app with isLoggedIn = true
//       await tester.pumpWidget(const MyApp(isLoggedIn: true));

//       await tester.pumpAndSettle();

//       // Verify HomeScreen is displayed
//       expect(find.byType(HomeScreen), findsOneWidget); // make sure HomeScreen is imported

//       // Optional: check some text in HomeScreen
//       expect(find.text('Home'), findsOneWidget); // adjust text based on your HomeScreen
//     });
//   });
// }
