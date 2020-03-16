import 'package:flutter/material.dart';
import 'package:olamall_app/constant/images.dart';
import 'package:olamall_app/constant/string.dart';
import 'package:olamall_app/model/BillingAddressModel.dart';
import 'package:olamall_app/model/CarItemModel.dart';
import 'package:olamall_app/model/CustomerModel.dart';
import 'package:olamall_app/model/OrderListModel.dart';
import 'package:olamall_app/event/event.dart';
import 'package:olamall_app/model/PaymentWayModel.dart';
import 'package:olamall_app/model/ShippingAddressModel.dart';
import 'package:olamall_app/model/ShippingMethodModel.dart';
import 'package:olamall_app/model/ShippingZonesModel.dart';
import 'package:olamall_app/net/api/woocommerce_config.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/card/bind_card.dart';
import 'package:olamall_app/ui/order/item/product_item.dart';
import 'package:olamall_app/ui/payment/pay_success.dart';
import 'package:olamall_app/ui/widgets/custom_line.dart';
import 'package:olamall_app/ui/widgets/progress_dialog.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/LogUtil.dart';
import 'package:olamall_app/utils/SharePreferencesUtil.dart';
import 'package:olamall_app/utils/ToastUtils.dart';
import 'package:olamall_app/utils/UiUtils.dart';

import '../mall.dart';

/**
 * 提交订单界面
 */

class SubmitOrderView extends StatefulWidget {
  double _totalPrice;
  List<Data> _carList = new List();

  SubmitOrderView(this._totalPrice, this._carList);

  @override
  _SubmitOrderViewState createState() => _SubmitOrderViewState();
}

class _SubmitOrderViewState extends State<SubmitOrderView> {
  bool _isAgree = true;
  BillingAddressModel _billingAddress;
  ShippingAddressModel _shippingAddress;
  List<PaymentWayModel> _paymentWayList = new List();
  List<ShippingMethodModel> _shippingMethodList = new List();
  int _paymentOption = 0;
  int _shippingMethodOption = 0;
  String _shippingPrice = "0.00";
  String _paymentOptionTitle = " ";
  String _shippingMethodOptionTitle = " ";
  String _userNotes;
  bool _loading = true;

  ///订单备注信息控制器
  TextEditingController _userNotesController = new TextEditingController();
  String _userid;

  ///是否开启加载动画

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userNotesController
        .addListener(() => _userNotes = _userNotesController.text.toString());
    _getData();
  }

  void _getData() {
    _getAddress();
    _getPaymentWays();
    _getShippingMethods();
  }

  ///创建订单
  void _createOrder() {
    if (!_isAgree) {
      ToastUtils.showToast("You must agree to the terms");
      return;
    }

    if (null == _billingAddress ||
        _billingAddress.firstName.isEmpty ||
        _billingAddress.lastName.isEmpty ||
        _billingAddress.phone.isEmpty) {
      ToastUtils.showToast("Not have address");
      return;
    }
//    if(null == _shippingAddress||_shippingAddress.firstName.isEmpty||_shippingAddress.lastName.isEmpty ){
//      ToastUtils.showToast("Not have address");
//      return;
//    }
    setState(() {
      _loading = true;
    });
    var paymentWayModel = _paymentWayList[_paymentOption];
    var shippingMethodModel = _shippingMethodList[_shippingMethodOption];

    ///拼接
    var line_items = [];
    var len = widget._carList.length;
    for (var i = 0; i < len; ++i) {
      Map<String, dynamic> dataMap = Map();
      var item = widget._carList[i];
      dataMap["product_id"] = "${item.productId}";
      dataMap["variation_id"] = "${item.variationId}";
      dataMap["quantity"] = item.quantity;
      line_items.add(dataMap);
    }
    LogUtil.logD("createOrder", paymentWayModel.id.toString());
    var payLoad = {
      "customer_id": "$_userid",
      "payment_method": "${paymentWayModel.id}",
      "payment_method_title": "${paymentWayModel.methodTitle}",
      "set_paid": true,
      "billing": {
        "first_name": "${_billingAddress.firstName}",
        "last_name": "${_billingAddress.lastName}",
        "address_1": "${_billingAddress.address1}",
        "address_2": "${_billingAddress.address2}",
        "city": "${_billingAddress.city}",
        "state": "${_billingAddress.state}",
        "postcode": "${_billingAddress.postcode}",
        "country": "${_billingAddress.country}",
        "email": "${_billingAddress.email}",
        "phone": "${_billingAddress.phone}"
      },
      "shipping": {
        "first_name": "${_shippingAddress.firstName}",
        "last_name": "${_shippingAddress.lastName}",
        "address_1": "${_shippingAddress.address1}",
        "address_2": "${_shippingAddress.address2}",
        "city": "${_shippingAddress.city}",
        "state": "${_shippingAddress.state}",
        "postcode": "${_shippingAddress.postcode}",
        "country": "${_shippingAddress.country}"
      },
      "line_items": line_items,
      "shipping_lines": [
        {
          "method_id": "${shippingMethodModel.id}",
          "method_title": "${shippingMethodModel.title}",
          "total": "${shippingMethodModel.freight}"
        }
      ]
    };
    if (paymentWayModel.id.contains("cheque") ||
        paymentWayModel.id.contains("bacs") ||
        paymentWayModel.id.contains("cod"))
      payLoad.putIfAbsent("status", () => "processing");

    ///上传用户订单备注
    if (null != _userNotes)
      WooCommerceConfig.getInstance().postDataAsync(
          endPoint: "orders/",
          queryAtId: _userid + "/notes",
          payLoad: null,
          success: (data) {},
          error: (e) {
            LogUtil.logE("SubmitOrderView", e.toString());
          });

    WooCommerceConfig.getInstance().postDataAsync(
        endPoint: "orders",
        queryAtId: null,
        payLoad: payLoad,
        success: (data) {
          ToastUtils.showToast("Create order success");
          try {
            var orderListModel = OrderListModel.fromJson(data);
            setState(() {
              _loading = true;
            });
            LogUtil.logD("支付方式", "${orderListModel.paymentMethodTitle};; ${orderListModel.paymentMethod}");
            ///判断选择支付方式跳转
            if(paymentWayModel.id.contains("bacs"))///银行转账
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaySuccessView(
                          type: 1, orderListModel: orderListModel)));
            else if(paymentWayModel.id.contains("woo_mpgs")) ///信用卡支付
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BindCardView(orderListModel)));
            else  ///其它支付
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaySuccessView(
                          type: 2, orderListModel: orderListModel)));



            eventBus.fire(ClearCarEvent(widget._carList));
          } catch (error) {
            print(error.toString());
          }
        },
        error: (e) {
          setState(() {
            _loading = false;
          });
          LogUtil.logE("SubmitOrderView", e.toString());
          if (e.toString().contains("timeout")) {
            ToastUtils.showToast("time out");
          } else {
            LogUtil.logE("SubmitOrderView", e.toString());
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ProgressDialog(loading: _loading,child: Container(
      child:  Scaffold(
        backgroundColor: ColorsUtil.hexToColor('#F4F4F4'),
        appBar: UiUtils.getAppBarStyle("Check Out", context: context),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ///送货地址 shipping address
              _addressContent(),

              ///具体的商品信息
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), //禁用ListView滚动事件
                itemCount: widget._carList.length,
                itemBuilder: (context, index) {
                  return OrderProductItem(widget._carList[index]);
                },
              ),

              ///总金额
              Container(
                color: Colors.white,
                height: ScreenAdaper.width(100),
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(
                    top: ScreenAdaper.height(4),
                    bottom: ScreenAdaper.height(20)),
                padding: EdgeInsets.only(right: ScreenAdaper.width(25)),
                child: RichText(
                  text: TextSpan(
                      text: "Product amount total:\t\t\t\t\t",
                      style: TextStyle(
                          color: ColorsUtil.hexToColor("#666666"),
                          fontSize: ScreenAdaper.sp(24)),
                      children: <TextSpan>[
                        TextSpan(
                            text: "\$ ${widget._totalPrice}",
                            style: TextStyle(
//                                color: ColorsUtil.hexColor(0x999999),
                                color: ColorsUtil.hexToColor("#FF1D1D"),
                                fontSize: ScreenAdaper.sp(28))),
                      ]),
                ),
              ),

              ///支付配置
              _otherOption(
                  type: 1,
                  title: Strings.ORDER_PAY_OPTION,
                  option: _paymentOptionTitle,
                  paymentList: _paymentWayList),

              ///Shipping: 配置
              _otherOption(
                  type: 2,
                  title: Strings.ORDER_SHIPPING,
                  option: _shippingMethodOptionTitle,
                  shippingList: _shippingMethodList),

              ///Order Notes: 配置
              Container(
                margin: EdgeInsets.only(top: ScreenAdaper.height(2)),
                color: Colors.white,
                padding: EdgeInsets.only(
                  left: ScreenAdaper.width(21),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                        child: Text(
                          Strings.ORDER_NOTES,
                          style: TextStyle(
                              color: Colors.black, fontSize: ScreenAdaper.sp(26)),
                        )),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            right: ScreenAdaper.width(21),
                            left: ScreenAdaper.width(55)),
                        child: TextField(
                          controller: _userNotesController,
                          maxLength: 50,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenAdaper.sp(26)),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              ///同意相关条款
              Container(
                margin: EdgeInsets.only(top: ScreenAdaper.height(40)),
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(
                    ScreenAdaper.width(20),
                    ScreenAdaper.height(30),
                    ScreenAdaper.width(20),
                    ScreenAdaper.height(19)),
                child: Text(
                  Strings.ORDER_AGREE_NOTES,
                  style: TextStyle(
                      color: Colors.grey, fontSize: ScreenAdaper.sp(20)),
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(
                    0, 0, ScreenAdaper.width(20), ScreenAdaper.height(21)),
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: _isAgree,
                      onChanged: (bool) {
                        setState(() {
                          _isAgree = !_isAgree;
                        });
                      },
                      activeColor: Colors.grey,
                    ),
                    Expanded(
                        child: Text(
                          Strings.ORDER_AGREE,
                          style: TextStyle(
                              color: Colors.grey, fontSize: ScreenAdaper.sp(24)),
                        )),
                  ],
                ),
              ),

              /// 总价格信息
              Container(
                  margin: EdgeInsets.only(top: ScreenAdaper.height(2)),
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(
                      ScreenAdaper.width(20),
                      ScreenAdaper.height(30),
                      ScreenAdaper.width(21),
                      ScreenAdaper.height(8)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            child: Text(
                              Strings.ORDER_AMOUNT,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenAdaper.sp(26)),
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            right: ScreenAdaper.width(21),
                            left: ScreenAdaper.width(55)),
                        child: Text(
                          "\$  ${widget._totalPrice}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenAdaper.sp(26)),
                        ),
                      ),
                    ],
                  )),

              ///Freight:  运费相关信息
              Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(
                      ScreenAdaper.width(20),
                      ScreenAdaper.height(30),
                      ScreenAdaper.width(21),
                      ScreenAdaper.height(8)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            child: Text(
                              Strings.ORDER_FREIGHT,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenAdaper.sp(26)),
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            right: ScreenAdaper.width(21),
                            left: ScreenAdaper.width(55)),
                        child: Text(
                          "\$ ${_shippingPrice ?? "0.00"}",
                          style: TextStyle(
                              color: ColorsUtil.hexToColor("#F83D00"),
                              fontSize: ScreenAdaper.sp(26)),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
        bottomNavigationBar:

        ///结算付款
        Container(
            margin: EdgeInsets.only(top: ScreenAdaper.height(2)),
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(
                ScreenAdaper.width(20),
                ScreenAdaper.height(30),
                ScreenAdaper.width(21),
                ScreenAdaper.height(20)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      child: RichText(
                        text: TextSpan(
                            text: Strings.ORDER_TOTAL,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenAdaper.sp(26)),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "\$  ${widget._totalPrice}",
                                  style: TextStyle(
                                      color: ColorsUtil.hexToColor("#F23F2B"),
                                      fontSize: ScreenAdaper.sp(28)))
                            ]),
                      )),
                ),
                Container(
                    height: ScreenAdaper.height(60),
                    width: ScreenAdaper.width(260),
                    margin: EdgeInsets.only(
                        right: ScreenAdaper.width(21),
                        left: ScreenAdaper.width(55)),
                    child: MaterialButton(
                      onPressed: _createOrder,

                      ///下单
                      child: Text(
                        Strings.ORDER_PAY,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenAdaper.sp(30)),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(30))),
                      color: ColorsUtil.hexToColor("#F83D00"),
                      minWidth: double.infinity,
                    )),
              ],
            )),
      ),
    ),),);
  }

  ///底部弹窗
  void showBottomDialog(
      {int type,
      List<PaymentWayModel> paymentWayList,
      List<ShippingMethodModel> shippingList}) {
    LogUtil.logD("SubmitOrderView", "showBottomDialog");
    int len = 0;
    if (type == 1) {
      len = paymentWayList.length;
      LogUtil.logD("SubmitOrderView", "len2 = ${paymentWayList.length}");
    } else {
      len = shippingList.length;
    }

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setDialogState) {
            return Container(
                child: Column(
              children: <Widget>[
                ListView.builder(
                    itemCount: len,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (type == 1) {
                        var paymentWay = paymentWayList[index];

                        return _dialogItem(paymentWay.title, paymentWay.description, paymentWay.isHideTips, () {
                          _paymentOptionTitle = paymentWay.title;
                          _paymentOption = index;
                          paymentWay.isHideTips = false;
                          for (var i = 0; i < paymentWayList.length; ++i) {
                            var paymentWay = paymentWayList[i];
                            if (i != index) {
                              paymentWay.isHideTips = true;
                            }
                          }
                          LogUtil.logD(
                              "paymentWay title", paymentWay.title.toString());
                          LogUtil.logD(
                              "paymentWay id", paymentWay.id.toString());
                          setDialogState(() {});
                          setState(() {});
                        });
                      } else {
                        var shippingMethod = shippingList[index];
                        _shippingPrice = shippingMethod.freight;
                        return _dialogItem(
                            "${shippingMethod.title}:\$${shippingMethod.freight ?? "0.00"}",
                            shippingMethod.description,
                            shippingMethod.isHideTips, () {
                          _shippingMethodOption = index;
                          _shippingMethodOptionTitle =
                              "${shippingMethod.title}:\$${shippingMethod.freight ?? "0.00"}";
                          shippingMethod.isHideTips = false;
                          for (var i = 0; i < shippingList.length; ++i) {
                            var shippingMethod = shippingList[i];
                            if (i != index) {
                              shippingMethod.isHideTips = true;
                            }
                          }
                          setDialogState(() {});
                          setState(() {});
                        });
                      }
                    }),
                Container(
                  margin: EdgeInsets.only(top: ScreenAdaper.height(10)),
                  child: CustomPaint(
                    foregroundPainter: new CustomLine(
                        width: MallApp.screenWidth,
                        strokeWidth: ScreenAdaper.height(20)),
                  ),
                ),
                InkWell(
                  child: Container(
                    margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
                    height: ScreenAdaper.height(88),
                    alignment: Alignment.center,
                    child: Text(
                      "OK",
                      style: TextStyle(
                          color: ColorsUtil.hexToColor("#F93B00"),
                          fontSize: ScreenAdaper.sp(26),
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  onTap: () {
                    _paymentOptionTitle =
                        paymentWayList[_paymentOption].methodTitle;
                    setDialogState(() {});
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
                Container(
                  child: CustomPaint(
                    foregroundPainter:
                        new CustomLine(width: MallApp.screenWidth),
                  ),
                ),
                InkWell(
                  child: Container(
                    margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
                    height: ScreenAdaper.height(88),
                    alignment: Alignment.center,
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontSize: ScreenAdaper.sp(26),
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ));
          });
        });
  }

  ///底部弹窗 item
  Widget _dialogItem(
      String title, String tips, bool isHideTips, Function onClick) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          child: Container(
            height: ScreenAdaper.height(100),
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: ScreenAdaper.sp(26), fontWeight: FontWeight.normal),
            ),
          ),
          onTap: onClick,
        ),
        Offstage(
          offstage: isHideTips,
          child: Container(
            color: ColorsUtil.hexToColor("#E6F7FF"),
            padding: EdgeInsets.only(
                bottom: ScreenAdaper.height(20),
                top: ScreenAdaper.height(10),
                left: ScreenAdaper.width(19),
                right: ScreenAdaper.width(10)),
            child: Row(
              children: <Widget>[
                Container(
                  child: Image.asset(SubmitOrderImages.orderTips),
                ),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(left: ScreenAdaper.width(20)),
                  child: Text(
                    tips ?? " ",
                    style: TextStyle(
                        color: ColorsUtil.hexToColor("#333333"),
                        fontSize: ScreenAdaper.sp(20)),
                  ),
                )),
              ],
            ),
          ),
        ),
        Container(
          child: CustomPaint(
            foregroundPainter: new CustomLine(width: MallApp.screenWidth),
          ),
        ),
      ],
    );
  }

  ///Payment Option:   Shipping:   Order notes(optional):
  Widget _otherOption(
      {int type,
      String title,
      String option,
      List<PaymentWayModel> paymentList,
      List<ShippingMethodModel> shippingList}) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: ScreenAdaper.height(2)),
        color: Colors.white,
        height: ScreenAdaper.height(100),
        padding: EdgeInsets.only(
          left: ScreenAdaper.width(21),
          right: ScreenAdaper.width(19),
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
                child: Text(
              title ?? " ",
              style:
                  TextStyle(color: Colors.black, fontSize: ScreenAdaper.sp(26)),
            )),
            Container(
              margin: EdgeInsets.only(
                  right: ScreenAdaper.width(21), left: ScreenAdaper.width(55)),
              child: Text(
                option ?? " ",
                style: TextStyle(
                    color: Colors.grey, fontSize: ScreenAdaper.sp(26)),
              ),
            ),
            Container(
              child: Image.asset(SubmitOrderImages.rightArrows),
            ),
          ],
        ),
      ),
      onTap: () {
        LogUtil.logD("SubmitOrderView", "otherOption 点击");
        showBottomDialog(
            type: type,
            paymentWayList: paymentList,
            shippingList: shippingList);
      },
    );
  }

  ///地址信息栏
  Widget _addressContent() {
    String line1Msg;
    String address;
    String postcode;
    String detailAddress;
    bool isHideDetailAddress = true;

    if (null != _billingAddress) {
      line1Msg = (_billingAddress.firstName ?? "") +
          "  " +
          (_billingAddress.lastName ?? "") +
          "    " +
          (_billingAddress.phone ?? "");
      address = (_billingAddress.address1 ?? "") +
          "," +
          (_billingAddress.city ?? "") +
          "," +
          (_billingAddress.country ?? "");
      postcode = _billingAddress.postcode;
      isHideDetailAddress = null == _billingAddress.address2 ? true : false;
      detailAddress = _billingAddress.address2 ?? " ";
    }

    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(
          top: ScreenAdaper.height(10), bottom: ScreenAdaper.height(20)),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(ScreenAdaper.width(30),
                ScreenAdaper.height(33), ScreenAdaper.width(106), 0),
            child: Text(
              line1Msg ?? "",
              style:
                  TextStyle(color: Colors.black, fontSize: ScreenAdaper.sp(30)),
            ),
          ),
          Container(
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(
                      ScreenAdaper.width(30),
                      ScreenAdaper.height(28),
                      ScreenAdaper.width(106),
                      0,
                    ),
                    child: Text(
                      address ?? "",
                      style: TextStyle(
                          color: Colors.grey, fontSize: ScreenAdaper.sp(26)),
                    ),
                  ),
                ),
                Container(
                  child: Image.asset(SubmitOrderImages.rightArrows),
                  margin: EdgeInsets.only(right: ScreenAdaper.width(23)),
                )
              ],
            ),
          ),
          Offstage(
            offstage: isHideDetailAddress,
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(
                ScreenAdaper.width(30),
                ScreenAdaper.height(28),
                ScreenAdaper.width(106),
                0,
              ),
              child: Text(
                detailAddress ?? "",
                style: TextStyle(
                    color: Colors.grey, fontSize: ScreenAdaper.sp(26)),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(
              ScreenAdaper.width(30),
              ScreenAdaper.height(23),
              ScreenAdaper.width(106),
              0,
            ),
            child: Text(
              postcode ?? " ",
              style:
                  TextStyle(color: Colors.grey, fontSize: ScreenAdaper.sp(26)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: ScreenAdaper.width(53),
            ),
            child: Image.asset(SubmitOrderImages.imaginaryLine),
          )
        ],
      ),
    );
  }

  ///获取地址
  Future<void> _getAddress() async {
    ///获取登陆的用户信息
    _userid = await SharePreferencesUtil.getLoginMsg().then((data) {
      String uid = data["id"];
      return uid ??= null;
    });
    WooCommerceConfig.getInstance().getDataAsync(
        endPoint: "customers/" + _userid,
        success: (data) {
          var a = CustomerModel.fromJson(data);
          _billingAddress = a.billing;
          _shippingAddress = a.shipping;
          setState(() {
//            ToastUtils.showToast("BillingAddress,ShippingAddress,获取成功");
          });
        },
        error: (e) {
          ToastUtils.showToast("Server exception");
          LogUtil.logE("SubmitOrderView", e.toString());
        });
    return null;
  }

  ///获取支付方式
  Future<void> _getPaymentWays() async {
    WooCommerceConfig.getInstance().getDataAsync(
        endPoint: "payment_gateways",
        success: (data) {
          List list = data['data'];
          for (int i = 0; i < list.length; ++i) {
            var item = list[i];
            PaymentWayModel paymentWayModel = PaymentWayModel.fromJson(item);
            if (paymentWayModel.enabled) {
              paymentWayModel.isHideTips = true;
              _paymentWayList.add(paymentWayModel);
            }
          }

          if (_paymentWayList.length != 0) {
            _paymentWayList[0].isHideTips = false;
            _paymentOptionTitle = _paymentWayList[0].title;
          }
          setState(() {});
        },
        error: (e) {
          LogUtil.logE("SubmitOrderView", "_getPaymentWays = " + e.toString());
        });
    return null;
  }

  ///获取运送方式
  Future<void> _getShippingMethods() async {
    ///列出所有运输区域
    WooCommerceConfig.getInstance().getDataAsync(
        endPoint: "shipping/zones",
        success: (data) {
          List list = data['data'];
          List<ShippingZonesModel> zones = new List();
          for (var item in list) {
            var shippingZonesModel = ShippingZonesModel.fromJson(item);
            zones.add(shippingZonesModel);
            if (shippingZonesModel.name.contains("新加坡") ||
                shippingZonesModel.name.contains("Singapore")) {
              ///获取对应运输区，去获取运输方式
              WooCommerceConfig.getInstance().getDataAsync(
                  endPoint: "shipping/zones/${shippingZonesModel.id}/methods",
                  success: (data) {
                    List list = data["data"];
                    for (var i = 0; i < list.length; ++i) {
                      var item = list[i];
                      if (!item['enabled']) continue;
                      LogUtil.logD("SubmitOrderView",
                          "list.len = ${list.length};methods= ${item.toString()}");
                      ShippingMethodModel shippingMethodModel =
                          new ShippingMethodModel();
                      shippingMethodModel.id = item['id'].toString();
                      shippingMethodModel.title = item['title'].toString();
                      shippingMethodModel.description =
                          item['method_description'].replaceAll("<P>", "");

                      ///运费
                      if (null != item['settings'] &&
                          null != item['settings']['cost'] &&
                          null != item['settings']['cost']['value'])
                        shippingMethodModel.freight =
                            item['settings']['cost']['value'].toString();
                      else
                        shippingMethodModel.freight = "0.00";

                      shippingMethodModel.isHideTips = true;
                      _shippingMethodList.add(shippingMethodModel);
                    }
                    if (_shippingMethodList.length != 0) {
                      _shippingMethodOptionTitle =
                          "${_shippingMethodList[0].title}:\$${_shippingMethodList[0].freight ?? "0.00"}";
                      _shippingPrice = _shippingMethodList[0].freight;
                    }
                    setState(() {
                      _loading = false;
                    });
                  },
                  error: (e) {
                    ToastUtils.showToast("Server exception");
                    LogUtil.logE("SubmitOrderView", e.toString());
                    setState(() {
                      _loading = false;
                    });
                  });
            }
          }
        },
        error: (e) {
          ToastUtils.showToast("Server exception");
          LogUtil.logE("SubmitOrderView", e.toString());
          setState(() {
            _loading = false;
          });
        });
    return null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _userNotesController?.dispose();
  }
}
