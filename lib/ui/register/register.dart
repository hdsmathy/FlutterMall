import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:olamall_app/config/Config.dart';
import 'package:olamall_app/constant/images.dart';
import 'package:olamall_app/model/RegisterModel.dart';
import 'package:olamall_app/model/SmsCodeModel.dart';
import 'package:olamall_app/net/DioManager.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/login/login.dart';
import 'package:olamall_app/ui/mall.dart';
import 'package:olamall_app/ui/widgets/progress_dialog.dart';
import 'package:olamall_app/utils/AppUtil.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'dart:ui';
import 'package:olamall_app/constant/string.dart';
import 'package:olamall_app/utils/LogUtil.dart';
import 'package:olamall_app/utils/ToastUtils.dart';
import 'package:olamall_app/utils/UiUtils.dart';

/**
 * 注册页面
 */
class RegisterView extends StatefulWidget {
  int _registerType = 2;

  /// 判断注册类型  1 为 email登陆 , 2 为mobile 登陆

  RegisterView(this._registerType);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController _mobileController = new TextEditingController();
  TextEditingController _smsController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _invitationCodeController = new TextEditingController();

  String _accountNumber;
  String _smsCode;
  String _password;
  String _invitationCode;

  bool _isShowPassWord = true;
  bool _isShowRePassWord = true;
  bool _isShowSms = true;
  var _showRegisType;
  var _showOtherRegisType;
  var _showInputType;

  int _time = 60;
  Timer _timer;
  bool _isButtonEnable = true;
  String _btnShowMsg = Strings.SEND;

  bool _loading = false;
  String _zcode;

  @override
  Widget build(BuildContext context) {
    judgeType();
    //设置监听获取注册信息
    _mobileController
        .addListener(() => _accountNumber = _mobileController.text.toString());
    _passwordController
        .addListener(() => _password = _passwordController.text.toString());
    _invitationCodeController.addListener(
        () => _invitationCode = _invitationCodeController.text.toString());
    if (widget._registerType == 2) {
      _smsController
          .addListener(() => _smsCode = _smsController.text.toString());
    }
    // TODO: implement build
    return new Container(
      color: Colors.white,
      child:  Scaffold(
        appBar: UiUtils.getAppBarStyle("",context: context),
        body: ProgressDialog(loading: _loading, child: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              Container(
                margin: EdgeInsets.fromLTRB(31, 33, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  Strings.SINGN_UP,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),

              ///输入账号 mobile or email
              Container(
                margin: EdgeInsets.fromLTRB(31, 33, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  _showRegisType,
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

              Visibility(
                  visible: _isShowSms,
                  child: Column(
                    children: <Widget>[
                      ///获取验证码
                      Container(
                        margin: EdgeInsets.fromLTRB(31, 33, 0, 0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          Strings.GET_SMS,
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: Flex(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Expanded(
                                child: TextField(
                                  controller: this._smsController,
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
                                  keyboardType: TextInputType.phone,
                                )),
                            Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: MaterialButton(
                                    onPressed: _sendSmsCode,
                                    child: Text(
                                      "$_btnShowMsg",
                                      style: TextStyle(
                                          color: _isButtonEnable
                                              ? Colors.white
                                              : Colors.black.withOpacity(0.2),
                                          fontSize: 15),
                                    ),
                                    color: _isButtonEnable
                                        ? ColorsUtil.hexColor(0xF83D00)
                                        : Colors.grey.withOpacity(0.1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  )),

              ///邀请码
              Container(
                margin: EdgeInsets.fromLTRB(31, 33, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  Strings.INVITATION,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: TextField(
                  controller: this._invitationCodeController,
                  autofocus: false,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, top: 10),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
//                    suffixIcon: IconButton(
//                      icon: Icon(_isShowRePassWord
//                          ? Icons.visibility_off
//                          : Icons.visibility),
//                      onPressed: () {
//                        showRePassWord();
//                      },
//                    ),
                  ),
                  keyboardType: TextInputType.number,
//                  obscureText: _isShowRePassWord,
                ),
              ),

              ///密码
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

              ///其他注册方式
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(top: 17, right: 12),
                child: GestureDetector(
                  child: Text(
                    _showOtherRegisType,
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  onTap: () => gotoOtherRegister(), //mobile 注册
                ),
              ),

              ///注册说明
              Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  alignment: Alignment.center,
                  child: RichText(
                      text: TextSpan(
                          text: Strings.REGISTER_NOTE_ONE,
                          style: TextStyle(color: Colors.black, fontSize: 12),
                          children: <TextSpan>[
                            TextSpan(
                                text: Strings.REGISTER_NOTE_TWO,
                                style: TextStyle(
//                                color: ColorsUtil.hexColor(0x999999),
                                    color: Colors.blue,
                                    fontSize: 12)),
                          ]))),
              Container(
                margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                width: MallApp.screenWidth - 23 - 23,
                height: 44,
                alignment: Alignment.center,
                child: MaterialButton(
                  onPressed: () {
                    registerPost();
                  },
                  child: Text(
                    Strings.SINGN_UP,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  color: ColorsUtil.hexColor(0xF83D00),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  minWidth: double.infinity,
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 75),
                  alignment: Alignment.center,
                  child: GestureDetector(
                    child: RichText(
                        text: TextSpan(
                            text: Strings.REGISTER_TIPS_ONE,
                            style: TextStyle(color: Colors.black, fontSize: 12),
                            children: <TextSpan>[
                              TextSpan(
                                  text: Strings.REGISTER_TIPS_TWO,
                                  style: TextStyle(
                                      color: ColorsUtil.hexColor(0xF83D00),
                                      fontSize: 12)),
                            ])),
                    onTap: () => backLogin(),
                  )),
            ],
          ),
        )),
      ),
    );
  }

  backLogin() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginView(widget._registerType)));
//    Navigator.pop(context);
  }

  ///获取验证码
  void getSmsCode() {
    print("获取验证码");
    var params = FormData();
    params.add("mobile", _accountNumber);
    params.add("type", "1");
    DioManager.getInstance().post(Config.SEND_CODE, params, (data) {
      if (data['code'] == 200) {
        _zcode = data["data"]["zcode"].toString();
        //当按钮可点击时
        _isButtonEnable = false; //按钮状态标记
        _initTimer();
        ToastUtils.showToast(data['msg']);
      } else {
//        print("message" + data["message"].toString());
        ToastUtils.showToast(data["message"]);
        //todo 两次返回数据不一致
        ///{"msg":"success","code":200,"data":[]}
        ///{"code":400,"message":"An account is already registered with that username. Please choose another."}
      }
    }, (e) => ToastUtils.showToast(e.toString()));
  }

  ///注册  sign up
  void registerPost() {
    if (widget._registerType == 1) {
      //邮箱注册
      if (_accountNumber == null) {
        ToastUtils.showToast("Email not null");
        return;
      }
    }

    print("smsCode = ${_smsCode}; _accountNumber=${_accountNumber}");
    if (widget._registerType == 2) {
      if (null == _accountNumber || _accountNumber.trim().length == 0) {
        ToastUtils.showToast("Mobile not null");
        return;
      }

      if (null == _smsCode || _smsCode.trim().length == 0) {
        ToastUtils.showToast("SMS Code not null");
        return;
      }
    }

    if (null == _password || _password.trim().length == 0) {
      ToastUtils.showToast("Password  not null");
      return;
    }
    setState(() {
      _loading = true;
    });
    var instance = DioManager.getInstance();
    var params = FormData();
    params.add("registerType", widget._registerType);
    LogUtil.logD("LoginView", "registerType = ${ widget._registerType}");
    if(widget._registerType == 1){
      params.add("email", _accountNumber);
      LogUtil.logD("LoginView", "email = ${_accountNumber}");
    }else{
      LogUtil.logD("LoginView", "phone = ${_accountNumber}");
      params.add("phone", _accountNumber);
    }
    params.add("code", _smsCode);
    LogUtil.logD("LoginView", "code = ${_smsCode}");
    params.add("password", _password);
    params.add("zcode", _zcode);
    LogUtil.logD("LoginView", "password = ${_password}");
    if (null != _invitationCode) {
      params.add("invitation_code", _invitationCode);
      LogUtil.logD("LoginView", "invitation_code = ${_invitationCode}");
    }


    instance.post(Config.REGISTER, params, (data) {
      if (data['code'] == 200) {

        ToastUtils.showToast("Registered successfully");

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginView(widget._registerType)));
      } else {
        ToastUtils.showToast(data['message']);
      }
      setState(() {
        _loading = false;
      });
    }, (e) {
      print("error" + e.toString());
      setState(() {
        _loading = false;
      });
      ToastUtils.showToast("Registered failed");
    });
  }

  //判断注册方式
  void judgeType() {
    if (widget._registerType == 2) {
      _showRegisType = Strings.TYPE_MOBILE;
      _showOtherRegisType = Strings.OTHER_REGISTER_TYPE_EMAIL;
      _isShowSms = true;
      _showInputType = TextInputType.phone;
    } else {
      _showRegisType = Strings.TYPE_EMAIL;
      _isShowSms = false;
      _showOtherRegisType = Strings.OTHER_REGISTER_TYPE_MOBILE;
      _showInputType = TextInputType.emailAddress;
    }
  }

  //mobile 注册
  void gotoOtherRegister() {
//    ToastUtils.showToast("点击其他注册方式");
    if (widget._registerType == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterView(2)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterView(1)),
      );
    }
  }

  //显示隐藏密码
  void showPassWord() {
    setState(() {
      _isShowPassWord = !_isShowPassWord;
    });
  }

  //显示隐藏重复输入密码
  void showRePassWord() {
    setState(() {
      _isShowRePassWord = !_isShowRePassWord;
    });
  }

  //设置获取验证码按钮动态
  void _sendSmsCode() {
    if (null == _accountNumber || _accountNumber.trim().length == 0) {
      ToastUtils.showToast("Mobile not null");
    } else {
      setState(() {
        if (_isButtonEnable) {
          ///获取验证码
          getSmsCode();
          return null; //返回null按钮禁止点击
        } else {
          //当按钮不可点击时
//        debugPrint('false');
          return null; //返回null按钮禁止点击
        }
      });
    }
  }

  //设置定时器
  void _initTimer() {
    _timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _time--;
      setState(() {
        if (_time == 0) {
          _timer.cancel();
          _isButtonEnable = true;
          _time = 60;
          _btnShowMsg = Strings.SEND;
        } else {
          _btnShowMsg = Strings.SEND_AGAIN + _time.toString();
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer?.cancel();
    _timer = null;
    _smsController?.dispose();
    _passwordController?.dispose();
    _mobileController?.dispose();
    _invitationCodeController?.dispose();
  }
}
