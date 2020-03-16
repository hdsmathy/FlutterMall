import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:olamall_app/config/Config.dart';
import 'package:olamall_app/constant/images.dart';
import 'package:olamall_app/event/event.dart';
import 'package:olamall_app/model/LoginModel.dart';
import 'package:olamall_app/net/DioManager.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/mall.dart';
import 'package:olamall_app/ui/password/retrieve_password.dart';
import 'package:olamall_app/ui/register/register.dart';
import 'package:olamall_app/ui/widgets/progress_dialog.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'dart:ui';
import 'package:olamall_app/constant/string.dart';
import 'package:olamall_app/utils/LogUtil.dart';
import 'package:olamall_app/utils/SharePreferencesUtil.dart';
import 'package:olamall_app/utils/ToastUtils.dart';
import 'package:olamall_app/utils/UiUtils.dart';

/**
 * 登陆界面
 */
class LoginView extends StatefulWidget {
  int _loginType = 1;

  ///登陆类型  1为 email 登陆 ;2 为mobile 登陆

  LoginView(this._loginType);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var _username;
  var _password;

  TextEditingController _mobileController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  //是否显示密码
  bool _isShowPassWord = true;
  var _showLoginType;
  var _showOtherLoginType;
  var _showInputType; //输入账号的类型 email or mobile

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    _mobileController.addListener(() {
      _username = _mobileController.text.toString();
    });

    _passwordController.addListener(() {
      _password = _passwordController.text.toString();
    });

    judgeType();

    // TODO: implement build
    return Container(
      color: Colors.white,
      child: Scaffold(
          appBar: UiUtils.getAppBar("", () => Navigator.pop(context, true)),
          body: ProgressDialog(loading: _loading, child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(31, 33, 0, 0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    Strings.LOGIN,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),

                ///输入账号 email or  mobile
                Container(
                  margin: EdgeInsets.fromLTRB(31, 33, 0, 0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _showLoginType,
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: TextField(
                    controller: this._mobileController,
                    autofocus: false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    keyboardType: _showInputType,
                  ),
                ),

                ///输入密码
                Container(
                  margin: EdgeInsets.fromLTRB(31, 33, 0, 0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    Strings.PASSWORD,
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: TextField(
                    controller: this._passwordController,
                    autofocus: false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, top: 10),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_isShowPassWord
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          showPassWord();
                        },
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: _isShowPassWord,
                  ),
                ),

                ///忘记密码 其他登陆方式
                Container(
                  margin: EdgeInsets.fromLTRB(31, 10, 25, 0),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          child: Text(
                            Strings.FORGET_PASSWORD,
                            style: TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                          onTap: () => gotoForgetPasswordPage(),

                          ///跳转到忘记密码界面
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: Text(
                            _showOtherLoginType,
                            style: TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                          onTap: () =>
                              gotoOtherLoginPage(), // 跳转到email 登陆界面
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ),

                ///点击登陆
                Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  width: MallApp.screenWidth - 23 - 23,
                  height: 44,
                  alignment: Alignment.center,
                  child: MaterialButton(
                    onPressed: () {
                      print("点击登录");
                      _loginPost();
                    },
                    child: Text(
                      Strings.LOGIN,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    color: ColorsUtil.hexColor(0xF83D00),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(20))),
                    minWidth: double.infinity,
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      child: RichText(
                          text: TextSpan(
                              text: Strings.LOGIN_TIPS_ONE,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 12),
                              children: <TextSpan>[
                                TextSpan(
                                    text: Strings.LOGIN_TIPS_TWO,
                                    style: TextStyle(
                                        color: ColorsUtil.hexColor(0xF83D00),
                                        fontSize: 12)),
                              ])),
                      onTap: () => gotoRegisterPage(),
                    )),
              ],
            ),
          ))))
    ;
  }

  ///登陆
  void _loginPost() async {
    if (widget._loginType == 1 && _username == null) {
      ToastUtils.showToast("Email not null");
      return;
    }
    if (widget._loginType == 2 && _username == null) {
      ToastUtils.showToast("Mobile not null");
      return;
    }
    if (_password == null) {
      ToastUtils.showToast("Password not null");
      return;
    }

    ///邮箱
    if (widget._loginType == 1 && !_username.toString().contains("@")) {
      ToastUtils.showToast("Please enter the correct account number");
      return;
    }

    ///手机
    if (widget._loginType == 2 && _username.toString().contains("@")) {
      ToastUtils.showToast("Please enter the correct account number");
      return;
    }
    setState(() {
      _loading = true;
    });
    var instance = DioManager.getInstance();
    var params = FormData();

    params.add("username", _username);
    params.add("password", _password);

    await instance.post(Config.LOGIN, params, (data) {
      if (data['code'] == 200) {



        var loginModel = new LoginModel.fromJson(data);
        Data modelData = loginModel.data[0];

        ///存储用户信息
        SharePreferencesUtil.saveMsg(
            true,
            modelData.iD,
            modelData.userLogin,
            modelData.userNicename,
            modelData.userEmail,
            modelData.userUrl,
            modelData.userRegistered,
            modelData.userActivationKey,
            modelData.userStatus,
            modelData.displayName,
            modelData.userPhone,
            modelData.userInvitationCode,
            modelData.distributionUid,
            modelData.token);
        ToastUtils.showToast("Login Success");

        //登陆成功后关闭当前页面

        Navigator.of(context).popUntil(ModalRoute.withName('/main'));
        eventBus.fire(MainSelectEvent(3));
        eventBus.fire(MineSelectEvent(true));
        eventBus.fire(CarEvent(0));

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
      LogUtil.logE("LoginView", e.toString());
    });
  }

  //判断登陆方式
  void judgeType() {
    if (widget._loginType == 2) {
      _showLoginType = Strings.TYPE_MOBILE;
      _showOtherLoginType = Strings.OTHER_LOGIN_TYPE_EMAIL;
      _showInputType = TextInputType.phone;
    } else {
      _showLoginType = Strings.TYPE_EMAIL;
      _showOtherLoginType = Strings.OTHER_LOGIN_TYPE_MOBILE;
      _showInputType = TextInputType.emailAddress;
    }
  }

  //密码显示隐藏
  void showPassWord() {
    setState(() {
      _isShowPassWord = !_isShowPassWord;
    });
  }

  //跳转到注册页面
  void gotoRegisterPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterView(1)));
  }

  //跳转到忘记密码界面
  void gotoForgetPasswordPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => RetrievePasswordView(1)));
  }

  //跳转到其他登陆界面
  void gotoOtherLoginPage() {
    if (widget._loginType == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginView(2)));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginView(1)));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _mobileController?.dispose();
    _passwordController?.dispose();
  }
}
