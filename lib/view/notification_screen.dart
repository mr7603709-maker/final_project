import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Dummy data for notifications
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'New Song Added',
      'body': 'Check out "Tum Hi Ho" in the Trending section!',
      'time': '2 mins ago',
      'icon': Icons.music_note_rounded,
      'color': Colors.blueAccent,
    },
    {
      'title': 'Room Invite',
      'body': 'Rahul invited you to join "Chill Vibes"',
      'time': '1 hour ago',
      'icon': Icons.meeting_room_rounded,
      'color': Colors.purpleAccent,
    },
    {
      'title': 'Welcome!',
      'body': 'Thanks for joining Dani. Enjoy the music!',
      'time': '1 day ago',
      'icon': Icons.star_rounded,
      'color': Colors.amber,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background
          Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1A2E), // Dark Navy
                  Color(0xFF16213E),
                  Color(0xFF0F3460),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: _notifications.isEmpty
                ? _buildEmptyState(width)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notif = _notifications[index];
                      return _buildNotificationTile(notif, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(double width) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: width * 0.2,
              color: Colors.white54,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 2.seconds),
          const SizedBox(height: 20),
          Text(
            'No Notifications',
            style: TextStyle(
              color: Colors.white,
              fontSize: width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideY(begin: 0.5, end: 0),
          const SizedBox(height: 10),
          Text(
            'We will let you know when something arrives.',
            style: TextStyle(
              color: Colors.white54,
              fontSize: width * 0.035,
            ),
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(Map<String, dynamic> notif, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: notif['color'].withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(notif['icon'], color: notif['color']),
              ),
              title: Text(
                notif['title'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  notif['body'],
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              trailing: Text(
                notif['time'],
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: (index * 100).ms)
        .slideX(begin: 0.2, end: 0, duration: 400.ms, delay: (index * 100).ms);
  }
}
