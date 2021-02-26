import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class Catalog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CatalogState();
  }
}

class _CatalogState extends State<Catalog> {
  List<List<String>> data = [
    ["Single Run"],
    ["Serious Dude"]
  ];
  int _focusedIndex = 0;

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }

  Widget _buildListItem(BuildContext context, int index) {
    //horizontal
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blueGrey[200],
          boxShadow: [
            _focusedIndex == index
                ? BoxShadow(
                    color: Colors.grey[400],

                    blurRadius: 25.0, // soften the shadow
                    spreadRadius: 1.0, //extend the shadow
                    offset: Offset(
                      2.0, // Move to right 10  horizontally
                      2.0, // Move to bottom 10 Vertically
                    ),
                  )
                : BoxShadow(color: Theme.of(context).backgroundColor)
          ]),
      width: MediaQuery.of(context).size.width * 0.65,
      margin: EdgeInsets.only(top: 120, bottom: 120),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            data[index][0],
            style: TextStyle(
                fontSize: 35,
                color: Colors.black54,
                fontWeight: FontWeight.w600),
          ),
          FlatButton(
            onPressed: () {
              print("Tap Event $index");
            },
            padding: EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.blue[400],
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                "Let's Go",
                style: TextStyle(fontSize: 20),
              ),
            ),
          )
        ],
      ),
      alignment: Alignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horizontal List Demo',
      home: Scaffold(
        body: Container(
          // alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ScrollSnapList(
                  onItemFocus: _onItemFocus,
                  itemSize: MediaQuery.of(context).size.width * 0.65,
                  itemBuilder: _buildListItem,
                  itemCount: data.length,
                  dynamicItemSize: true,
                  // dynamicSizeEquation: customEquation, //optional
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
