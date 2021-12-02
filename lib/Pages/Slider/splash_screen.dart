import 'package:flutter/material.dart';
import 'package:sadak/Config/size_config.dart';
import 'Widgets/introslider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
      backgroundColor: Colors.white,
      body: IntroSliderBody(),
    );
  }
}
