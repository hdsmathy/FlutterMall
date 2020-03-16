import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:olamall_app/config/Config.dart';
import 'package:olamall_app/constant/images.dart';
import 'package:olamall_app/constant/string.dart';
import 'package:olamall_app/model/SmsCodeModel.dart';
import 'package:olamall_app/net/DioManager.dart';
import 'package:olamall_app/ui/login/login.dart';
import 'package:olamall_app/ui/mall.dart';
import 'package:olamall_app/ui/widgets/progress_dialog.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/ToastUtils.dart';
import 'package:olamall_app/utils/UiUtils.dart';

///修改密码界面
class ConfirmPasswordView extends StatefulWidget {
  String _keywordes;
  int _type;
  String _code;
  String _zcode;

  ConfirmPasswordView(this._keywordes, this._type, this._code, this._zcode);

  @override
  _ConfirmPasswordViewState createState() => new _ConfirmPasswordViewState();
}

class _ConfirmPasswordViewState extends State<ConfirmPasswordView> {
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _rePasswordController = new TextEditingController();
  String _newPassword;
  String _newRePassword;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    _passwordController
        .addListener(() => _newPassword = _passwordController.text.toString());
    _rePasswordController.addListener(
        () => _newRePassword = _rePasswordController.text.toString());
    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: UiUtils.getAppBarStyle("", context: context),
        body: ProgressDialog(loading: _loading, child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ///默认头像
              Container(
                margin: EdgeInsets.only(top: 40),
                child: new ClipOval(
                  child: new Image.asset(RetrievePasswordImages.defaultIcon),
                ),
              ),

              /// Retrieve password
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  Strings.RETRIEVE_PASSWORD,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),

              /// new password
              Container(
                margin: EdgeInsets.fromLTRB(25, 56, 25, 0),
                child: TextField(
                  controller: this._passwordController,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: Strings.NEW_PASSWORD,
                    contentPadding: EdgeInsets.only(left: 10),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),

              ///confirm password
              Container(
                margin: EdgeInsets.fromLTRB(25, 46, 25, 0),
                child: TextField(
                  controller: this._rePasswordController,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: Strings.CONFIRM_PASSWORD,
                    contentPadding: EdgeInsets.only(left: 10),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),

              ///点击登陆
              Container(
                margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
                width: MallApp.screenWidth - 23 - 23,
                height: 44,
                alignment: Alignment.center,
                child: MaterialButton(
                  onPressed: () {
                    changePasswordPost();
                  },
                  child: Text(
                    Strings.RESET_PASSWORD,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  color: ColorsUtil.hexColor(0xF83D00),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  minWidth: double.infinity,
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  ///修改密码请求
  void changePasswordPost() {
    if (_newPassword == null || _newRePassword == null) {
      ToastUtils.showToast("Password not null");
      return;
    }
    setState(() {
      _loading = true;
    });
    var params = FormData();
    params.add("keywordes", widget._keywordes);
    params.add("type", widget._type);
    params.add("code", widget._code);
    params.add("zcode", widget._zcode);
    params.add("password", _newPassword);
    params.add("confirm_password", _newRePassword);

    DioManager.getInstance().post(Config.RETRIEVE_PASSWORD, params, (data) {
      if (data['code'] == 200) {
        ToastUtils.showToast("Change Success, Please Login");
        int type = 1;
        if (widget._type == 1)
          type = 2;
        else
          type = 1;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginView(type)),
        );
      } else {
        ToastUtils.showToast(data['message']);
      }
      setState(() {
        _loading = false;
      });
    }, (e) {
      setState(() {
        _loading = false;
      });
      ToastUtils.showToast("Server Exception");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _passwordController?.dispose();
    _rePasswordController?.dispose();
  }
}
