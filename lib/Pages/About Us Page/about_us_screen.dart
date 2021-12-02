import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sadak/Config/palette.dart';

import 'package:get/get.dart';
import 'package:sadak/Pages/Home%20Page/home.dart';
import 'Widgets/user_card.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AboutUsBody(),
    );
  }
}

class AboutUsBody extends StatelessWidget {
  const AboutUsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Container(
          height: size.height * .45,
          decoration: const BoxDecoration(
            color: Palette.peach,
            image: DecorationImage(
                alignment: Alignment.centerLeft,
                image: AssetImage("assets/img/undraw_pilates_gpdb.png")),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              Get.offAll(() => HomePage());
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 52,
                              width: 52,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF2BEA1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.home),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 180.h),
                      const Center(
                        child: Text(
                          "About Us",
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            fontSize: 45,
                            height: 1.2,
                          ),
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
                    children: const <Widget>[
                      UserCard(
                        userImage: "assets/img/aboutUs/Harsh.png",
                        name: "Harsh Chauhan",
                        enroll: "19103296",
                      ),
                      UserCard(
                        userImage: "assets/img/aboutUs/Jatin.png",
                        name: "Jatin Kansal",
                        enroll: "19103270",
                      ),
                      UserCard(
                        userImage: "assets/img/aboutUs/Deepanshu.png",
                        name: "Deepanshu Goel",
                        enroll: "19103269",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
