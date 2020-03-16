import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';

class ListTitleItem extends StatelessWidget {
  String title;
  String content;
  double padTop;
  double padBottom;

  ListTitleItem(
      {this.title = "Order",
      this.content = "thank you",
      this.padTop = 0,
      this.padBottom = 0});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
          ScreenAdaper.width(21),
          ScreenAdaper.height(padTop),
          ScreenAdaper.width(21),
          ScreenAdaper.height(padBottom)),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
            child: Text(
              title,
              style:
                  TextStyle(color: Colors.black, fontSize: ScreenAdaper.sp(26)),
            ),
          )),
          Container(
            child: Text(
              content,
              style:
                  TextStyle(color: Colors.black, fontSize: ScreenAdaper.sp(26)),
            ),
          )
        ],
      ),
    );
  }
}
