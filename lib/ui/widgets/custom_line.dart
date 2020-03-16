import 'package:flutter/material.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';


class CustomLine extends CustomPainter {
  Color lineColor;
  double width;
  double strokeWidth;

  CustomLine({this.lineColor, this.width, this.strokeWidth = 1.0});


  @override
  void paint(Canvas canvas, Size size) {

    Paint _paint = new Paint()
      ..color = lineColor??ColorsUtil.hexToColor("#F4F4F4")
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset((-(width/2)), 0.0), Offset(width/2, 0), _paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CustomHorLine extends CustomPainter {
  Color lineColor;
  double height;

  CustomHorLine({this.lineColor, this.height});

  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = new Paint()
      ..color =lineColor?? ColorsUtil.hexToColor("#F4F4F4")
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0.0, (-(height/2))), Offset(0.0, height/2), _paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}