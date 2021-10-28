import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadak/Widgets/custom_scaffold.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatScreenBody(),
      appBar: AppBar(
        elevation: 0,
        title: Text("Chat Screen"),
        centerTitle: true,
        brightness: Brightness.light,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          iconSize: 20,
          color: Colors.black,
        ),
      ),
    );

    return CustomScaffold(
        body: ChatScreenBody(), appBar: chatScreenAppBar(context));
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

class ChatScreenBody extends StatelessWidget {
  const ChatScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Hello"),
    );
  }
}
