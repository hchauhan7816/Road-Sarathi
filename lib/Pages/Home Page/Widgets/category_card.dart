import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class CategoryCard extends StatelessWidget {
  final String svgSrc;
  final String title;
  final void Function() press;
  const CategoryCard({
    Key? key,
    required this.svgSrc,
    required this.title,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
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
            ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,
                    maxHeight: MediaQuery.of(context).size.height / 7),
                child: SvgPicture.asset(svgSrc)),
            //     ),
            //   ),
            // ),
            Spacer(),
            Spacer(),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
              //todostyle: Theme.of(context).textTheme.title.copyWith(fontSize: 15),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
