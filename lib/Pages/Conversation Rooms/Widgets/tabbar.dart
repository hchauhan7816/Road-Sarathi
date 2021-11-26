import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sadak/Config/palette.dart';

TabBar conversationRoomsTabBar() {
  return TabBar(
    indicatorSize: TabBarIndicatorSize.label,
    indicator: ShapeDecoration(
      color: Palette.orange,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    isScrollable: false,
    labelStyle: TextStyle(fontSize: 45.sp),
    tabs: const <Widget>[
      Tab(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "Ongoing Complaints",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
      ),
      Tab(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "Completed Complaints",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
      ),
    ],
  );
}

TabBar userLocalGovConversationRoomsTabBar() {
  return TabBar(
    indicatorSize: TabBarIndicatorSize.label,
    indicator: ShapeDecoration(
        color: Palette.orange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    isScrollable: false,
    labelStyle: TextStyle(fontSize: 45.sp),
    tabs: const <Widget>[
      Tab(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "Ongoing Complaints",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
      ),
      Tab(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "Completed Complaints",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
      ),
      Tab(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "Transfered Complaints",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
      ),
    ],
  );
}
