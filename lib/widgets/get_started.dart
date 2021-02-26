import 'package:flutter/material.dart';

// import '../pages/game_screen.dart';

class GetStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
          onPressed: () => {Navigator.pushNamed(context, '/play')},
          color: Color(0xFAFAFA),
          splashColor: Color(0xFF4527A0),
          padding: EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFF4527A0),
            ),
            child: Text(
              "Get Started",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          )),
    );
  }
}
