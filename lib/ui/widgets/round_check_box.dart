import 'package:flutter/material.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
///圆形单选框
class RoundCheckBox extends StatefulWidget {
  var value = false;

  Function(bool) onChanged;

  RoundCheckBox({Key key, @required this.value, this.onChanged})
      : super(key: key);

  @override
  _RoundCheckBoxState createState() => _RoundCheckBoxState();
}

class _RoundCheckBoxState extends State<RoundCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
          onTap: () {
            widget.value = !widget.value;
            widget.onChanged(widget.value);
          },
          child: Padding(
            padding:  EdgeInsets.all(ScreenAdaper.width(1)),
            child: widget.value
                ? Icon(
              Icons.check_circle,
              size: ScreenAdaper.width(36),
              color: ColorsUtil.hexToColor("#FE3D3D"),
            )
                : Icon(
              Icons.panorama_fish_eye,
              size: ScreenAdaper.width(36),
              color: ColorsUtil.hexToColor("#DCDCDC")
            ),
          )),
    );
  }
}