import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadak/Config/constants.dart';
import 'package:sadak/Config/palette.dart';
import 'package:sadak/Pages/Chat%20Screen/Widgets/tiles.dart';
import 'package:sadak/Services/Controllers/auth_controller.dart';
import 'package:sadak/Widgets/custom_scaffold.dart';

import 'Widgets/appbar_user_conversation_rooms.dart';
import 'Widgets/tabbar.dart';

const String _CHATROOMID = "chatroomId";

class UserConversationRooms extends StatelessWidget {
  const UserConversationRooms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: CustomScaffold(
          body: TabBarView(
            children: [
              UserConversationRoomsBody(completed: false, isWithHigher: false),
              UserConversationRoomsBody(completed: true, isWithHigher: false),
              UserConversationRoomsBody(completed: true, isWithHigher: true),
            ],
          ),
          backgroundColor: Palette.peach,
          appBar: userConversationRoomsAppBar(
            context,
            tabBar: userLocalGovConversationRoomsTabBar(),
          )),
    );
  }
}

FloatingActionButton userConversationRoomsFloatingActionButton(context) {
  return FloatingActionButton(
    child: Icon(Icons.search_rounded),
    onPressed: () {},
  );
}

// ignore: must_be_immutable
class UserConversationRoomsBody extends StatefulWidget {
  UserConversationRoomsBody(
      {Key? key, required this.completed, required this.isWithHigher})
      : super(key: key);
  bool completed;
  bool isWithHigher;

  @override
  State<UserConversationRoomsBody> createState() =>
      _UserConversationRoomsBodyState();
}

class _UserConversationRoomsBodyState extends State<UserConversationRoomsBody> {
  FirebaseHelper firebaseHelper = Get.find<FirebaseHelper>();

  Stream<QuerySnapshot<Map<String, dynamic>>>? chatRoomsStream;

  bool isLoading = false;

  @override
  void initState() {
    Constants.myEmail = firebaseHelper.auth.currentUser!.email!;
    chatRoomsStream = firebaseHelper.getChatRoomsLocalAuthority(
        userEmail: Constants.myEmail,
        completed: widget.completed,
        isWithHigher: widget.isWithHigher);
    super.initState();
  }

  Widget chatRoomList() {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: StreamBuilder(
        stream: chatRoomsStream,
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              child: const Center(
                child: Text(
                  "No Complaints",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                ),
              ),
            );
          } else if (snapshot.data!.docs.length == 0) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              child: const Center(
                child: Text(
                  "No Complaints",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return ChatRoomsTile(
                  completed: widget.completed,
                  username:
                      snapshot.data!.docs[index].data()["authority"].toString(),
                  isWithHigher: widget.isWithHigher,
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
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: chatRoomList(),
                  ),
                ],
              ),
            ),
          );
  }
}
