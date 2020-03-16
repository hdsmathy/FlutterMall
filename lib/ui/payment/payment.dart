import 'package:flutter/material.dart';
import 'package:olamall_app/constant/images.dart';
import 'package:olamall_app/constant/string.dart';
import 'package:olamall_app/model/OrderListModel.dart';
import 'package:olamall_app/model/PayResponeModel.dart';
import 'package:olamall_app/model/PaymentWayModel.dart';
import 'package:olamall_app/net/api/woocommerce_config.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/card/bind_card.dart';
import 'package:olamall_app/ui/mall.dart';
import 'package:olamall_app/ui/payment/pay_success.dart';
import 'package:olamall_app/ui/widgets/round_check_box.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/LogUtil.dart';
import 'package:olamall_app/utils/ToastUtils.dart';
import 'package:olamall_app/utils/UiUtils.dart';

class PaymentView extends StatefulWidget {
  OrderListModel _orderListModel;

  PaymentView(this._orderListModel);

  @override
  _PaymentViewState createState() => _PaymentViewState(_orderListModel);
}

class _PaymentViewState extends State<PaymentView> {
  OrderListModel _orderListModel;

  _PaymentViewState(this._orderListModel);

  String _currentValue;

  ///当前选择的支付方式
  bool _isAgree = true;
  List<PaymentWayModel> _paymentWayList = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentValue = _orderListModel.paymentMethodTitle;

    _getPaymentWays();
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
              if (i == 0) {
                _currentValue = paymentWayModel.title;
                paymentWayModel.isHideTips = false;
              } else {
                paymentWayModel.isHideTips = true;
              }
              _paymentWayList.add(paymentWayModel);
            }
          }
          LogUtil.logD("SubmitOrderView",
              "list.len = ${list.length};_paymentWaylist.len = ${_paymentWayList
                  .length}");
          setState(() {});
        },
        error: (e) {
          LogUtil.logE("SubmitOrderView", "_getPaymentWays = " + e.toString());
        });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: ColorsUtil.hexToColor('#F4F4F4'),
        appBar: UiUtils.getAppBarStyle(Strings.PAYMENT_TITLE, context: context),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              ///total amount
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: ScreenAdaper.height(83)),
                child: Text(
                  Strings.TOTAL_AMOUNT,
                  style: TextStyle(
                      color: Colors.grey, fontSize: ScreenAdaper.sp(24)),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(
                    top: ScreenAdaper.height(51),
                    bottom: ScreenAdaper.height(102)),
                child: RichText(
                  text: TextSpan(
                      text: r"$   ",
                      style: TextStyle(
                          color: ColorsUtil.hexToColor("#FF1D1D"),
                          fontSize: ScreenAdaper.sp(26)),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                            '${_orderListModel.total ??
                                "no price,please try again"}',
                            style: TextStyle(
                                color: ColorsUtil.hexToColor("#FF1D1D"),
                                fontSize: ScreenAdaper.sp(32)))
                      ]),
                ),
              ),

              /// 选择支付方式
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _paymentWayList?.length,
                  itemBuilder: (context, index) {
                    var paymentWay = _paymentWayList[index];
                    return _choicePayWay(paymentWay.title,
                        paymentWay.isHideTips, paymentWay.description, (value) {
                          int len = _paymentWayList.length;
                          paymentWay.isHideTips = false;
                          for (int i = 0; i < len; i++) {
                            var paymentWay = _paymentWayList[i];
                            if (i == index) {
                              _currentValue = paymentWay.methodTitle;
                              LogUtil.logD("支付方式", _currentValue + ", "+paymentWay.title);
                            } else {
                              paymentWay.isHideTips = true;
                            }
                            setState(() {});
                          }
                        });
                  }),
              Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: ScreenAdaper.height(100)),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(ScreenAdaper.width(22.0),
                    ScreenAdaper.height(30.0), ScreenAdaper.width(31.0), 0),
                child: Text(
                  Strings.PAY_WAY_AGREE_NOTES,
                  style: TextStyle(
                      color: Colors.grey, fontSize: ScreenAdaper.sp(20)),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(0, 0, ScreenAdaper.width(20), 0),
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
                          Strings.PAY_WAY_AGREE,
                          style: TextStyle(
                              color: Colors.grey, fontSize: ScreenAdaper.sp(
                              24)),
                        )),
                  ],
                ),
              ),
              GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  color: ColorsUtil.hexToColor("#F83D00"),
                  height: ScreenAdaper.height(88.0),
                  width: MallApp.screenWidth,
                  child: Text(
                    Strings.PLACE_ORDER,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onTap: () => _placeOrder(),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///点击  Place Order
  void _placeOrder() {
    if (!_isAgree) {
      ToastUtils.showToast("You must agree to the terms");
      return;
    }
    LogUtil.logD("支付方式", _currentValue);
    if (_currentValue.contains("Credit Card") || _currentValue.contains("MPGS")) {
//      ToastUtils.showToast("您选择了信用卡支付");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BindCardView(widget._orderListModel)));
    } else if (_currentValue.contains("Cash on Delivery")) {
//      ToastUtils.showToast("您选择了货到付款支付");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>
          PaySuccessView(type: 2, orderListModel: _orderListModel,)));
    } else if (_currentValue.contains("Bank Transfer")) {
//      ToastUtils.showToast("您选择了银行转账支付");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>
          PaySuccessView(type: 1, orderListModel: _orderListModel)));
    } else if (_currentValue.contains("PayPal")) {
//      ToastUtils.showToast("您选择了PayPal支付");
    }
  }

  Widget _choicePayWay(String payWayName, bool isChoice, String showMsg,
      Function onChanged) {
    return Container(
      margin: EdgeInsets.only(top: ScreenAdaper.height(5)),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(
                ScreenAdaper.width(21),
                ScreenAdaper.width(33),
                ScreenAdaper.width(19),
                ScreenAdaper.width(40)),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                      payWayName,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenAdaper.sp(32),
                          fontWeight: FontWeight.bold),
                    )),
                Container(
                  padding: EdgeInsets.all(ScreenAdaper.width(10)),
                  margin: EdgeInsets.only(right: ScreenAdaper.width(20)),
                  child: RoundCheckBox(value: !isChoice, onChanged: onChanged),
                )
              ],
            ),
          ),
          Offstage(
            offstage: isChoice,
            child: Container(
              color: ColorsUtil.hexToColor("#E6F7FF"),
              padding: EdgeInsets.only(
                  bottom: ScreenAdaper.height(21),
                  top: ScreenAdaper.height(21),
                  left: ScreenAdaper.width(20),
                  right: ScreenAdaper.width(19)),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Image.asset(SubmitOrderImages.orderTips),
                  ),
                  Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: ScreenAdaper.width(20)),
                        child: Text(
                          showMsg,
                          style: TextStyle(
                              color: ColorsUtil.hexToColor("#333333"),
                              fontSize: ScreenAdaper.sp(20)),
                        ),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}