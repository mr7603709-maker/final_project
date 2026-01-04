import 'package:flutter/material.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Join room', style: TextStyle(fontWeight: FontWeight.w500)),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: [
            Divider(color: Theme.of(context).colorScheme.primaryContainer),
            Expanded(
              child: SizedBox(
                height: height,
                width: width,
                child: ListView(
                  children: [
                    Column(
                      children: [
                        SizedBox(height: height * 0.05),
                        Text(
                          "Enter a room link below to join an existing room",
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                            fontSize: width * 0.032,
                          ),
                        ),
                        SizedBox(height: height * 0.08),
                        SizedBox(
                          width: width * 0.85,
                          child: Text(
                            "Room link",
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w500,
                              fontSize: width * 0.032,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Container(
                          width: width * 0.85,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width * 0.02),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.03,
                            ),
                            child: TextField(
                              cursorColor: Colors.amber,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'http//dani.to/load',
                                hintStyle: TextStyle(color:Theme.of(context).colorScheme.primary),
                              ),
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.2),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            height: height * 0.06,
                            width: width * 0.5,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                              borderRadius: BorderRadius.circular(width * 0.02),
                            ),
                            child: Center(
                              child: Text(
                                "Join room",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.038,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
