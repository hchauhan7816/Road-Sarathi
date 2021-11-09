import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadak/Config/constants.dart';
import 'package:sadak/Config/palette.dart';
import 'package:sadak/Modal/chat_messages.dart';
import 'package:sadak/Pages/Chat%20Screen/Widgets/tiles.dart';
import 'package:sadak/Services/Controllers/auth_controller.dart';
import 'package:sadak/Widgets/custom_scaffold.dart';
import 'dart:developer' as dev;

import 'Widgets/appbar_chat_screen.dart';

const String _TITLE = "title";
const String _LOCATION = "location";

class ChatScreen extends StatelessWidget {
  const ChatScreen(
      {Key? key, required this.chatroomId, required this.userEmail})
      : super(key: key);
  final String chatroomId;
  final String userEmail;

  @override
  Widget build(BuildContext context) {
    // dev.log(userEmail);
    return CustomScaffold(
        body: ChatScreenBody(chatroomId: chatroomId, userEmail: userEmail),
        backgroundColor: Colors.blueGrey, //Color(0xFFFFFFF6),
        appBar: chatScreenAppBar(context,
            userEmail: userEmail, chatroomId: chatroomId));
  }
}

class ChatScreenBody extends StatefulWidget {
  final String chatroomId;
  final String userEmail;
  const ChatScreenBody(
      {required this.chatroomId, required this.userEmail, Key? key})
      : super(key: key);

  @override
  State<ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  TextEditingController messageController = TextEditingController();
  FirebaseHelper firebaseHelper = Get.find<FirebaseHelper>();
  Stream<QuerySnapshot<Map<String, dynamic>>>? messages;
  Stream<QuerySnapshot<Map<String, dynamic>>>? heading;

  @override
  void initState() {
    Constants.myEmail = firebaseHelper.auth.currentUser!.email!;
    messages =
        firebaseHelper.getConversationMessages(chatroomId: widget.chatroomId);

    heading = firebaseHelper.getChatRoomsUsingChatroomId(
        chatroomId: widget.chatroomId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Color(0xFFFFFFF6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: chatMessageList(), //Conversation(user: widget.user),
              ),
            ),
          ),
          buildChatComposer()
        ],
      ),

      // Stack(
      //   children: [
      //     chatMessageList(),
      //     Container(
      //       alignment: Alignment.bottomCenter,
      //       child: Container(
      //         color: Color(0x54FFFFFF),
      //         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      //         child: Row(
      //           children: [
      //             Expanded(
      //               child: TextField(
      //                 controller: messageController,
      //                 style: TextStyle(color: Colors.white),
      //                 decoration: InputDecoration(
      //                   hintText: "Message...",
      //                   hintStyle: TextStyle(
      //                     color: Colors.white54,
      //                   ),
      //                   border: InputBorder.none,
      //                 ),
      //               ),
      //             ),
      //             GestureDetector(
      //               onTap: () {
      //                 sendMessage(userEmail: widget.userEmail);
      //               },
      //               child: Container(
      //                 height: 48,
      //                 width: 48,
      //                 padding: EdgeInsets.all(16),
      //                 decoration: BoxDecoration(
      //                   gradient: LinearGradient(
      //                     colors: [
      //                       const Color(0x36FFFFFF),
      //                       const Color(0x0FFFFFFF)
      //                     ],
      //                   ),
      //                   borderRadius: BorderRadius.circular(40),
      //                 ),
      //                 // color: Colors.red,
      //                 child: Icon(Icons.send),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Container buildChatComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      color: Color(0xFFFFFFF6),
      height: 80,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.grey[500],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type your message ...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      controller: messageController,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.attach_file,
                      color: Colors.grey[500],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          GestureDetector(
            onTap: () {
              sendMessage(userEmail: widget.userEmail);
            },
            child: CircleAvatar(
              radius: 25,
              backgroundColor:
                  Palette.orange, //Colors.amber, //MyTheme.kAccentColor,
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  sendMessage({required userEmail}) {
    if (messageController.text.isNotEmpty) {
      firebaseHelper.setConversationMessages(
          chatroomId: widget.chatroomId,
          messageMap: ModalChatMessages(
                  message: messageController.text,
                  sendBy: userEmail, //Constants.myEmail, // userEmail,
                  text: true,
                  time: DateTime.now().millisecondsSinceEpoch)
              .toJson());
      messageController.text = "";
    }
  }

  Widget chatMessageList() {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: heading,
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return HeadingTile(
                    title: snapshot.data!.docs[index].data()[_TITLE].toString(),
                    location:
                        snapshot.data!.docs[index].data()[_LOCATION].toString(),
                  );
                  return Container();
                },
              );
            },
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: messages,
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                // scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  // dev.log(
                  //     "Value    ----->     ${snapshot.data!.docs[index].data()["sendBy"]}");
                  return MessageTile(
                    otherUserEmail: widget.chatroomId
                        .replaceAll(widget.userEmail, "")
                        .replaceAll("_", ""),
                    message: snapshot.data!.docs[index].data()["message"],
                    isSendByMe: snapshot.data!.docs[index].data()["sendBy"] ==
                        widget.userEmail,
                    isText: snapshot.data!.docs[index].data()["text"],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
