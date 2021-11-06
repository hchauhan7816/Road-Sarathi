import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sadak/Config/constants.dart';
import 'package:sadak/Config/text_styles.dart';
import 'package:sadak/Modal/users.dart';
import 'package:sadak/Pages/Chat%20Screen/Widgets/chat_tile.dart';
import 'package:sadak/Pages/Chat%20Screen/chat_screen.dart';
import 'package:sadak/Pages/On%20Boarding/on_boarding.dart';
import 'package:sadak/Services/Controllers/auth_controller.dart';
import 'package:sadak/Widgets/custom_scaffold.dart';
import 'dart:developer' as dev;

const String _CHATROOMID = "chatroomId";

class GovConversationRooms extends StatelessWidget {
  const GovConversationRooms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        body: GovConversationRoomsBody(),
        backgroundColor: Colors.blueGrey,
        appBar: govConversationRoomsAppBar(context));
  }
}

AppBar govConversationRoomsAppBar(BuildContext context) {
  return AppBar(
    elevation: 10,
    title: Text("Chat Room"),
    centerTitle: true,
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    leading: IconButton(
      onPressed: () {
        Get.back();
      },
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      iconSize: 20,
      color: Colors.black,
    ),
    actions: [
      GestureDetector(
        onTap: () {
          // authMethods.signOut();
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => Authenticate(),
          //   ),
          // );
          Get.offAll(() => OnBoarding());
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Icon(Icons.logout),
        ),
      ),
    ],
  );
}

FloatingActionButton govConversationRoomsFloatingActionButton(context) {
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

class GovConversationRoomsBody extends StatefulWidget {
  GovConversationRoomsBody({Key? key}) : super(key: key);

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
    // getUserInfo();
    chatRoomsStream =
        firebaseHelper.getAuthorityChatRooms(userEmail: Constants.myEmail);
    super.initState();
  }

  initiateSearch(String searchValue) {
    // databaseMethods
    //     .getUserByUsername(searchTextEditingController.text)
    //     .then((e) {
    //   setState(() {
    //     searchSnapshot = e;
    //   });
    // });

    setState(() {
      isLoading = true;
    });

    // dev.log("Here");

    searchResult =
        firebaseHelper.searchWithAlreadyConnectedUsers(userEmail: searchValue);

    // dev.log(searchResult);
    // dev.log("Done");

    setState(() {
      isLoading = false;
    });
  }

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.data == null) {
          return Center(child: Text("Nothing to show"));
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            // dev.log(
            //     "${snapshot.data!.docs.length}  \n\n\n${snapshot.data!.docs[index].data()[CHATROOM]}");
            return ChatRoomsTile(
                username:
                    snapshot.data!.docs[index].data()["authority"].toString(),
                // .replaceAll(Constants.myEmail, "")
                // .replaceAll("_", ""),
                chatRoomId:
                    snapshot.data!.docs[index].data()[_CHATROOMID].toString());
          },
        );
      },
    );

    // return Text("Hello");
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

      // dev.log("Done CreateChatroomAndStartConversation");
      firebaseHelper.createChatRooms(
          userEmail1: Constants.myEmail,
          userEmail2: clickedUserEmail,
          chatroomId: chatroomId,
          chatroomMap: chatroomMap);

      Get.to(ChatScreen(
        chatRoomId: chatroomId,
      ));
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
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    final size = MediaQuery.of(context).size;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              Column(
                children: [
                  Container(
                    color: const Color(0x54FFFFFF),
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (val) {
                              searchValue = val;
                              if (searchValue == null) {
                                Get.snackbar("Invalid", "Enter correct email");
                                return;
                              }
                              initiateSearch(searchValue!);
                            },
                            controller: searchTextController,
                            // style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "search username...",
                              hintStyle: TextStyle(
                                color: Colors.white54,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (searchValue == null) {
                              Get.snackbar("Invalid", "Enter correct email");
                              return;
                            }
                            initiateSearch(searchValue!);
                          },
                          child: Container(
                            height: 48,
                            width: 48,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0x36FFFFFF),
                                  const Color(0x0FFFFFFF)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            // color: Colors.red,
                            child: Icon(Icons.search),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              (searchValue == null || searchValue!.isNotEmpty)
                  ? searchList()
                  : Container(
                      margin: EdgeInsets.only(top: 8),
                      child: chatRoomList(),
                    ),
            ],
          );
  }
}
