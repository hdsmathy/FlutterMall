import 'package:flutter/material.dart';
import 'package:olamall_app/constant/images.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';

import 'ColorsUtil.dart';

class UiUtils {
  /**
   * 有返回键
   */
  static Widget getAppBarStyle(String msg, {BuildContext context}) {
    return AppBar(
      title: Text(
        msg,
        style: TextStyle(
            fontSize: ScreenAdaper.sp(36), color: Color.fromRGBO(0, 0, 0, 1)),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: ColorsUtil.hexToColor("#010101"),
        ),
        onPressed: () {
          Navigator.pop(context,true);
        },
      ),
    );
  }

  /**
   * 有返回键 自定义点击事件
   */
  static Widget getAppBar(String msg, Function onClick) {
    return AppBar(
      title: Text(
        msg,
        style: TextStyle(
            fontSize: ScreenAdaper.sp(36), color: Color.fromRGBO(0, 0, 0, 1)),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: ColorsUtil.hexToColor("#010101"),
        ),
        onPressed: onClick,
      ),
    );
  }

  /**
   * 没有返回键
   */
  static Widget getAppBarNoBackStyle(String msg) {
    return AppBar(
      title: Text(
        msg,
        style: TextStyle(
            fontSize: ScreenAdaper.sp(36), color: Color.fromRGBO(0, 0, 0, 1)),
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
    );
  }

  /**
   * 没有返回键
   */
  static Widget getTextBlack26(String text, {maxLine}) {
    return Text(
      text,
      maxLines: maxLine,
      overflow: maxLine != null && maxLine > 0
          ? TextOverflow.ellipsis
          : TextOverflow.fade,
      style: TextStyle(
          fontSize: ScreenAdaper.sp(26), color: Color.fromRGBO(0, 0, 0, 1)),
    );
  }
}
