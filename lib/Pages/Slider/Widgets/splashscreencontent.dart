import 'package:flutter/material.dart';
import 'package:sadak/Config/size_config.dart';
import 'package:sadak/Pages/Home%20Page/Widgets/constants.dart';

class SplashScreenContent extends StatelessWidget {
  const SplashScreenContent(
      {Key? key, required this.imageURL, required this.heading})
      : super(key: key);

  final String heading, imageURL;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
        Text(
          "Road Sarathi",
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1.2,
            fontSize: getProportionateScreenWidth(34),
            color: kActiveIconColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            heading,
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1.2,
              fontSize: getProportionateScreenWidth(24),
              color: kTextColor,
            ),
          ),
        ),
        const Spacer(flex: 3),
        Image.asset(
          imageURL,
          height: getProportionateScreenHeight(300),
          width: getProportionateScreenWidth(500),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}
