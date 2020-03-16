import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:olamall_app/ui/mall.dart';

void main() =>FlutterBugly.postCatchedException((){
runApp(MallApp());
});
