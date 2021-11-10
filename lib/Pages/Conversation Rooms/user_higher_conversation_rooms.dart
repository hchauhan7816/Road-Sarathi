import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sadak/Config/constants.dart';
import 'package:sadak/Config/text_styles.dart';
import 'package:sadak/Modal/users.dart';
import 'package:sadak/Pages/Chat%20Screen/Widgets/tiles.dart';
import 'package:sadak/Pages/Chat%20Screen/chat_screen.dart';
import 'package:sadak/Pages/Conversation%20Rooms/Widgets/tabbar.dart';
import 'package:sadak/Pages/On%20Boarding/on_boarding.dart';
import 'package:sadak/Services/Controllers/auth_controller.dart';
import 'package:sadak/Widgets/custom_scaffold.dart';
import 'dart:developer' as dev;

import 'Widgets/appbar_user_conversation_rooms.dart';

const String _CHATROOMID = "chatroomId";

class UserHigherConversationRooms extends StatelessWidget {
  const UserHigherConversationRooms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // Added
      length: 2, // Added
      initialIndex: 0,
      child: CustomScaffold(
        body: TabBarView(
          children: [
            UserHigherConversationRoomsBody(
                completed: false), //completed: false),

            UserHigherConversationRoomsBody(
                completed: true), //completed: true),
            // GovConversationRoomsBody(
            //     authorityEmail: authorityEmail, completed: false),
            // GovConversationRoomsBody(
            //     authorityEmail: authorityEmail, completed: true),
            // Icon(Icons.directions_transit, size: 350),
            // Icon(Icons.directions_car, size: 350),
          ],
        ),
        backgroundColor: Colors.blueGrey,
        appBar: userConversationRoomsAppBar(
          context,
          tabBar: conversationRoomsTabBar(),
        ),
      ),
    );
  }
}

FloatingActionButton userHigherConversationRoomsFloatingActionButton(context) {
  return FloatingActionButton(
    child: Icon(Icons.search_rounded),
    onPressed: () {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => SearchScreen(),
      //   ),
      // );
    },
  );
}

class UserHigherConversationRoomsBody extends StatefulWidget {
  UserHigherConversationRoomsBody({Key? key, required this.completed})
      : super(key: key);
  bool completed;

  @override
  State<UserHigherConversationRoomsBody> createState() =>
      _UserHigherConversationRoomsBodyState();
}

class _UserHigherConversationRoomsBodyState
    extends State<UserHigherConversationRoomsBody> {
  FirebaseHelper firebaseHelper = Get.find<FirebaseHelper>();

  // TextEditingController searchTextController = TextEditingController();
  // Future<List<ModalUser>>? searchResult;
  Stream<QuerySnapshot<Map<String, dynamic>>>? chatRoomsStream;
  // String? searchValue = "";

  bool isLoading = false;

  @override
  void initState() {
    Constants.myEmail = firebaseHelper.auth.currentUser!.email!;
    // getUserInfo();
    chatRoomsStream = firebaseHelper.getChatRoomsHigherAuthority(
        userEmail: Constants.myEmail, completed: widget.completed);
    super.initState();
  }

  // initiateSearch(String searchValue) {
  //   // databaseMethods
  //   //     .getUserByUsername(searchTextEditingController.text)
  //   //     .then((e) {
  //   //   setState(() {
  //   //     searchSnapshot = e;
  //   //   });
  //   // });

  //   setState(() {
  //     isLoading = true;
  //   });

  //   // dev.log("Here");

  //   searchResult =
  //       firebaseHelper.searchWithAlreadyConnectedUsers(userEmail: searchValue);

  //   // dev.log(searchResult);
  //   // dev.log("Done");

  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  Widget chatRoomList() {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: StreamBuilder(
        stream: chatRoomsStream,
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.data == null) {
            return Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Center(
                child: Text(
                  "No Complaints",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                ),
              ),
            );
          } else if (snapshot.data!.docs.length == 0) {
            return Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Center(
                child: Text(
                  "No Complaints",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              // dev.log(
              //     "${snapshot.data!.docs.length}  \n\n\n${snapshot.data!.docs[index].data()[CHATROOM]}");
              return ChatRoomsTile(
                  isWithHigher: false,
                  completed: widget.completed,
                  username:
                      snapshot.data!.docs[index].data()["authority"].toString(),
                  userEmail: Constants.myEmail,
                  title: snapshot.data!.docs[index].data()["title"].toString(),
                  chatRoomId: snapshot.data!.docs[index]
                      .data()[_CHATROOMID]
                      .toString());
            },
          );
        },
      ),
    );

    // return Text("Hello");
  }

  // createChatroomAndStartConversation(String clickedUserEmail) {
  //   List<String> users = [Constants.myEmail, clickedUserEmail];
  //   String chatroomId = firebaseHelper.getChatroomId(
  //       userEmail1: Constants.myEmail, userEmail2: clickedUserEmail);

  //   if (clickedUserEmail != Constants.myEmail) {
  //     Map<String, dynamic> chatroomMap = {
  //       "users": users,
  //       "chatroomId": chatroomId
  //     };

  //     // dev.log("Done CreateChatroomAndStartConversation");
  //     firebaseHelper.createChatRooms(
  //         userEmail1: Constants.myEmail,
  //         userEmail2: clickedUserEmail,
  //         chatroomMap: chatroomMap);

  //     Get.to(ChatScreen(
  //       chatRoomId: chatroomId,
  //     ));
  //   }
  // }

  // Widget searchList() {
  //   return FutureBuilder(
  //     builder: (context, AsyncSnapshot<List<ModalUser>> snapshot) {
  //       return snapshot.hasData
  //           ? ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: snapshot.data!.length,
  //               itemBuilder: (context, index) {
  //                 return searchTile(
  //                   name: snapshot.data![index].name,
  //                   email: snapshot.data![index].email,
  //                 );
  //               },
  //             )
  //           : Container();
  //     },
  //     future: searchResult,
  //   );
  // }

  // Widget searchTile({required String email, required String name}) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  //     child: Row(
  //       children: [
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               name,
  //               style: normal1(),
  //             ),
  //             Text(
  //               email,
  //               style: normal1(),
  //             ),
  //           ],
  //         ),
  //         const Spacer(),
  //         GestureDetector(
  //           onTap: () {
  //             createChatroomAndStartConversation(email);
  //           },
  //           child: Container(
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(30),
  //               color: Colors.blue,
  //             ),
  //             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //             child: Text(
  //               "Message",
  //               style: normal2(),
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                children: [
                  // Column(
                  //   children: [
                  //     Container(
                  //       color: const Color(0x54FFFFFF),
                  //       padding:
                  //           EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  //       child: Row(
                  //         children: [
                  //           Expanded(
                  //             child: TextField(
                  //               onChanged: (val) {
                  //                 searchValue = val;
                  //                 if (searchValue == null) {
                  //                   Get.snackbar("Invalid", "Enter correct email");
                  //                   return;
                  //                 }
                  //                 initiateSearch(searchValue!);
                  //               },
                  //               controller: searchTextController,
                  //               // style: TextStyle(color: Colors.white),
                  //               decoration: const InputDecoration(
                  //                 hintText: "search username...",
                  //                 hintStyle: TextStyle(
                  //                   color: Colors.white54,
                  //                 ),
                  //                 border: InputBorder.none,
                  //               ),
                  //             ),
                  //           ),
                  //           GestureDetector(
                  //             onTap: () {
                  //               if (searchValue == null) {
                  //                 Get.snackbar("Invalid", "Enter correct email");
                  //                 return;
                  //               }
                  //               initiateSearch(searchValue!);
                  //             },
                  //             child: Container(
                  //               height: 48,
                  //               width: 48,
                  //               padding: EdgeInsets.all(16),
                  //               decoration: BoxDecoration(
                  //                 gradient: LinearGradient(
                  //                   colors: [
                  //                     const Color(0x36FFFFFF),
                  //                     const Color(0x0FFFFFFF)
                  //                   ],
                  //                 ),
                  //                 borderRadius: BorderRadius.circular(40),
                  //               ),
                  //               // color: Colors.red,
                  //               child: Icon(Icons.search),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: chatRoomList(),
                  ),
                ],
              ),
            ),
          );
  }
}
