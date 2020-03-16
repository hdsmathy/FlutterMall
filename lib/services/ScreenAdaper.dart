
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ScreenAdaper{

  static init(context){
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
  }
  static height(double value){
     return ScreenUtil.getInstance().setHeight(value);
  }
  static width(double value){
      return ScreenUtil.getInstance().setWidth(value);
  }
  static getScreenHeight(){
    return ScreenUtil.screenHeightDp;
  }
  static getScreenWidth(){
    return ScreenUtil.screenWidthDp;
  }

  static getScreenPxHeight(){
    return ScreenUtil.screenHeight;
  }
  static getScreenPxWidth(){
    return ScreenUtil.screenWidth;
  }

  static sp(double value){
   return ScreenUtil().setSp(value) ; //传入字体大小，不会根据系统的“字体大小”辅助选项来进行缩放
  }
  // ScreenUtil.screenHeight
}

// ScreenAdaper