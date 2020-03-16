import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:olamall_app/config/Config.dart';
import 'package:olamall_app/constant/images.dart';
import 'package:olamall_app/constant/string.dart';
import 'package:olamall_app/event/event.dart';
import 'package:olamall_app/model/DistributionMemberModel.dart';
import 'package:olamall_app/model/ProductModel.dart';
import 'package:olamall_app/net/NetWork.dart';
import 'package:olamall_app/net/api/woocommerce_config.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/address/address_list.dart';
import 'package:olamall_app/ui/distribution/distribution_home.dart';
import 'package:olamall_app/ui/login/login.dart';
import 'package:olamall_app/ui/mall.dart';
import 'package:olamall_app/ui/order/order_management.dart';
import 'package:olamall_app/ui/setting/setting.dart';
import 'package:olamall_app/ui/widgets/relate_list.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/LogUtil.dart';
import 'package:olamall_app/utils/SharePreferencesUtil.dart';
import 'package:olamall_app/utils/ToastUtils.dart';

class MineView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MineViewState();
  }
}

class _MineViewState extends State<MineView> {
  var _name = Strings.MINE_NO_LOGIN;

  ///分销提示
  var _distributionTips = Strings.MINE_NO_LOGIN_DIS;

  ///进入分销按钮
  var _distributionBtn = Strings.MINE_JOIN;

  ///分销员信息
  DistributionMemberModel _distributionMemberModel;

  var _phone ;
  bool _isLogin = false;

  ///as you also like数据
  List<ProductModel> _productList = List();
  StreamSubscription mSubscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mSubscription = eventBus.on<MineSelectEvent>().listen((event) {
      _getData();
    });
    _getProductList();
    _getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mSubscription?.cancel();
  }
  void _getData() {
    ///获取登陆的用户信息
    SharePreferencesUtil.getLoginMsg().then((data) {
//      print("isLogin ==== " + data["isLogin"].toString());
      _isLogin = data["isLogin"] ??= false;
      var distributionUid;
      if (_isLogin) {
        distributionUid = data["distributionUid"];
        var username = data["username"];
        if (null != username) _name = data["username"];
        else  _name = Strings.MINE_NO_LOGIN;

        var phone = data["userPhone"];
        if (null != phone && phone.toString().length > 3) {
          var length = phone.length;
          _phone = phone.substring(0, 3) +
              "***" +
              phone.substring(length - 3, length);
        }else{
          _phone ="not phone";
        }

        _distributionBtn = Strings.MINE_ENTER;
        _distributionTips = Strings.MINE_LOGIN_DIS;
      } else {
        _phone ="not phone";
        _name = Strings.MINE_NO_LOGIN;
        _distributionBtn = Strings.MINE_JOIN;
        _distributionTips = Strings.MINE_NO_LOGIN_DIS;
      }
      LogUtil.logD("MineView", "_distributionBtn=${_distributionBtn}; _distributionTips = ${_distributionTips}");
      setState(() {});
      print(
          "MineView loginStatus =${data["isLogin"]}; username = ${data["username"]}; phone = ${data["userPhone"]};distributionUid=${data["distributionUid"]}");
      return distributionUid ??= null;
    }).then((distributionUid) {
      ///获取分销员信息
      if (_isLogin) {
        var params = new FormData();
        params.add("user_id", distributionUid);

        ///分销测试接口
        NetWork.getInstance().post(Config.DISTRIBUTION_USER, params, (data) {
          var distributionMemberModel = DistributionMemberModel.fromJson(data);
          if (distributionMemberModel.code == 200) {
            _distributionMemberModel = distributionMemberModel;

          } else {
            ToastUtils.showToast(distributionMemberModel.msg);
          }
          setState(() {});
        }, (e) {
//          ToastUtils.showToast(e.toString());
          LogUtil.logE("MineView", e.toString());
        });
        return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        backgroundColor: ColorsUtil.hexToColor('#F4F4F4'),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  height: 50,
                  margin: EdgeInsets.only(top: MallApp.statusHeight),
                  color: Colors.white,
                  child: Stack(alignment: Alignment.center, children: <Widget>[
                    Positioned(
                        width: 25,
                        height: 25,
                        left: 10,
                        child: GestureDetector(
                          child: Image.asset(
                            MineImages.MineSetting,
                          ),
                          onTap: _goLoginOrSetting,
                        )),
                  ])),
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
                      onTap: _goLoginOrSetting,
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
                                    _name,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: ScreenAdaper.sp(36)),
                                  ),
                                  Offstage(
                                    offstage: !_isLogin,
                                    child: Text(_phone,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: ScreenAdaper.sp(24))),
                                  )
                                ]))),
                    InkWell(
                      child: Image.asset(MineImages.MineInfoRight,
                          width: 20, height: 20),
                      onTap: _goLoginOrSetting,
                    ),
                  ])),

              Container(
                margin: EdgeInsets.fromLTRB(ScreenAdaper.width(10),
                    ScreenAdaper.height(30), ScreenAdaper.width(11), 0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/ic_mine_bg.png"),
                      fit: BoxFit.cover),
                ),
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(left: ScreenAdaper.width(20)),
                      child: Text(
                        _distributionTips,
                        style: TextStyle(
                            color: Colors.white, fontSize: ScreenAdaper.sp(20)),
                      ),
                    )),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: ScreenAdaper.width(20)),
                      child: MaterialButton(
                        onPressed: _joinContribution,
                        child: Text(
                          _distributionBtn,
                          style: TextStyle(
                              color: ColorsUtil.hexToColor("#2E313F"),
                              fontSize: ScreenAdaper.sp(26)),
                        ),
                        color: ColorsUtil.hexToColor("#FEE06B"),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                  ],
                ),
              ),
              Offstage(
                offstage: !_isLogin,
                child: _InformationFlex(_distributionMemberModel),
              ),

              ///我的订单  MyOrder
              Container(
                height: ScreenAdaper.height(100),
                alignment: Alignment.center,
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(0, ScreenAdaper.height(21), 0, 0),
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    if (_isLogin) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderManagementView()));
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginView(1);
                      }));
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      Image.asset(MineImages.MineOrder, width: 20, height: 20),
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: new Text(Strings.MyOrders,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: ScreenAdaper.sp(28))))),
                      Image.asset(MineImages.MineMenuRight,
                          width: 10, height: 10)
                    ],
                  ),
                ),
              ),

              /// 我的地址 MyAddress
              GestureDetector(
                onTap: _goAddress,
                child: Container(
                  height: ScreenAdaper.height(100),
                  alignment: Alignment.center,
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(0, ScreenAdaper.height(2), 0, 0),
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Image.asset(MineImages.MineAddress,
                          width: 20, height: 20),
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: new Text(Strings.MyAddress,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: ScreenAdaper.sp(28))))),
                      Image.asset(MineImages.MineMenuRight,
                          width: 10, height: 10)
                    ],
                  ),
                ),
              ),
              Container(
                height: 50,
                alignment: Alignment.center,
                child: new Text("== You May Also Like ==",
                    style: TextStyle(
                      color: ColorsUtil.hexToColor("#333333"),
                      fontSize: 13,
                    )),
              ),
              Container(
                child: RelateList(_productList),
              ),
//          ProductGridView(productData)
            ],
          ),
        ));
  }

  ///是否加入分销
  void _joinContribution() async {
    if (_isLogin) {
      if(  null != _distributionMemberModel){
        bool refresh = await  Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DistributionHomeView(_distributionMemberModel)));

        if(refresh) _getData();
      }else{
        ToastUtils.showToast("Data in progress, please wait a moment");
      }

    } else {
      ToastUtils.showToast("Please login");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginView(1)));

    }
  }

  ///进入我的地址页面
  _goAddress() {
    if (_isLogin) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AddressListPage();
      }));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginView(1);
      }));
    }
  }

  ///进入设置页面
  _goLoginOrSetting() async {
    print("是否登陆 $_isLogin");
    if (_isLogin) {
      bool refresh =
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SettingView();
//        return DistributionWalletView();
      }));
      if (refresh) _getData();
    } else
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginView(1);
      }));
  }

  ///分销员信息
  Widget _InformationFlex(DistributionMemberModel distributionMemberModel) {
    String balance = "0";
    String rebate = "0";
    String contribution = "0";
    String levelName = "青铜";
    if (null != distributionMemberModel) {
      balance = distributionMemberModel.data.userInfo.balance;
      rebate = distributionMemberModel.data.settlementTotalMoney.toString();
      contribution = distributionMemberModel.data.userInfo.contributionValue;
      levelName = distributionMemberModel.data.currentLevel.levelName;
    }

    /// Balance 余 额
    var balanceWidget = Expanded(
        child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: ScreenAdaper.height(30)),
          child: Text(
            balance,
            style: TextStyle(
                color: ColorsUtil.hexToColor("#BE925F"),
                fontSize: ScreenAdaper.sp(28)),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
          child: Text(
            "Balance",
            style:
                TextStyle(color: Colors.black, fontSize: ScreenAdaper.sp(20)),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: ScreenAdaper.height(12), bottom: ScreenAdaper.height(23)),
          child: Text(
            "Withdrawable",
            style: TextStyle(
                color: ColorsUtil.hexToColor("#999999"),
                fontSize: ScreenAdaper.sp(20)),
          ),
        ),
      ],
    ));

    ///Rebate
    var rebateWidget = Expanded(
        child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: ScreenAdaper.height(30)),
          child: Text(
            rebate,
            style: TextStyle(
                color: ColorsUtil.hexToColor("#BE925F"),
                fontSize: ScreenAdaper.sp(28)),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
          child: Text(
            "Rebate",
            style:
                TextStyle(color: Colors.black, fontSize: ScreenAdaper.sp(20)),
          ),
        ),
        Container(
            margin: EdgeInsets.only(
                top: ScreenAdaper.height(12), bottom: ScreenAdaper.height(23)),
            child: Text(
              "",
              style: TextStyle(
                  color: ColorsUtil.hexToColor("#999999"),
                  fontSize: ScreenAdaper.sp(20)),
            )),
      ],
    ));

    ///level等级
    var levelWidget = Expanded(
        child: Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: ScreenAdaper.height(40)),
            child: Image.asset("images/ic_mine_star.png")),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
          child: Text(
            "${levelName}\nMember",
            style:
                TextStyle(color: Colors.black, fontSize: ScreenAdaper.sp(20)),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: ScreenAdaper.height(12), bottom: ScreenAdaper.height(23)),
          child: Text(
            "",
            style: TextStyle(
              color: ColorsUtil.hexToColor("#999999"),
              fontSize: ScreenAdaper.sp(20),
            ),
          ),
        )
      ],
    ));

    ///Contribution
    var contributionWidget = Expanded(
        child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: ScreenAdaper.height(30)),
          child: Text(
            contribution,
            style: TextStyle(
                color: ColorsUtil.hexToColor("#BE925F"),
                fontSize: ScreenAdaper.sp(28)),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
          child: Text(
            "Contribution",
            style:
                TextStyle(color: Colors.black, fontSize: ScreenAdaper.sp(20)),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 12, bottom: ScreenAdaper.height(23)),
          child: Text("",
              style: TextStyle(
                color: ColorsUtil.hexToColor("#999999"),
                fontSize: ScreenAdaper.sp(20),
              )),
        )
      ],
    ));

    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          balanceWidget,
          rebateWidget,
          contributionWidget,
          levelWidget,
        ],
      ),
    );
  }

  /**
   * 获取商品列表
   */
  _getProductList() {
    WooCommerceConfig.getInstance().getDataAsync(
        endPoint: "products",
        success: (data) {
          List list = data["data"];
          for (var l in list) {
            var p = ProductModel.fromJson(l);
            _productList.add(p);
          }
          setState(() {});
        },
        error: (e) {});
  }
}
