import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:olamall_app/config/Config.dart';
import 'package:olamall_app/constant/images.dart';
import 'package:olamall_app/constant/string.dart';
import 'package:olamall_app/model/OrderListModel.dart';
import 'package:olamall_app/net/DioManager.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/mall.dart';
import 'package:olamall_app/ui/order/order_detail.dart';
import 'package:olamall_app/ui/payment/pay_success.dart';
import 'package:olamall_app/ui/widgets/custom_line.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/LogUtil.dart';
import 'package:olamall_app/utils/SharePreferencesUtil.dart';
import 'package:olamall_app/utils/ToastUtils.dart';
import 'package:olamall_app/utils/UiUtils.dart';


class BindCardView extends StatefulWidget {
  OrderListModel _orderListModel;

  BindCardView(this._orderListModel);

  /**
   *
   */  @override
  _BindCardView createState() => _BindCardView();
}

class _BindCardView extends State<BindCardView> {
  TextEditingController _cardController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _cvvCodeController = new TextEditingController();

  String _cardNumber;
  String _date;
  String _cvvCode;

  @override
  Widget build(BuildContext context) {
    _cardController
        .addListener(() => _cardNumber = _cardController.text.toString());
    _dateController.addListener(() => _date = _dateController.text.toString());
    _cvvCodeController
        .addListener(() => _cvvCode = _cvvCodeController.text.toString());

    // TODO: implement build
    return Container(
      color: Colors.white,
      child: Scaffold(
          backgroundColor: ColorsUtil.hexToColor("#F4F4F4"),
          appBar: UiUtils.getAppBar(
              "Pay with credit card", () => showBindCardDialog()),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                      left: ScreenAdaper.width(21),
                      top: ScreenAdaper.height(40)),
                  child: Text(
                    "Card Number",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenAdaper.sp(26),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: ScreenAdaper.width(20),
                      top: ScreenAdaper.height(35),
                      right: ScreenAdaper.width(20)),
                  child: TextField(
                    controller: _cardController,
                    autofocus: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        prefixIcon: Icon(Icons.credit_card)),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                      left: ScreenAdaper.width(21),
                      top: ScreenAdaper.height(40)),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "Expiration Date",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenAdaper.sp(26),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "CVV",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenAdaper.sp(26),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                      left: ScreenAdaper.width(21),
                      top: ScreenAdaper.height(40)),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.only(right: ScreenAdaper.width(70)),
                        child: TextField(
                          controller: _dateController,
                          autofocus: false,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: "YY/MM/UU",
                              hintStyle:
                                  TextStyle(fontSize: ScreenAdaper.sp(24))),
                        ),
                      )),
                      Expanded(
                        child: Container(
                          margin:
                              EdgeInsets.only(right: ScreenAdaper.width(20)),
                          child: TextField(
                            controller: _cvvCodeController,
                            autofocus: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: "CVV Code",
                              hintStyle:
                                  TextStyle(fontSize: ScreenAdaper.sp(24)),
                              suffixIcon: IconButton(
                                  icon: ImageIcon(
                                    AssetImage(BindCardImages.question),
                                    size: ScreenAdaper.width(40),
                                    color: Colors.grey,
                                  ),
                                  onPressed: () => showCardDialog()),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ///信用卡图片
                Container(
                  margin: EdgeInsets.only(
                      left: ScreenAdaper.width(20),
                      top: ScreenAdaper.height(53)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child:
                            Image(image: AssetImage(BindCardImages.visaCard)),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: ScreenAdaper.width(50),
                        ),
                        child:
                            Image(image: AssetImage(BindCardImages.masterCard)),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: ScreenAdaper.height(50),
                  ),
                  child: CustomPaint(
                    foregroundPainter: new CustomLine(
                        width:
                            MallApp.screenWidth - ScreenAdaper.width(20) * 2),
                  ),
                ),

                ///相关说明
                Container(
                  margin: EdgeInsets.only(
                    left: ScreenAdaper.width(20),
                    right: ScreenAdaper.width(20),
                    top: ScreenAdaper.height(15),
                  ),
                  child: Text(
                    Strings.CARD_NOTES,
                    style: TextStyle(
                        color: Colors.black, fontSize: ScreenAdaper.sp(20)),
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: GestureDetector(
            child: Container(
              height: ScreenAdaper.height(88),
              width: MallApp.screenWidth,
              color: ColorsUtil.hexToColor("#F83D00"),
              alignment: Alignment.center,
              child: Text(
                Strings.PLACE_ORDER,
                style: TextStyle(color: Colors.white),
              ),
            ),
            onTap: _sendPay,
          )),
    );
  }

  ///显示信用卡大图片信息
  void showCardDialog() {
    showDialog<Null>(
        context: context,
        barrierDismissible: true, //点击空白处关闭对话框
        builder: (BuildContext context) {
          return new AlertDialog(
//        title: new Text(Strings.CARD_IMG_TITLE),
              content: GestureDetector(
            child: new SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    Strings.CARD_IMG_TITLE,
                    style: TextStyle(
                        color: Colors.black, fontSize: ScreenAdaper.sp(36)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: ScreenAdaper.height(39)),
                  child: Image.asset(BindCardImages.bigCard),
                ),
                Container(
                  child: Text(
                    Strings.CARD_IMG_NOTES,
                    style: TextStyle(
                        color: Colors.grey, fontSize: ScreenAdaper.sp(20)),
                  ),
                  margin: EdgeInsets.only(top: ScreenAdaper.height(39)),
                )
              ],
            )),
            onTap: () => Navigator.pop(context),
          ));
        });
  }

  void showBindCardDialog() {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, //点击空白处关闭对话框
      builder: (BuildContext context) {
        return new AlertDialog(
          content: new SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Text(
                  Strings.CARD_BIND_TITLE,
                  style: TextStyle(
                      color: Colors.black, fontSize: ScreenAdaper.sp(36)),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: ScreenAdaper.height(39)),
                child: Text(
                  Strings.CARD_BIND_NOTES,
                  style: TextStyle(
                      color: Colors.grey, fontSize: ScreenAdaper.sp(24)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: ScreenAdaper.height(60)),
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        child: new Text('Reset',
                            style: TextStyle(
                                color: ColorsUtil.hexToColor("#666666"),
                                fontSize: ScreenAdaper.sp(28))),
                        onPressed: () {
                          //todo  点击取消
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        child: new Text(
                          'Done',
                          style: TextStyle(
                              color: ColorsUtil.hexToColor("#F93B00"),
                              fontSize: ScreenAdaper.sp(28)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderDetailView(
                                        orderListModel: widget._orderListModel,
                                        type: 2,
                                      )));
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
        );
      },
    );
  }

  void _sendPay() async{
    if (null == _cardNumber ||
        null == _date ||
        null == _cvvCode ||
        _cardNumber.trim().length == 0 ||
        _date.trim().length == 0 ||
        _cvvCode.trim().length == 0) {
      ToastUtils.showToast("Please check the input information");
      return;
    }

    if(_date.toString().length < 7){
      ToastUtils.showToast("Please check the input date");
      return;
    }
    String  token = await SharePreferencesUtil.getToken();
    LogUtil.logD("_sendPay",
        "year=${_date.substring(0, 4)},month =${_date.substring(5, 7)} ");

    var params = FormData();
    params.add("number", _cardNumber);
    params.add("token", token);
    params.add("month", _date.substring(5, 7));
    params.add("year", _date.substring(0, 4));
    params.add("securityCode", _cvvCode);
    params.add("order_id", widget._orderListModel.id);
    DioManager.getInstance().post(Config.SEND_PAY, params, (data) {
      if (data['code'] == 200) {
        ToastUtils.showToast("Pay Success");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => PaySuccessView(
                      orderListModel: widget._orderListModel,
                      type: 2,
                    )));
      } else {
        ToastUtils.showToast(data['message']);
      }
    }, (e) {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _cardController?.dispose();
    _dateController.dispose();
    _cvvCodeController?.dispose();
  }
}
