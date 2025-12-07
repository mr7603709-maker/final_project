import 'package:flutter/material.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Rooms',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Icon(Icons.language, color: Colors.white),
          SizedBox(width: 16),
          Icon(Icons.add, color: Colors.white),
          SizedBox(width: 12),
        ],
      ),
      body: SizedBox(
        height: height,
        width: width,

        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                height: height,
                width: width,
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(
                          height: height * 0.1,
                          width: width * 0.98,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                                radius: width * 0.06,
                                child: Image(
                                  image: AssetImage('images/google.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: width * 0.02),
                              SizedBox(
                                height: height * 0.07,
                                width: width * 0.82,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Mr Dani",
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onPrimaryContainer,
                                            fontWeight: FontWeight.bold,
                                            fontSize: width * 0.038,
                                          ),
                                        ),
                                        Text(
                                          "12:15 am",
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onPrimaryContainer,
                                            fontWeight: FontWeight.w500,
                                            fontSize: width * 0.025,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          child: Row(
                                            children: [
                                              Text(
                                                "Ramzan:",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: width * 0.03,
                                                ),
                                              ),
                                              Text(
                                                "Hye kia hal ha",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: width * 0.03,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        CircleAvatar(
                                          radius: width * 0.019,
                                          backgroundColor: Theme.of(
                                            context,
                                          ).colorScheme.onPrimaryContainer,
                                          child: Text(
                                            "10",
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                              fontWeight: FontWeight.w400,
                                              fontSize: width * 0.02,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Divider(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
