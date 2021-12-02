import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadak/Config/constants.dart';
import 'package:sadak/Config/palette.dart';
import 'package:sadak/Config/text_styles.dart';
import 'package:sadak/Modal/users.dart';
import 'package:sadak/Pages/Chat%20Screen/Widgets/tiles.dart';
import 'package:sadak/Pages/Chat%20Screen/chat_screen.dart';
import 'package:sadak/Services/Controllers/auth_controller.dart';
import 'package:sadak/Widgets/custom_scaffold.dart';

import 'Widgets/appbar_conversation_rooms.dart';
import 'Widgets/tabbar.dart';

const String _CHATROOMID = "chatroomId";

const String _LOCALAUTHORITYMAIL = "localauthority@gmail.com";
const String _HIGHERAUTHORITYMAIL = "higherauthority@gmail.com";

// ignore: must_be_immutable
class GovConversationRooms extends StatelessWidget {
  GovConversationRooms({Key? key, required this.authorityEmail})
      : super(key: key);
  String authorityEmail;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: CustomScaffold(
        body: TabBarView(
          children: [
            GovConversationRoomsBody(
                authorityEmail: authorityEmail, completed: false),
            GovConversationRoomsBody(
                authorityEmail: authorityEmail, completed: true),
          ],
        ),
        backgroundColor: Palette.peach,
        appBar: govConversationRoomsAppBar(
          context,
          tabBar: conversationRoomsTabBar(),
        ),
      ),
    );
  }
}

FloatingActionButton govConversationRoomsFloatingActionButton(context) {
  return FloatingActionButton(
    child: const Icon(Icons.search_rounded),
    onPressed: () {},
  );
}

// ignore: must_be_immutable
class GovConversationRoomsBody extends StatefulWidget {
  GovConversationRoomsBody(
      {Key? key, required this.authorityEmail, required this.completed})
      : super(key: key);
  String authorityEmail;
  bool completed;

  @override
  State<GovConversationRoomsBody> createState() =>
      _GovConversationRoomsBodyState();
}

class _GovConversationRoomsBodyState extends State<GovConversationRoomsBody> {
  FirebaseHelper firebaseHelper = Get.find<FirebaseHelper>();

  TextEditingController searchTextController = TextEditingController();
  Future<List<ModalUser>>? searchResult;
  Stream<QuerySnapshot<Map<String, dynamic>>>? chatRoomsStream;
  String? searchValue = "";

  bool isLoading = false;

  @override
  void initState() {
    Constants.myEmail = firebaseHelper.auth.currentUser!.email!;

    chatRoomsStream = firebaseHelper.getAuthorityChatRooms(
        userEmail: widget.authorityEmail, completed: widget.completed);

    super.initState();
  }

  initiateSearch(String searchValue) {}

  Widget chatRoomList() {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: StreamBuilder(
        stream: chatRoomsStream,
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.data == null) {
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
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return ChatRoomsTile(
                  isWithHigher: false,
                  completed: widget.completed,
                  username:
                      snapshot.data!.docs[index].data()["users"].toString(),
                  userEmail: widget.authorityEmail,
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

  createChatroomAndStartConversation(String clickedUserEmail) {
    String users = Constants.myEmail;
    int time = DateTime.now().millisecondsSinceEpoch;
    String chatroomId = firebaseHelper.getChatroomId(
        userEmail1: Constants.myEmail, userEmail2: clickedUserEmail, val: time);

    if (clickedUserEmail != Constants.myEmail) {
      Map<String, dynamic> chatroomMap = {
        "users": clickedUserEmail,
        "authority": users,
        "chatroomId": chatroomId
      };

      firebaseHelper.createChatRooms(
          userEmail1: Constants.myEmail,
          userEmail2: clickedUserEmail,
          chatroomId: chatroomId,
          chatroomMap: chatroomMap);

      Get.to(
        ChatScreen(
          completed: false,
          isWithHigher: false,
          chatroomId: chatroomId,
          userEmail: Constants.myEmail,
        ),
      );
    }
  }

  Widget searchList() {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<List<ModalUser>> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return searchTile(
                    name: snapshot.data![index].name,
                    email: snapshot.data![index].email,
                  );
                },
              )
            : Container();
      },
      future: searchResult,
    );
  }

  Widget searchTile({required String email, required String name}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: normal1(),
              ),
              Text(
                email,
                style: normal1(),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndStartConversation(email);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.blue,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Message",
                style: normal2(),
              ),
            ),
          )
        ],
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: const [],
                    ),
                    (searchValue == null || searchValue!.isNotEmpty)
                        ? searchList()
                        : Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: chatRoomList(),
                          ),
                  ],
                ),
              ),
            ),
          );
  }
}
