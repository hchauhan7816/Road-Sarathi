import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadak/Config/text_styles.dart';
import 'package:sadak/Pages/Chat%20Screen/chat_screen.dart';

class ChatRoomsTile extends StatelessWidget {
  const ChatRoomsTile(
      {Key? key, required this.username, required this.chatRoomId})
      : super(key: key);

  final String username;
  final String chatRoomId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ChatScreen(chatRoomId: chatRoomId));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              child: Text(
                "${username.substring(0, 1).toUpperCase()}",
                style: normal3(),
              ),
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            SizedBox(width: 12),
            Text(
              username,
              style: normal1(),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  final bool isText;

  MessageTile(
      {required this.message, required this.isSendByMe, required this.isText});

  @override
  Widget build(BuildContext context) {
    return isText
        ? Container(
            padding: EdgeInsets.only(
                left: isSendByMe ? 0 : 8, right: isSendByMe ? 8 : 0),
            width: MediaQuery.of(context).size.width,
            alignment:
                isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: isSendByMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomLeft: Radius.circular(23),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomRight: Radius.circular(23),
                      ),
                gradient: LinearGradient(
                    colors: isSendByMe
                        ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                        : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)]),
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
          )
        : Container(
            child: Image.network(
              message,
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width / 2,
            ),
          );
  }
}

class HeadingTile extends StatelessWidget {
  const HeadingTile({Key? key, required this.title, required this.location})
      : super(key: key);

  final String title;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(23),
              ),
              gradient: LinearGradient(
                  colors: [const Color(0xff007EF4), const Color(0xff2A75BC)]),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(23),
              ),
              gradient: LinearGradient(
                  colors: [const Color(0xff007EF4), const Color(0xff2A75BC)]),
            ),
            child: Text(
              location,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
