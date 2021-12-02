import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String userImage;
  final String name;
  final String enroll;

  const UserCard({
    Key? key,
    required this.userImage,
    required this.name,
    required this.enroll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            const BoxShadow(
              color: Colors.grey,
              blurRadius: 10,
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 45.0,
              backgroundImage: AssetImage(userImage),
              backgroundColor: Colors.transparent,
            ),
            Spacer(flex: 6),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
            Spacer(),
            Text(
              enroll,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
            Spacer(flex: 4)
          ],
        ),
      ),
    );
  }
}
