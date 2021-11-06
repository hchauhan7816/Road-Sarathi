// import 'package:devfest/controllers/theme_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:share/share.dart';

// ignore: must_be_immutable
class CustomScaffold extends StatelessWidget {
  final Widget body;
  AppBar? appBar;
  FloatingActionButton? floatingActionButton;
  final Color backgroundColor;
  TabBar? tabBar;

  CustomScaffold(
      {Key? key,
      required this.body,
      this.floatingActionButton,
      this.appBar,
      this.tabBar,
      this.backgroundColor = Colors.white})
      : super(key: key);

  // ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      // color: themeController.isDarkMode.value ? Colors.grey[800] : Colors.white,
      color: Colors.white, // Todo
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        // appBar: wantAppbar
        //     ? AppBar(
        //         title: Text(title),
        //         bottom: tabBar,
        //         centerTitle: true,
        // ignore: prefer_const_literals_to_create_immutables
        // actions: [
        // Todo
        // Obx(
        //   () => IconButton(
        //     icon: themeController.isDarkMode.value
        //         ? Icon(
        //             FontAwesomeIcons.solidLightbulb,
        //             size: 55.sp,
        //           )
        //         : Icon(
        //             FontAwesomeIcons.lightbulb,
        //             size: 55.sp,
        //           ),
        //     onPressed: () {
        //       themeController.toggleTheme();
        //     },
        //   ),
        // ),
        // IconButton(
        //   onPressed: () {
        //     Share.share("App Made By Harsh Chauhan");
        //   },
        //   icon: Icon(
        //     Icons.share,
        //     size: 55.sp,
        //   ),
        // )
        //   ],
        // )
        // : null,
        body: body,
      ),
    );
  }
}
