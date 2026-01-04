import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/customwidget/button_widget.dart';
import 'package:final_project/model/static_data.dart';
import 'package:final_project/resources/route_name.dart';
import 'package:final_project/viewmodel/room_model/room_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final RoomViewModel roomVM = Get.put(RoomViewModel());
  @override
  void initState() {
    super.initState();
    roomVM.loadRooms(); // load existing rooms
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final String currentUserId = StaticData.mymodel!.userId!;
    final String selectedRoomType = roomVM.roomType.value;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: const Text(
          'Rooms',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Icon(Icons.language),
          SizedBox(width: width * 0.05),

          /// ➕ ADD ICON → SHOW DIALOG DIRECTLY
          GestureDetector(
            onTap: () {
              final size = MediaQuery.of(context).size;
              showDialog(
                context: context,
                barrierColor: Colors.black54,
                builder: (context) {
                  return MycustomWidget.addroomWidget(size, roomVM);
                },
              );
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),

          SizedBox(width: width * 0.05),
        ],
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: [
            Divider(color: Theme.of(context).colorScheme.primaryContainer),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  /// PUBLIC ROOM BUTTON
                  Expanded(
                    child: GestureDetector(
                      onTap: () => roomVM.setPublic(),
                      child: Container(
                        height: height*0.055,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(width*0.025),
                          border: Border.all(
                            color: roomVM.roomType.value == 'public'
                                ? Colors.green
                                : Colors.grey,
                            width: width*0.003,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Public Room',
                            style: TextStyle(
                              color: roomVM.roomType.value == 'public'
                                  ? Colors.green
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width:width*0.03),

                  /// PRIVATE ROOM BUTTON
                  Expanded(
                    child: GestureDetector(
                      onTap: () => roomVM.setPrivate(),
                      child: Container(
                        height: height*0.055,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(width*0.025),
                          border: Border.all(
                            color: roomVM.roomType.value == 'private'
                                ? Colors.red
                                : Colors.grey,
                            width: width*0.003,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Private Room',
                            style: TextStyle(
                              color: roomVM.roomType.value == 'private'
                                  ? Colors.red
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('finalrooms')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No Rooms Found',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    );
                  }

                  final filteredRooms = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final bool isPrivate = data['private'] ?? false;
                    final String adminId = data['adminId'] ?? '';

                    if (selectedRoomType == 'public') {
                      return !isPrivate;
                    } else {
                      return isPrivate && adminId == currentUserId;
                    }
                  }).toList();

                  if (filteredRooms.isEmpty) {
                    return Center(
                      child: Text(
                        'No Rooms Found',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredRooms.length,
                    itemBuilder: (context, index) {
                      final room = filteredRooms[index];
                      final roomData = room.data() as Map<String, dynamic>;
                      final roomName = roomData['roomName'] ?? 'Room';
                      final creatorName = roomData['adminName'] ?? 'Admin';
                      final creatorImage = roomData['adminImage'];

                      return InkWell(
                        onTap: () => Get.toNamed(RouteName.chatroomscreen),
                        child: SizedBox(
                          height: height * 0.09,
                          width: width * 0.98,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                                radius: width * 0.06,
                                child:
                                    creatorImage != null && creatorImage != ''
                                    ? ClipOval(
                                        child: Image.network(
                                          creatorImage,
                                          fit: BoxFit.cover,
                                          width: width * 0.12,
                                          height: width * 0.12,
                                        ),
                                      )
                                    : Text(
                                        creatorName.isNotEmpty
                                            ? creatorName[0].toUpperCase()
                                            : 'A',
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.secondaryContainer,
                                          fontWeight: FontWeight.bold,
                                          fontSize: width * 0.05,
                                        ),
                                      ),
                              ),
                              SizedBox(width: width * 0.02),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    roomName,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.bold,
                                      fontSize: width * 0.038,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Admin: ",
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimaryContainer,
                                          fontWeight: FontWeight.w500,
                                          fontSize: width * 0.032,
                                        ),
                                      ),
                                      Text(
                                        creatorName,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimaryContainer,
                                          fontWeight: FontWeight.w400,
                                          fontSize: width * 0.03,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MycustomWidget {
  static Widget addroomWidget(Size size, RoomViewModel roomVM) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(size.width * 0.1),
      child: Container(
        height: size.height * 0.35,
        width: size.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(size.width * 0.05),
        ),
        child: Column(
          children: [
            /// ❌ CLOSE
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () => Navigator.pop(Get.context!),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            const Spacer(),

            /// ➕ CREATE ROOM
            InkWell(
              onTap: () {
                showDialog(
                  context: Get.context!,
                  builder: (context) => createRoomDialog(size, roomVM),
                );
              },
              child: Container(
                height: size.height * 0.07,
                width: size.width * 0.75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.width * 0.025),
                  border: Border.all(
                    color: Colors.white,
                    width: size.width * 0.0025,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Theme.of(
                        Get.context!,
                      ).colorScheme.onPrimaryContainer,
                    ),
                    SizedBox(width: size.width * 0.025),
                    Text(
                      "Create a new Room",
                      style: TextStyle(
                        color: Theme.of(
                          Get.context!,
                        ).colorScheme.onPrimaryContainer,
                        fontSize: size.width * 0.035,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),

            /// 🔗 JOIN ROOM
            InkWell(
              onTap: () {
                showDialog(
                  context: Get.context!,
                  builder: (context) => joinexistingroomWidget(size, context),
                );
              },
              child: Container(
                height: size.height * 0.07,
                width: size.width * 0.75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.width * 0.02),
                  border: Border.all(
                    color: Colors.white,
                    width: size.width * 0.0025,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.login,
                      color: Theme.of(
                        Get.context!,
                      ).colorScheme.onPrimaryContainer,
                    ),
                    SizedBox(width: size.width * 0.025),
                    Text(
                      "Join an existing Room",
                      style: TextStyle(
                        color: Theme.of(
                          Get.context!,
                        ).colorScheme.onPrimaryContainer,
                        fontSize: size.width * 0.035,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  // create room dialog Widget
  static Widget createRoomDialog(Size size, RoomViewModel roomVM) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(size.width * 0.1),
      child: Container(
        height: size.height * 0.35,
        width: size.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(size.width * 0.05),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            const Spacer(),
            Container(
              width: size.width * 0.68,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.width * 0.02),
                border: Border.all(
                  color: Theme.of(Get.context!).colorScheme.onPrimaryContainer,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: TextField(
                  onChanged: (value) => roomVM.newRoomName.value = value,
                  cursorColor: Colors.amber,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Room name',
                    hintStyle: TextStyle(
                      color: Theme.of(Get.context!).colorScheme.primary,
                    ),
                  ),
                  style: TextStyle(
                    color: Theme.of(
                      Get.context!,
                    ).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Private Room",
                  style: TextStyle(
                    color: Theme.of(
                      Get.context!,
                    ).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Obx(
                  () => Switch(
                    value: roomVM.isPrivateRoom.value,
                    onChanged: (_) => roomVM.togglePrivate(),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            Obx(
              () => roomVM.isLoading.value
                  ? const CircularProgressIndicator()
                  : RoundedButtonWidget(
                      onPress: () async {
                        await roomVM.createRoom();
                        Get.back();
                      },
                      title: 'Create',
                      buttonColor: Theme.of(
                        Get.context!,
                      ).colorScheme.onPrimaryContainer,
                      textColor: Theme.of(
                        Get.context!,
                      ).colorScheme.primaryContainer,
                    ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  // join existing dialog Widget
  static Widget joinexistingroomWidget(Size size, BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(size.width * 0.1),
      child: Container(
        height: size.height * 0.35,
        width: size.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(size.width * 0.05),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            const Spacer(),
            Container(
              width: size.width * 0.68,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.width * 0.02),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: TextField(
                  cursorColor: Colors.amber,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Room url...',
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.06),
            RoundedButtonWidget(
              onPress: () {},
              title: 'Join room',
              buttonColor: Theme.of(context).colorScheme.onPrimaryContainer,
              textColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
