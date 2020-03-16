import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olamall_app/ui/widgets/search_appbar_state.dart';

class SearchAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final double height;
  final double elevation; //阴影
  final Widget leading;
  final String hintText;
  final FocusNode focusNode;
  final TextEditingController controller;
  final IconData prefixIcon;
  final List<TextInputFormatter> inputFormatters;
  final VoidCallback onEditingComplete;
  final String hintTextColor;

  const SearchAppBarWidget(
      {Key key,
      this.height: 46.0,
      this.elevation: 0.5,
      this.leading,
      this.hintText: '请输入关键词',
      this.focusNode,
      this.controller,
      this.inputFormatters,
      this.onEditingComplete,
      this.prefixIcon: Icons.search,
      this.hintTextColor:'#999999'})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchAppBarState();
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height); //这里设置控件（appBar）的高度
}
