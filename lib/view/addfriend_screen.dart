import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model/friend_model.dart';
import 'package:final_project/model/request_model.dart';
import 'package:final_project/model/signup_model.dart';
import 'package:final_project/model/static_data.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class AddfriendScreen extends StatefulWidget {
  const AddfriendScreen({super.key});

  @override
  State<AddfriendScreen> createState() => _AddfriendScreenState();
}

class _AddfriendScreenState extends State<AddfriendScreen> {
  final TextEditingController searchController =
      TextEditingController(); // Step 1
  String searchText = "";

  @override
  void initState() {
    super.initState();

    // Step 2: listen to text changes
    searchController.addListener(() {
      setState(() {
        searchText = searchController.text
            .toLowerCase(); // convert to lowercase
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: Text('Add friends'),
        centerTitle: true,
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: [
            Divider(color: Theme.of(context).colorScheme.primaryContainer),
            SizedBox(height: height * 0.01),
            Container(
              width: width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(width * 0.055),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: TextField(
                  controller: searchController,
                  cursorColor: Colors.amber,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: width * 0.025,
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.01),
            SizedBox(
              height: height * 0.25,
              width: width * 0.95,
              child: Column(
                children: [
                  SizedBox(
                    width: width * 0.95,
                    child: Text(
                      "Add friend",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.035,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),

                  Expanded(
                    child: Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(width * 0.025),
                      ),
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("finalrequests")
                            .where(
                              "reciverId",
                              isEqualTo: StaticData.mymodel?.userId ?? "",
                            )
                            .snapshots(),
                        builder: (context, snapshot) {
                          // if (!snapshot.hasData) {
                          //   return const Center(child: Text("No requests"));
                          // }

                          // if (snapshot.data!.docs.isEmpty) {
                          //   return const Center(
                          //     child: Text("No friend requests"),
                          //   );
                          // }

                          return snapshot.data == null
                              ? Center(child: Text("No data found"))
                              : ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    RequestModel reqmodel =
                                        RequestModel.fromMap(
                                          snapshot.data!.docs[index].data(),
                                        );

                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: height * 0.07,
                                          width: width * 0.95,
                                          child: Row(
                                            children: [
                                              SizedBox(width: width * 0.015),
                                              CircleAvatar(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .onPrimaryContainer,
                                                radius: width * 0.05,
                                                child: Image(
                                                  image: AssetImage(
                                                    'images/google.png',
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(width: width * 0.02),
                                              SizedBox(
                                                height: height * 0.06,
                                                width: width * 0.58,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                     reqmodel.senderName
                                                            .toString(),
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimaryContainer,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: width * 0.035,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              /// ✅ ACCEPT BUTTON
                                              InkWell(
                                                onTap: () async {
                                                  var uid = Uuid();
                                                  String fdId = uid.v4();
                                                  FriendModel
                                                  fdmodel = FriendModel(
                                                    friendname:
                                                        reqmodel.senderName,
                                                    friendId: reqmodel.senderId,
                                                    userId: reqmodel.reciverId,
                                                    fdId: fdId,
                                                  );
                                                  FirebaseFirestore.instance
                                                      .collection("finalfriends")
                                                      .doc(fdId)
                                                      .set(fdmodel.toMap());
                                                  String fd2Id = uid.v4();
                                                  FriendModel
                                                  friend = FriendModel(
                                                    friendname:
                                                        reqmodel.reciverName,
                                                    friendId:
                                                        reqmodel.reciverId,
                                                    userId: reqmodel.senderId,
                                                    fdId: fd2Id,
                                                  );
                                                  FirebaseFirestore.instance
                                                      .collection("finalfriends")
                                                      .doc(fd2Id)
                                                      .set(friend.toMap());

                                                  FirebaseFirestore.instance
                                                      .collection(
                                                        "finalrequests",
                                                      )
                                                      .doc(reqmodel.reqId)
                                                      .delete();
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  height: height * 0.04,
                                                  width: width * 0.22,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimaryContainer,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          width * 0.3,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Icon(
                                                        Icons.check,
                                                        size: width * 0.05,
                                                      ),
                                                      Text(
                                                        "Accept",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              width * 0.03,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primaryContainer,
                                        ),
                                      ],
                                    );
                                  },
                                );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.015),
            SizedBox(
              width: width * 0.95,
              child: Text(
                "Find friend",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.035,
                ),
              ),
            ),
            SizedBox(height: height * 0.01),
            Expanded(
              child: SizedBox(
                height: height * 0.2,
                width: width * 0.95,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("finalUsers") // ✅ FIXED COLLECTION
                      .where(
                        "email",
                        isNotEqualTo: StaticData.mymodel?.email ?? "",
                      )
                      .snapshots(),
                  builder: (context, snapshot) {
                    /// 🛡️ USER NULL SAFETY
                    if (StaticData.mymodel == null) {
                      return const Center(child: Text("User not logged in"));
                    }

                    if (!snapshot.hasData) {
                      return const Center(child: Text("no data found"));
                    }

                    // ✅ MAP USERS AND FILTER BY SEARCH TEXT
                    List<UserData> users = snapshot.data!.docs
                        .map((doc) => UserData.fromMap(doc.data()))
                        .where(
                          (user) =>
                              user.name != null &&
                              user.name!.toLowerCase().contains(searchText),
                        )
                        .toList();

                    if (users.isEmpty) {
                      return const Center(child: Text("No users found"));
                    }

                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        UserData model = users[index];

                        /// 🛡️ INVALID USER GUARD
                        if (model.userId == null || model.userId!.isEmpty) {
                          return const SizedBox();
                        }

                        /// 🔥 CHECK REQUEST STATUS
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("finalrequests")
                              .where(
                                "senderId",
                                isEqualTo: StaticData.mymodel?.userId ?? "",
                              )
                              .where("reciverId", isEqualTo: model.userId)
                              .snapshots(),
                          builder: (context, reqSnap) {
                            bool requested =
                                reqSnap.hasData &&
                                reqSnap.data!.docs.isNotEmpty;

                            String? reqId = requested
                                ? reqSnap.data!.docs.first["reqId"]
                                : null;

                            return Column(
                              children: [
                                SizedBox(
                                  height: height * 0.07,
                                  width: width * 0.95,
                                  child: Row(
                                    children: [
                                      SizedBox(width: width * 0.015),
                                      CircleAvatar(
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryContainer,
                                        radius: width * 0.05,
                                        child: Image(
                                          image: AssetImage(
                                            'images/google.png',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: width * 0.02),
                                      SizedBox(
                                        height: height * 0.07,
                                        width: width * 0.63,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              model.name ?? "",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer,
                                                fontWeight: FontWeight.bold,
                                                fontSize: width * 0.035,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      /// 🔥 ADD ↔ CANCEL BUTTON
                                      InkWell(
                                        onTap: () async {
                                          if (requested) {
                                            // ❌ Cancel request
                                            await FirebaseFirestore.instance
                                                .collection("finalrequests")
                                                .doc(reqId)
                                                .delete();
                                          } else {
                                            // ✅ Send request
                                            var uid = const Uuid();
                                            String newReqId = uid.v4();

                                            RequestModel reqModel =
                                                RequestModel(
                                                  senderId: StaticData
                                                      .mymodel!
                                                      .userId,
                                                  senderName:
                                                      StaticData.mymodel!.name,
                                                  reqId: newReqId,
                                                  reciverId: model.userId,
                                                  reciverName: model.name,
                                                );

                                            await FirebaseFirestore.instance
                                                .collection("finalrequests")
                                                .doc(newReqId)
                                                .set(reqModel.toMap());
                                          }
                                        },
                                        child: Container(
                                          height: height * 0.04,
                                          width: width * 0.18,
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onPrimaryContainer,
                                            borderRadius: BorderRadius.circular(
                                              width * 0.3,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(
                                                requested
                                                    ? Icons.cancel
                                                    : Icons.person_add,
                                                size: width * 0.05,
                                              ),
                                              Text(
                                                requested ? "Cancel" : "Add",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: width * 0.03,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
