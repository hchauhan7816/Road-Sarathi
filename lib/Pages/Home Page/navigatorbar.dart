import 'package:flutter/material.dart';
import 'constants.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 155, vertical: 10),
      height: 80,
      color: Color(0xFFF5CEB8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const <Widget>[
          // ignore: prefer_const_constructors
          Center(
              child: Text('Road Sarthi',
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ))),
        ],
      ),
    );
  }
}
