import 'package:final_project/view/chat_screen.dart';
import 'package:final_project/view/notification_screen.dart';
import 'package:final_project/view/profile/profile_screen.dart';
import 'package:final_project/view/room_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    RoomScreen(),
    ChatScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Map<String, dynamic>> items = [
    {'icon': Icons.format_list_bulleted, 'label': 'Rooms'},
    {'icon': Icons.chat, 'label': 'Chats'},
    {'icon': Icons.notifications, 'label': 'Notifications'},
    {'icon': Icons.person, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.of(context).size.height;
    final width=MediaQuery.of(context).size.width;
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: height*0.09,
        decoration: const BoxDecoration(
          color: Color(0xFF1A093F),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final bool selected = _selectedIndex == index;
            final IconData icon = items[index]['icon'] as IconData;
            final String label = items[index]['label'] as String;

            return GestureDetector(
              onTap: () => _onItemTapped(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: width*0.2,
                height: height*0.08,
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.deepPurple.shade700
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(width*0.01),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: selected ? Colors.yellow[600] : Colors.white,
                    ),
                     SizedBox(height:height*0.005),
                    Text(
                      label,
                      style: TextStyle(
                        color: selected ? Colors.yellow[600] : Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width*0.028,
                      ),
                    ),
                    if (selected)
                      Container(
                        margin:  EdgeInsets.only(top:width*0.005),
                        height:height*0.003,
                        width:width*0.17,
                        color: Colors.yellow[600],
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
