import 'package:flutter/material.dart';
/*
 *系统主题设置，包括系统默认字体 背景色等
 */
class GlobalConfig {
  static bool isDebug = false;//是否是调试模式
  static bool dark = false;

  static Color fontColor = Colors.black54;
  static String baseUrl =  "http://test.olamall.vn:8080/" ;
  static String consumer_secret =   "cs_f112f99e5567445ec43c17342a776032daa90ec4" ;
  static String consumer_key = "ck_510f0aed08b0157979dc595bf6d9989b0687f4fe" ;
}