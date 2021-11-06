import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sadak/Config/constants.dart';
import 'package:sadak/Config/palette.dart';
import 'package:sadak/Pages/Complaint%20Page/complaint.dart';
import 'package:sadak/Pages/Conversation%20Rooms/conversation_rooms.dart';
import 'package:sadak/Pages/Conversation%20Rooms/user_higher_conversation_rooms.dart';
import 'package:sadak/Pages/Conversation%20Rooms/user_local_conversation_rooms.dart';
import 'package:sadak/Pages/On%20Boarding/on_boarding.dart';
import 'package:sadak/Services/Controllers/auth_controller.dart';

const String _USERS = "users";
const String _EMAIL = "email";

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseHelper firebaseHelper = Get.find<FirebaseHelper>();

  @override
  void initState() {
    Constants.myEmail = firebaseHelper.auth.currentUser!.email!;

    // dev.log("email :: $email   \n\n password :: $password");

    // todo - Must have status 1 or 2
    Map<String, dynamic>? x;

    firebaseHelper.firebaseFirestore
        .collection(_USERS)
        .where(_EMAIL, isEqualTo: Constants.myEmail)
        .get()
        .then((value) {
      value.docs.isNotEmpty ? x = value.docs[0].data() : x = null;
    });

    if (x != null && x!['status'] != 0) {
      Get.offAll(() => GovConversationRooms());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                minWidth: double.infinity,
                height: 150.h,
                onPressed: () {},
                color: Palette.darkPurple,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Palette.darkPurple),
                  borderRadius: BorderRadius.circular(75.w),
                ),
                child: Text(
                  "${firebaseHelper.auth.currentUser!.email}",
                  style: TextStyle(
                    fontSize: 55.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 100.h,
              ),
              MaterialButton(
                minWidth: double.infinity,
                height: 150.h,
                onPressed: () {
                  firebaseHelper.signout();
                },
                color: Palette.darkPurple,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Palette.darkPurple),
                  borderRadius: BorderRadius.circular(75.w),
                ),
                child: Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 55.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 100.h,
              ),
              MaterialButton(
                minWidth: double.infinity,
                height: 150.h,
                onPressed: () {
                  Get.to(UserConversationRooms());
                },
                color: Palette.darkPurple,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Palette.darkPurple),
                  borderRadius: BorderRadius.circular(75.w),
                ),
                child: Text(
                  "Local Authority",
                  style: TextStyle(
                    fontSize: 55.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 100.h,
              ),
              MaterialButton(
                minWidth: double.infinity,
                height: 150.h,
                onPressed: () {
                  Get.to(UserHigherConversationRooms());
                },
                color: Palette.darkPurple,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Palette.darkPurple),
                  borderRadius: BorderRadius.circular(75.w),
                ),
                child: Text(
                  "Higher Authority",
                  style: TextStyle(
                    fontSize: 55.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 100.h,
              ),
              MaterialButton(
                minWidth: double.infinity,
                height: 150.h,
                onPressed: () {
                  Get.to(ComplaintPage());
                },
                color: Palette.darkPurple,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Palette.darkPurple),
                  borderRadius: BorderRadius.circular(75.w),
                ),
                child: Text(
                  "Create New Complaints",
                  style: TextStyle(
                    fontSize: 55.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
