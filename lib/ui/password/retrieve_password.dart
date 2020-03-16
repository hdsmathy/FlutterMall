import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:olamall_app/config/Config.dart';
import 'package:olamall_app/constant/images.dart';
import 'package:olamall_app/constant/string.dart';
import 'package:olamall_app/model/SmsCodeModel.dart';
import 'package:olamall_app/net/DioManager.dart';
import 'package:olamall_app/ui/password/confirm_password.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/ui/widgets/progress_dialog.dart';
import 'package:olamall_app/ui/mall.dart';
import 'package:olamall_app/utils/LogUtil.dart';
import 'package:olamall_app/utils/ToastUtils.dart';
import 'package:olamall_app/utils/UiUtils.dart';

/**
 * 找回密码界面
 */
class RetrievePasswordView extends StatefulWidget {
  int _rpType = 1;

  /// 找回密码的方式  1：mobile找回 2：邮箱找回

  RetrievePasswordView(this._rpType);

  @override
  _RetrievePasswordView createState() => new _RetrievePasswordView();
}

class _RetrievePasswordView extends State<RetrievePasswordView> {
  TextEditingController _emailOrMobileController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();
  var _showRpType;
  var _showOtherReType;
  var _showInputType; //输入的是手机还是邮箱

  int _time = 60;
  Timer _timer;
  bool _isButtonEnable = true;
  String _btnShowMsg = Strings.SEND;
  String _accountNumber;
  String _code;
  String _zcode;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    judgeType();

    _emailOrMobileController.addListener(
        () => _accountNumber = _emailOrMobileController.text.toString());
    _codeController.addListener(() => _code = _codeController.text.toString());

    // TODO: implement build
    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: UiUtils.getAppBarStyle("", context: context),
        body:ProgressDialog(loading: _loading, child:  SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ///默认头像
              Container(
                margin: EdgeInsets.only(top: 40),
                child: new ClipOval(
                  child:
                  new Image.asset(RetrievePasswordImages.defaultIcon),
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

              Container(
                margin: EdgeInsets.fromLTRB(31, 33, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  _showRpType,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: TextField(
                  controller: this._emailOrMobileController,
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

              ///获取验证码
              Container(
                margin: EdgeInsets.fromLTRB(31, 33, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  Strings.RETRIEVE_PASSWORD_CODE,
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
                          controller: this._codeController,
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
                          keyboardType: TextInputType.number,
                        )),
                    Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: MaterialButton(
                            onPressed: () {
                              _sendSmsCode();
                            },
                            child: Text(
                              _btnShowMsg,
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

              ///其他方式
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(top: 15, right: 25),
                child: GestureDetector(
                  child: Text(
                    _showOtherReType,
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  onTap: () => gotoOtherRetrievePasswordView(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50, bottom: 200),
                child: GestureDetector(
                  child: Text(
                    Strings.NEXT_STEP,
                    style: TextStyle(
                        color: ColorsUtil.hexColor(0xF83D00), fontSize: 15),
                  ),

                  ///跳转到找回密码第二步
                  onTap: () => checkCode(),
                ),
              ),
            ],
          ),
        )),
      ))
    ;
  }

  ///检查验证码
  void checkCode() {
    print("_code = ${_code}");
    if (null == _code) {
      ToastUtils.showToast("Code not null");
      return;
    }
    setState(() {
      _loading = true;
    });
    FormData params = new FormData();
    params.add("keywordes", _accountNumber);
    LogUtil.logD("1111111", "keywordes = ${_accountNumber}");
    params.add("type", widget._rpType);
    LogUtil.logD("1111111", "type = ${widget._rpType}");
    params.add("code", _code);
    LogUtil.logD("1111111", "code = ${_code}");
    LogUtil.logD("1111111", "zcode = ${_zcode}");
    params.add("zcode", _zcode);

    DioManager.getInstance().post(Config.CHECK_CODE, params, (data) {
      if (data['code'] == 200) {
        ToastUtils.showToast(data['message']);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConfirmPasswordView(
                    _accountNumber, widget._rpType, _code, _zcode)));
      } else {
        ToastUtils.showToast(data['message']);
      }
      setState(() {
        _loading = false;
      });
    }, (e) {
      LogUtil.logE("RetrievePasswordView", e.toString());
//      ToastUtils.showToast(e.toString())
      setState(() {
        _loading = false;
      });
    });
  }

  ///跳转到其他找回密码页面
  void gotoOtherRetrievePasswordView() {
    if (widget._rpType == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RetrievePasswordView(2))
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RetrievePasswordView(1)),);
//      Navigator.push(context,
//          MaterialPageRoute(builder: (context) => new RetrievePasswordView(1)));
    }
  }

  void judgeType() {
    if (widget._rpType == 1) {
      _showRpType = Strings.TYPE_MOBILE;
      _showInputType = TextInputType.phone;
      _showOtherReType = Strings.OTHER_RETRIEVE_PASSWORD_EMAIL;
    } else {
      _showRpType = Strings.TYPE_EMAIL;
      _showInputType = TextInputType.emailAddress;
      _showOtherReType = Strings.OTHER_RETRIEVE_PASSWORD_MOBILE;
    }
  }

  ///获取验证码
  void getSmsCode() {
    String url;
    var params = FormData();
    if (widget._rpType == 1) {
      url = Config.SEND_CODE;
      params.add("mobile", _accountNumber);
      params.add("type", "2");
    } else {
      url = Config.SEND_EMAIL_CODE;
      params.add("email", _accountNumber);
    }

    DioManager.getInstance().post(url, params, (data) {
      if (data['code'] == 200) {
        _zcode = data["data"]["zcode"].toString();
        print("获取验证码成功");
        ToastUtils.showToast(data['message']);
      } else {
        ToastUtils.showToast(data['message']);
      }
    }, (e) {
      LogUtil.logE("RetrievePasswordView", e.toString());
//    ToastUtils.showToast(e.toString())
    });
  }

  //设置获取验证码按钮动态
  void _sendSmsCode() {
    print("_accountNumber = ${_accountNumber}");
    if (null == _accountNumber || _accountNumber.trim().length == 0) {
      if (widget._rpType == 1)
        ToastUtils.showToast("Mobile not null");
      else
        ToastUtils.showToast("Email not null");
    } else {
      if (mounted) {
        setState(() {
          if (_isButtonEnable) {
            //当按钮可点击时
            _isButtonEnable = false; //按钮状态标记
            _initTimer();

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
    _emailOrMobileController?.dispose();
    _codeController?.dispose();
  }
}
