// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

class ChatRoomscreen extends StatefulWidget {
  const ChatRoomscreen({super.key});

  @override
  State<ChatRoomscreen> createState() => _ChatRoomscreenState();
}

class _ChatRoomscreenState extends State<ChatRoomscreen> {
  
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(
                'images/profile.jpg',
              ), // replace with actual image
            ),
            SizedBox(width: width * 0.02),
            Column(
              children: [
                Text(
                  'mrdani1',
                  style: TextStyle(
                    fontSize: width * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.group, size: width * 0.035),
                    SizedBox(width: width * 0.01),
                    Text('1', style: TextStyle(fontSize: width * 0.026)),
                  ],
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.person_add),
            SizedBox(width: width * 0.025),
            Icon(Icons.more_vert),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: height *(isKeyboardOpen?0.15:0.25),
            width: width,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: height * 0.06,
                  width: width * 0.35,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    borderRadius: BorderRadius.circular(width * 0.02),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.video_collection_outlined,color: Theme.of(context).colorScheme.secondaryContainer,),
                      SizedBox(width: width*0.01),
                      Text("Select Media",style: TextStyle(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize:width*0.035,
                      ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              height: height,
              width: width,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'helo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'kia ho rha h',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.08,
            width: width,
            child: Row(
              children: [
                SizedBox(width: width * 0.02),
                Expanded(
                  child: TextField(
                    cursorColor: Colors.amber,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: width * 0.024,
                      ),
                      filled: true,
                      fillColor: Theme.of(
                        context,
                      ).colorScheme.secondaryContainer,
                      hintText: 'message...',
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(width * 0.025),
                      ),
                    ),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                SizedBox(width: width * 0.02),
                CircleAvatar(
                  radius: width * 0.05,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.onPrimaryContainer,
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    onPressed: () {},
                  ),
                ),
                SizedBox(width: width * 0.02),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
