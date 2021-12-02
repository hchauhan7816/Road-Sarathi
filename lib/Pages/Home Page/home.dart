import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadak/Config/constants.dart';
import 'package:sadak/Config/palette.dart';
import 'package:sadak/Pages/About%20Us%20Page/about_us_screen.dart';
import 'package:sadak/Pages/Complaint%20Page/complaint.dart';
import 'package:sadak/Pages/Conversation%20Rooms/conversation_rooms.dart';
import 'package:sadak/Pages/Conversation%20Rooms/user_higher_conversation_rooms.dart';
import 'package:sadak/Pages/Conversation%20Rooms/user_local_conversation_rooms.dart';
import 'package:sadak/Pages/Home%20Page/Widgets/category_card.dart';
import 'package:sadak/Services/Controllers/auth_controller.dart';

import 'Widgets/navigatorbar.dart';

const String _USERS = "users";
const String _EMAIL = "email";

const String _LOCALAUTHORITYMAIL = "localauthority@gmail.com";
const String _HIGHERAUTHORITYMAIL = "higherauthority@gmail.com";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseHelper firebaseHelper = Get.find<FirebaseHelper>();
  bool isLoading = false;

  @override
  void initState() {
    Constants.myEmail = firebaseHelper.auth.currentUser!.email!;

    findName();

    navigateUser();
    checkAllComplaints();
    super.initState();
  }

  findName() async {
    var val = await firebaseHelper.getUserWithEmail(email: Constants.myEmail);
    Constants.myName = val.name;
  }

  navigateUser() async {
    setState(() {
      isLoading = true;
    });

    int? x;

    await firebaseHelper.firebaseFirestore
        .collection(_USERS)
        .where(_EMAIL, isEqualTo: Constants.myEmail)
        .get()
        .then((value) {
      value.docs.isNotEmpty ? x = value.docs[0].data()["status"] : x = null;
    });

    if (x != null) {
      if (x != 0) {
        if (x == 1) {
          Get.offAll(
              () => GovConversationRooms(authorityEmail: _LOCALAUTHORITYMAIL));
        } else {
          Get.offAll(
              () => GovConversationRooms(authorityEmail: _HIGHERAUTHORITYMAIL));
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  checkAllComplaints() {
    firebaseHelper.getAllChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: <Widget>[
                Container(
                  height: size.height * .45,
                  decoration: const BoxDecoration(
                    color: Palette.peach,
                    image: DecorationImage(
                        alignment: Alignment.centerLeft,
                        image:
                            AssetImage("assets/img/undraw_pilates_gpdb.png")),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                firebaseHelper.signout();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 52,
                                width: 52,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF2BEA1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.logout_outlined),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Welcome",
                                style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 32,
                                  height: 1.2,
                                ),
                              ),
                              Text(
                                "${Constants.myName.substring(0, 1).toUpperCase()}${Constants.myName.substring(1)}",
                                style: const TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 32,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: .80,
                            crossAxisSpacing: 30,
                            mainAxisSpacing: 30,
                            padding: const EdgeInsets.symmetric(
                                vertical: 70, horizontal: 10),
                            children: <Widget>[
                              CategoryCard(
                                title: "New Complaint",
                                svgSrc: "assets/img/new_complaint.svg",
                                press: () {
                                  Get.to(() => const ComplaintPage());
                                },
                              ),
                              CategoryCard(
                                title: "Local Authority Complaint",
                                svgSrc: "assets/img/active_complaint.svg",
                                press: () {
                                  Get.to(() => const UserConversationRooms());
                                },
                              ),
                              CategoryCard(
                                  title: "Higher Authority Complaint",
                                  svgSrc: "assets/img/solved_complaint.svg",
                                  press: () {
                                    Get.to(() =>
                                        const UserHigherConversationRooms());
                                  }),
                              CategoryCard(
                                title: "About Us",
                                svgSrc: "assets/img/about_us.svg",
                                press: () {
                                  Get.to(() => const AboutUsPage());
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
