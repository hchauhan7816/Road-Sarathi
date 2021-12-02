import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadak/Pages/On%20Boarding/on_boarding.dart';

import 'constants.dart';

class introslidertextbutton extends StatelessWidget {
  introslidertextbutton({
    Key? key,
    required this.text,
  }) : super(key: key);

  String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(
        text,
        style: const TextStyle(fontSize: 24, color: Colors.black),
      ),
    );
  }
}

class introsliderdefaultbutton extends StatelessWidget {
  introsliderdefaultbutton({
    Key? key,
    required this.text,
  }) : super(key: key);

  String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(kActiveIconColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
        ),
        onPressed: () {
          Get.offAll(const OnBoarding());
        },
        child: Text(
          text,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
