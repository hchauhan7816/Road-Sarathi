import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      height: 80,
      color: Color(0xFFF5CEB8),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '\u00a9',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 25,
                fontWeight: FontWeight.w900,
                height: 1.2,
              ),
            ),
            Text(
              ' Road Sarthi',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
