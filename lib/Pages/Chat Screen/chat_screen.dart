import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sadak/Config/constants.dart';
import 'package:sadak/Config/palette.dart';
import 'package:sadak/Modal/chat_messages.dart';
import 'package:sadak/Pages/Chat%20Screen/Widgets/tiles.dart';
import 'package:sadak/Services/Controllers/auth_controller.dart';
import 'package:sadak/Widgets/custom_scaffold.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer' as dev;

import 'Widgets/appbar_chat_screen.dart';

const String _TITLE = "title";
const String _LOCATION = "location";
const String _DUEDATE = "dueDate";

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    Key? key,
    required this.chatroomId,
    required this.completed,
    required this.isWithHigher,
    required this.userEmail,
  }) : super(key: key);
  final String chatroomId;
  final bool completed;
  final bool isWithHigher;
  final String userEmail;

  @override
  Widget build(BuildContext context) {
    // dev.log(userEmail);
    return CustomScaffold(
      body: ChatScreenBody(
        completed: completed,
        isWithHigher: isWithHigher,
        chatroomId: chatroomId,
        userEmail: userEmail,
      ),
      backgroundColor: Palette.peach, //Colors.blueGrey, //Color(0xFFFFFFF6),
      appBar: chatScreenAppBar(
        context,
        userEmail: userEmail,
        chatroomId: chatroomId,
        completed: completed,
      ),
    );
  }
}

class ChatScreenBody extends StatefulWidget {
  final String chatroomId;
  final bool completed;
  final bool isWithHigher;
  final String userEmail;
  const ChatScreenBody(
      {required this.chatroomId,
      required this.completed,
      required this.isWithHigher,
      required this.userEmail,
      Key? key})
      : super(key: key);

  @override
  State<ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  TextEditingController messageController = TextEditingController();
  FirebaseHelper firebaseHelper = Get.find<FirebaseHelper>();
  Stream<QuerySnapshot<Map<String, dynamic>>>? messages;
  Stream<QuerySnapshot<Map<String, dynamic>>>? heading;
  bool isUploading = false;
  File? imageFile;
  String? ImageUrl;

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
      child: isUploading
          ? Container(
              height: MediaQuery.of(context).size.height / 1.3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Uploading Image",
                      style: TextStyle(
                          height: 1.2,
                          fontSize: 35,
                          fontWeight: FontWeight.w300,
                          color: Colors.white70),
                    ),
                  ],
                ),
              ),
            )
          : Column(
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
                )),
                if (!widget.completed)
                  buildChatComposer()
                else if (widget.isWithHigher)
                  disabledChatComposer(
                      message: "Complaint Transferred to Higher Authority")
                else
                  disabledChatComposer(message: "Complaint Closed")
              ],
            ),
    );
  }

  Container disabledChatComposer({required String message}) {
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
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.center,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: message,
                        hintStyle: TextStyle(
                          color: Colors.grey[700],
                          height: 1.2,
                        ),
                      ),
                      controller: messageController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
                  // Icon(
                  //   Icons.emoji_emotions_outlined,
                  //   color: Colors.grey[500],
                  // ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type your message ...',
                        hintStyle: TextStyle(
                          height: 1.2,
                          color: Colors.grey[500],
                        ),
                      ),
                      controller: messageController,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      getImage();
                    },
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

  void sendDetails({required userEmail}) {
    int val = DateTime.now().millisecondsSinceEpoch;

    if (ImageUrl != null && ImageUrl!.isNotEmpty) {
      firebaseHelper.setConversationMessages(
          chatroomId: widget.chatroomId,
          messageMap: ModalChatMessages(
                  message: ImageUrl!,
                  sendBy: userEmail, //Constants.myEmail, // userEmail,
                  text: false,
                  isLocation: false,
                  time: DateTime.now().millisecondsSinceEpoch)
              .toJson());
    } else {
      // Todo
      Get.snackbar("Unable to Proceed", "Image not Uploaded");
    }
  }

  Future getImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) async {
      if (xFile != null) {
        imageFile = File(xFile.path);
        await uploadImage();
        sendDetails(userEmail: widget.userEmail);
      }
    });
  }

  uploadImage() async {
    // Todo wait till is uploading

    setState(() {
      isUploading = true;
    });

    String fileName = Uuid().v1();

    var ref =
        await FirebaseStorage.instance.ref().child('images').child(fileName);

    var uploadTask = await ref.putFile(imageFile!);

    ImageUrl = await uploadTask.ref.getDownloadURL();

    setState(() {
      isUploading = false;
    });
  }

  sendMessage({required userEmail}) {
    if (messageController.text.isNotEmpty) {
      firebaseHelper.setConversationMessages(
          chatroomId: widget.chatroomId,
          messageMap: ModalChatMessages(
                  message: messageController.text,
                  sendBy: userEmail, //Constants.myEmail, // userEmail,
                  text: true,
                  isLocation: false,
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
                    dueDate:
                        snapshot.data!.docs[index].data()[_DUEDATE].toDate(),
                  );
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
                // reverse: true,
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
                    time: snapshot.data!.docs[index].data()["time"],
                    message: snapshot.data!.docs[index].data()["message"],
                    isSendByMe: snapshot.data!.docs[index].data()["sendBy"] ==
                        widget.userEmail,
                    isText: snapshot.data!.docs[index].data()["text"],
                    isLocation: snapshot.data!.docs[index].data()["isLocation"],
                    latitude: snapshot.data!.docs[index].data()["latitude"],
                    longitude: snapshot.data!.docs[index].data()["longitude"],
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
