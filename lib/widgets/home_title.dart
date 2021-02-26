import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomeTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 15, right: 15),
        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        decoration: new BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey[400],

            blurRadius: 45.0, // soften the shadow
            spreadRadius: 1.0, //extend the shadow
            offset: Offset(
              5.0, // Move to right 10  horizontally
              5.0, // Move to bottom 10 Vertically
            ),
          )
        ], color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: TypewriterAnimatedTextKit(
          onTap: () {
            print("Tap Event");
          },
          text: [
            "Start Typing",
          ],
          textStyle: Theme.of(context).textTheme.headline1,
          speed: Duration(milliseconds: 200),
          textAlign: TextAlign.center,
        ));
  }
}
