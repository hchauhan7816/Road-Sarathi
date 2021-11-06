import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadak/Config/constants.dart';
import 'package:sadak/Modal/chat_messages.dart';
import 'package:sadak/Pages/Chat%20Screen/Widgets/chat_tile.dart';
import 'package:sadak/Services/Controllers/auth_controller.dart';
import 'package:sadak/Widgets/custom_scaffold.dart';
import 'dart:developer' as dev;

const String _TITLE = "title";
const String _LOCATION = "location";

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key, required this.chatRoomId}) : super(key: key);
  final String chatRoomId;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        body: ChatScreenBody(chatRoomId: chatRoomId),
        backgroundColor: Colors.blueGrey,
        appBar: chatScreenAppBar(context));
  }
}

AppBar chatScreenAppBar(BuildContext context) {
  return AppBar(
    elevation: 10,
    title: Text("Chat Screen"),
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
  );
}

class ChatScreenBody extends StatefulWidget {
  final String chatRoomId;
  const ChatScreenBody({required this.chatRoomId, Key? key}) : super(key: key);

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
        firebaseHelper.getConversationMessages(chatroomId: widget.chatRoomId);

    heading = firebaseHelper.getChatRoomsUsingChatroomId(
        chatroomId: widget.chatRoomId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        chatMessageList(),
        Container(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Color(0x54FFFFFF),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Message...",
                      hintStyle: TextStyle(
                        color: Colors.white54,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
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
                    child: Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      firebaseHelper.setConversationMessages(
          chatroomId: widget.chatRoomId,
          messageMap: ModalChatMessages(
                  message: messageController.text,
                  sendby: Constants.myEmail,
                  text: true,
                  time: DateTime.now().millisecondsSinceEpoch)
              .toJson());
      messageController.text = "";
    }
  }

  Widget chatMessageList() {
    return Column(
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
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                // dev.log(
                //     "Value    ----->     ${snapshot.data!.docs[index].data()["sendBy"]}");
                return MessageTile(
                  message: snapshot.data!.docs[index].data()["message"],
                  isSendByMe: snapshot.data!.docs[index].data()["sendBy"] ==
                      Constants.myEmail,
                  isText: snapshot.data!.docs[index].data()["text"],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
