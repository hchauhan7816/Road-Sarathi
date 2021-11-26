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
    return Container(
      child: Column(
        children: <Widget>[
          Spacer(),
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
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              heading,
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.2,
                fontSize: getProportionateScreenWidth(24),
                color: kTextColor,
                // fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Spacer(flex: 3),
          // Container(
          //   width: 100,
          //   height: 100,
          // ),
          // // Spacer(flex: 2,),
          Image.asset(
            "assets/img/login.png",
            height: getProportionateScreenHeight(285),
            width: getProportionateScreenWidth(245),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
