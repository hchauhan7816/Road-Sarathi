import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadak/Config/text_styles.dart';
import 'package:sadak/Pages/Chat%20Screen/chat_screen.dart';
import 'dart:developer' as dev;

class ChatRoomsTile extends StatelessWidget {
  const ChatRoomsTile(
      {Key? key,
      required this.username,
      required this.userEmail,
      required this.title,
      required this.chatRoomId})
      : super(key: key);

  final String username;
  final String userEmail;
  final String title;
  final String chatRoomId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ChatScreen(chatroomId: chatRoomId, userEmail: userEmail));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              alignment: Alignment.center,
              child: Text(
                "${username.substring(0, 1).toUpperCase()}",
                style: normal3(),
              ),
              decoration: BoxDecoration(
                color: Colors.blueGrey[200],
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 280),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "${title.substring(0, 1).toUpperCase()}${title.substring(1)}",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 280),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      username,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ],
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
  final String otherUserEmail;
  final bool isText;

  MessageTile(
      {required this.message,
      required this.isSendByMe,
      required this.isText,
      required this.otherUserEmail});

  @override
  Widget build(BuildContext context) {
    return isText
        ? Container(
            margin: EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: isSendByMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!isSendByMe)
                      Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "${otherUserEmail.substring(0, 1).toUpperCase()}",
                          style: normal3(),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[200],
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6),
                      decoration: BoxDecoration(
                          color: isSendByMe
                              ? Color(0xff7C7B9B)
                              : Colors.grey[200], // todo color?
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(isSendByMe ? 12 : 0),
                            bottomRight: Radius.circular(isSendByMe ? 0 : 12),
                          )),
                      child: Text(
                        message,
                        style: TextStyle(
                            color: isSendByMe ? Colors.white : Colors.grey[800],
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container(
            margin: EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: isSendByMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!isSendByMe)
                      Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "${otherUserEmail.substring(0, 1).toUpperCase()}",
                          style: normal3(),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[200],
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    //   CircleAvatar(
                    //     radius: 15,
                    //     backgroundImage: AssetImage(user.avatar),
                    //   ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                        padding: EdgeInsets.all(4),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6,
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.4),
                        decoration: BoxDecoration(
                            color: isSendByMe
                                ? Colors.blueGrey[300]
                                : Colors.grey[200], // todo color?
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                              bottomLeft: Radius.circular(isSendByMe ? 12 : 0),
                              bottomRight: Radius.circular(isSendByMe ? 0 : 12),
                            )),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: CachedNetworkImage(
                            imageUrl: message,
                            placeholder: (context, url) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        )),
                  ],
                ),
              ],
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
      margin: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8),
                decoration: BoxDecoration(
                    color: Colors.grey[300], // todo color?
                    // ? Color(0xff7C7B9B)

                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Title : $title",
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 16),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Location: $location",
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

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
