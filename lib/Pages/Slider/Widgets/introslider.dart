import 'package:flutter/material.dart';
import 'button.dart';
import 'constants.dart';
import 'splashscreencontent.dart';

class IntroSliderBody extends StatefulWidget {
  const IntroSliderBody({Key? key}) : super(key: key);

  @override
  _IntroSliderBodyState createState() => _IntroSliderBodyState();
}

class _IntroSliderBodyState extends State<IntroSliderBody> {
  int currentPage = 0;

  List<Map<String, String>> splashData = [
    {"heading": "Delivery and Payments", "image": "assets/img/login.png"},
    {
      "heading": "Instant Delivery and Payments",
      "image": "assets/img/login.png"
    },
    {
      "heading": "Enjoy Instant Delivery and Payments",
      "image": "assets/img/login.png"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) {
                  return SplashScreenContent(
                    heading: splashData[index]["heading"]!,
                    imageURL: splashData[index]["image"]!,
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          splashData.length, (index) => buildDot(index: index)),
                    ),
                    Spacer(),
                    introsliderdefaultbutton(
                      text: "CONTINUE",
                    ),
                    Spacer(),
                    // introslidertextbutton(
                    //   text: "SKIP",
                    // ),
                    // Spacer()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(right: 8),
      height: 7,
      width: currentPage == index ? 30 : 7,
      decoration: BoxDecoration(
        color: currentPage == index ? kActiveIconColor : Colors.black26,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
