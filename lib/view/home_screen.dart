import 'dart:ui';
import 'package:final_project/view/chat_screen.dart'; // Note: check if this is the right screen for tab 2
import 'package:final_project/view/notification_screen.dart';
import 'package:final_project/view/profile/profile_screen.dart';
import 'package:final_project/view/room_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    RoomScreen(),
    ChatScreen(), // This might need to be FriendListScreen or similar?
    NotificationScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Map<String, dynamic>> items = [
    {'icon': Icons.grid_view_rounded, 'label': 'Rooms'},
    {'icon': Icons.chat_bubble_rounded, 'label': 'Chats'},
    {'icon': Icons.notifications_rounded, 'label': 'Alerts'},
    {'icon': Icons.person_rounded, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height; // Unused
    // final width = MediaQuery.of(context).size.width;   // Unused

    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true, // Important for floating nav bar
      body: Stack(
        children: [
          // Dynamic Background
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _getGradientColors(_selectedIndex),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Content
          _screens[_selectedIndex].animate().fade(
                duration: const Duration(milliseconds: 300),
              ),

          // Floating Nav Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
                left: 20,
                right: 20,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(items.length, (index) {
                        final bool selected = _selectedIndex == index;
                        final IconData icon = items[index]['icon'] as IconData;

                        return GestureDetector(
                          onTap: () => _onItemTapped(index),
                          child: AnimatedContainer(
                            duration: const Duration(
                              milliseconds: 300,
                            ),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: selected
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon,
                              color: selected ? Colors.white : Colors.white60,
                              size: 26,
                            ),
                          ).animate(target: selected ? 1 : 0).scale(
                                begin: const Offset(1, 1),
                                end: const Offset(1.2, 1.2),
                              ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ).animate().slideY(
                  begin: 1,
                  end: 0,
                  delay: const Duration(milliseconds: 500),
                  curve: Curves.easeOutBack,
                ),
          ),
        ],
      ),
    );
  }

  List<Color> _getGradientColors(int index) {
    switch (index) {
      case 0:
        return [Colors.deepPurple.shade900, Colors.black];
      case 1:
        return [Colors.blue.shade900, Colors.black];
      case 2:
        return [Colors.orange.shade900, Colors.black];
      case 3:
        return [Colors.teal.shade900, Colors.black];
      default:
        return [Colors.grey.shade900, Colors.black];
    }
  }
}
