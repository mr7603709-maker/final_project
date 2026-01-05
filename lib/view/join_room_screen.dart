import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Join Room',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A1A2E),
                  Color(0xFF16213E),
                  Color(0xFF0F3460),
                ],
              ),
            ),
          ),

          // Decorative Circles
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.purpleAccent.withOpacity(0.2),
                    blurRadius: 50,
                    spreadRadius: 20,
                  ),
                ],
              ),
            )
                .animate()
                .scale(duration: 2.seconds, curve: Curves.easeInOut)
                .fadeIn(),
          ),

          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Glass Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.link_rounded,
                                      size: 50, color: Colors.white70)
                                  .animate()
                                  .scale(
                                      duration: 500.ms,
                                      curve: Curves.easeOutBack),
                              const SizedBox(height: 20),
                              Text(
                                "Enter Room Link",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Paste the invitation link below to join the party.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: width * 0.035,
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Input Field
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white12),
                                ),
                                child: TextField(
                                  controller: _controller,
                                  style: const TextStyle(color: Colors.white),
                                  cursorColor: Colors.blueAccent,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 16),
                                    hintText: 'https://dani.to/room...',
                                    hintStyle: TextStyle(color: Colors.white30),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.paste_rounded,
                                          color: Colors.blueAccent),
                                      onPressed: () async {
                                        final data = await Clipboard.getData(
                                            Clipboard.kTextPlain);
                                        if (data?.text != null) {
                                          _controller.text = data!.text!;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              )
                                  .animate()
                                  .fadeIn(delay: 200.ms)
                                  .slideY(begin: 0.2, end: 0),

                              const SizedBox(height: 30),

                              // Join Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Handle join logic
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    elevation: 5,
                                    shadowColor:
                                        Colors.blueAccent.withOpacity(0.4),
                                  ),
                                  child: const Text(
                                    "Join Room",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              )
                                  .animate()
                                  .fadeIn(delay: 400.ms)
                                  .scale(begin: const Offset(0.9, 0.9)),
                            ],
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn()
                        .slideY(begin: 0.1, end: 0, duration: 600.ms),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
