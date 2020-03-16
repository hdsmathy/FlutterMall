import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:olamall_app/event/event.dart';
import 'package:olamall_app/model/BillingAddressModel.dart';
import 'package:olamall_app/model/CustomerModel.dart';
import 'package:olamall_app/model/ShippingAddressModel.dart';
import 'package:olamall_app/net/api/woocommerce_config.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/utils/SharePreferencesUtil.dart';
import 'package:olamall_app/utils/UiUtils.dart';

import 'address_edit.dart';

class AddressListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  EasyRefreshController _controller = EasyRefreshController();
  BillingAddressModel billingAddress;
  ShippingAddressModel shippingAddress;

  StreamSubscription mSubscription;

  @override
  void initState() {
    super.initState();
//    //订阅eventbus
    mSubscription = eventBus.on<AddressEvent>().listen((event) {
      getAddress();
    });
    getAddress();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //取消订阅
    mSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: UiUtils.getAppBarStyle("Delivery Addresses", context: context),
      body: EasyRefresh(
          header: ClassicalHeader(extent: 70),
          firstRefresh: true,
          controller: _controller,
          onRefresh: getAddress,
          child: Column(
            children: <Widget>[_getBilling(), _getShopping()],
          )),
    );
  }

  Widget _getBilling() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, ScreenAdaper.height(10), 0, 0),
      padding: EdgeInsets.fromLTRB(
          ScreenAdaper.width(20), 0, ScreenAdaper.width(20), 0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "Billing address",
                  style: TextStyle(
                      fontSize: ScreenAdaper.sp(32),
                      color: Color.fromRGBO(51, 51, 51, 1)),
                ),
              ),
              InkWell(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, ScreenAdaper.width(10), 0),
                  child: IconButton(
                    icon: ImageIcon(AssetImage("images/ic_address_edit.png")),
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => AddressEditPage(
                                  type: 1,
                                )),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
          Container(
            height: 1,
            color: Color.fromRGBO(229, 229, 229, 1),
          ),
          _getNameWidget(
              billingAddress == null
                  ? "First name & Last name"
                  : "${billingAddress.firstName} & ${billingAddress.lastName}",
              tel: billingAddress == null ? "8888888" : billingAddress.phone),
          _getText(
              billingAddress == null
                  ? ""
                  : "${billingAddress.address1}, ${billingAddress.city}, ${billingAddress.country}",
              paddingBottom: 20),
          _getText(
              billingAddress == null
                  ? "Apartment, suite, unit etc. (optional)"
                  : "${billingAddress.address2}",
              paddingBottom: 20),
          _getText(
              billingAddress == null ? "000000" : "${billingAddress.postcode}",
              paddingBottom: 20),
          _getText(
              billingAddress == null
                  ? "dukexin1028@163.com"
                  : "${billingAddress.email}",
              paddingBottom: 40),
          _getText(
              billingAddress == null
                  ? "Company name (optional)"
                  : "${billingAddress.company}",
              paddingBottom: 20),
          _getText(
              billingAddress == null
                  ? "Town / City (optional)"
                  : "${billingAddress.city}",
              paddingBottom: 20),
        ],
      ),
    );
  }

  Widget _getShopping() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, ScreenAdaper.height(10), 0, 0),
      padding: EdgeInsets.fromLTRB(
          ScreenAdaper.width(20), 0, ScreenAdaper.width(20), 0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "Shopping address",
                  style: TextStyle(
                      fontSize: ScreenAdaper.sp(32),
                      color: Color.fromRGBO(51, 51, 51, 1)),
                ),
              ),
              InkWell(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, ScreenAdaper.width(10), 0),
                  child: IconButton(
                    icon: ImageIcon(AssetImage("images/ic_address_edit.png")),
                    onPressed: () async {
                      bool refresh = await Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => AddressEditPage(
                                  type: 2,

                                )),
                      );
                      if (refresh) getAddress();
                    },
                  ),
                ),
              )
            ],
          ),
          Container(
            height: 1,
            color: Color.fromRGBO(229, 229, 229, 1),
          ),
          _getNameWidget(shippingAddress == null
              ? "First name & Last name"
              : "${shippingAddress.firstName} & ${shippingAddress.lastName}"),
          _getText(
              shippingAddress == null
                  ? "242 Binjiang Road, Jialing River, Chongqing, China"
                  : "${shippingAddress.address1}, ${shippingAddress.city}, ${shippingAddress.country}",
              paddingBottom: 20),
          _getText(
              shippingAddress == null
                  ? "Apartment, suite, unit etc. (optional)"
                  : "${shippingAddress.address2}",
              paddingBottom: 20),
          _getText(
              shippingAddress == null
                  ? "000000"
                  : "${shippingAddress.postcode}",
              paddingBottom: 20),
          _getText(
              shippingAddress == null
                  ? "Company name (optional)"
                  : "${shippingAddress.company}",
              paddingBottom: 20),
          _getText(
              shippingAddress == null
                  ? "Town / City (optional)"
                  : "${shippingAddress.city}",
              paddingBottom: 20),
        ],
      ),
    );
  }

  Widget _getNameWidget(String name, {tel}) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          0, ScreenAdaper.height(20), 0, ScreenAdaper.height(20)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                  fontSize: ScreenAdaper.sp(26),
                  color: Color.fromRGBO(51, 51, 51, 1)),
            ),
          ),
          Container(
            child: Text(
              tel == null ? "" : tel,
              style: TextStyle(
                  fontSize: ScreenAdaper.sp(26),
                  color: Color.fromRGBO(102, 102, 102, 1)),
            ),
          )
        ],
      ),
    );
  }

  Widget _getText(String s, {double paddingBottom}) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0,
          paddingBottom == null ? 0 : ScreenAdaper.height(paddingBottom)),
      alignment: Alignment.centerLeft,
      child: Text(
        s,
        style: TextStyle(
            fontSize: ScreenAdaper.sp(24),
            color: Color.fromRGBO(153, 153, 153, 1)),
      ),
    );
  }

  Future<void> getAddress() async {
    ///获取登陆的用户信息
    String userid = await SharePreferencesUtil.getLoginMsg().then((data) {
      String uid = data["id"];
      return uid ??= null;
    });
    WooCommerceConfig.getInstance().getDataAsync(
        endPoint: "customers/" + userid,
        success: (data) {
          var a = CustomerModel.fromJson(data);
          setState(() {
            billingAddress = a.billing;
            shippingAddress = a.shipping;
            _controller.finishRefresh(success: true);
          });
        },
        error: (e) {
          print(e);
          _controller.finishRefresh(success: true);
        });
    return null;
  }
}
