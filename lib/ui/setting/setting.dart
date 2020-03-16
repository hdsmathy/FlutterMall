import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:olamall_app/constant/images.dart';
import 'package:olamall_app/constant/string.dart';
import 'package:olamall_app/event/event.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/address/address_list.dart';
import 'package:olamall_app/ui/login/login.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/SharePreferencesUtil.dart';
import 'package:olamall_app/utils/UiUtils.dart';

class SettingView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SettingViewState();
  }
}

class _SettingViewState extends State<SettingView> {
  String _name;
  String _phone;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserMsg();
  }

  _getUserMsg() {
    ///获取登陆的用户信息
    SharePreferencesUtil.getLoginMsg().then((data) {
      var username = data["username"];
      if (null != username) _name = data["username"];

      var phone = data["userPhone"];
      if (null != phone && phone != "") {
        var length = phone.length;
        _phone =
            phone.substring(0, 3) + "***" + phone.substring(length - 3, length);
      }
      setState(() {});
      print(
          "loginStatus =${data["isLogin"]}; username = ${data["username"]}; phone = ${data["userPhone"]};");
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: UiUtils.getAppBar("Personal Information", () {
        Navigator.pop(context);
      }),
      body: new Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  height: 80,
                  alignment: Alignment.center,
                  color: Colors.white,
                  padding: const EdgeInsets.all(10.0),
                  child: Row(children: <Widget>[
                    GestureDetector(
                      child: Image.asset(
                        MineImages.MineOrder,
                        width: 50,
                        height: 50,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _name ?? "",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: ScreenAdaper.sp(36)),
                                  ),
                                  Text(
                                    _phone ?? "not phone",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: ScreenAdaper.sp(24)),
                                  )
                                ]))),
                    Image.asset(MineImages.MineInfoRight, width: 20, height: 20)
                  ])),
              InkWell(
                onTap: () {
                  _goAddress();
                },
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                              child: new Text(Strings.Addresses,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: ScreenAdaper.sp(28))))),
                      Image.asset(MineImages.MineMenuRight,
                          width: 10, height: 10)
                    ],
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                              child: new Text(Strings.AccountDetails,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: ScreenAdaper.sp(28))))),
                      Image.asset(MineImages.MineMenuRight,
                          width: 10, height: 10)
                    ],
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                              child: new Text(Strings.ClearCache,
                                  style: TextStyle(
                                      color: ColorsUtil.hexToColor("#333333"),
                                      fontSize: 14)))),
                      new Text("0.00M",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenAdaper.sp(26))),
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                      ),
                      Image.asset(MineImages.MineMenuRight,
                          width: 10, height: 10)
                    ],
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                              child: new Text(Strings.AboutUs,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: ScreenAdaper.sp(28))))),
                      Image.asset(MineImages.MineMenuRight,
                          width: 10, height: 10)
                    ],
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                              child: new Text(Strings.SystemVersion,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: ScreenAdaper.sp(28))))),
                      new Text("1.1.1",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenAdaper.sp(24))),
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                      ),
                      Image.asset(MineImages.MineMenuRight,
                          width: 10, height: 10)
                    ],
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                              child: new Text(Strings.Feedback,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: ScreenAdaper.sp(28))))),
                      Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                            new Text(
                              "Tel:+65 97200116",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: ScreenAdaper.sp(26)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(2),
                            ),
                            new Text(
                              "Mail:services@olamall.sg",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: ScreenAdaper.sp(26)),
                            ),
                          ])),
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                      ),
                      Image.asset(MineImages.MineMenuRight,
                          width: 10, height: 10)
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: _goLogin,
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 30),
                  child: new Text(
                    Strings.SIGNOUT,
                    style: TextStyle(
                        color: ColorsUtil.hexToColor("#F83D00"), fontSize: 15),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _goLogin()  {
    SharePreferencesUtil.saveMsg(
        false, "", "", "", "", "", "", "", "", "", "", "", "", "");
    //登陆成功后关闭当前页面
    eventBus.fire(MineSelectEvent(true));
    Navigator.pop(
        context, true);
  }

  _goAddress() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddressListPage();
    }));
  }
}
