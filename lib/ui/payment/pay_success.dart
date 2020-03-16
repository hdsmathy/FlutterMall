import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:olamall_app/config/Config.dart';
import 'package:olamall_app/constant/images.dart';
import 'package:olamall_app/constant/string.dart';
import 'package:olamall_app/model/OrderListModel.dart';
import 'package:olamall_app/model/OurBankModel.dart';
import 'package:olamall_app/model/PayResponeModel.dart';
import 'package:olamall_app/model/ProductModel.dart';
import 'package:olamall_app/net/DioManager.dart';
import 'package:olamall_app/net/api/woocommerce_config.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/home/home.dart';
import 'package:olamall_app/ui/order/order_detail.dart';
import 'package:olamall_app/ui/widgets/custom_line.dart';
import 'package:olamall_app/ui/widgets/relate_list.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/LogUtil.dart';
import 'package:olamall_app/utils/ToastUtils.dart';
import 'package:olamall_app/utils/UiUtils.dart';

import '../mall.dart';
import 'package:olamall_app/event/event.dart';
///支付成功页面
class PaySuccessView extends StatefulWidget {
  int type;

  /// type = 1 银行卡转账跳转来， 2其他方式

  OrderListModel orderListModel;

  PaySuccessView({this.type = 2, this.orderListModel});

  @override
  _PaySuccessViewState createState() => _PaySuccessViewState();
}

class _PaySuccessViewState extends State<PaySuccessView> {
  ///as you also like数据
  List<ProductModel> _productList = List();
  Data _ourBankModel;
  bool isHideBankMsg;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.type == 1) {
      isHideBankMsg = false;
      _getBank();
    }
    else
      isHideBankMsg = true;
    _getMoreLike();
  }

  _getBank() {
    DioManager.getInstance().post(Config.GET_BANK, new FormData(), (data) {
      if (data['code'] == 200) {
        _ourBankModel = OurBankModel.fromJson(data).data[0];
      } else {
        ToastUtils.showToast(data['message']);
      }
      setState(() {});
    }, (e) {
      if (e.toString().contains("timeout")) {
        ToastUtils.showToast("time out");
      } else {
        LogUtil.logE("SubmitOrderView", e.toString());
      }
    });
  }

  void _getMoreLike() {
    ///获取底部 you may also like 数据
    WooCommerceConfig.getInstance().getDataAsync(
        endPoint: "products/?page=1&per_page=4",
        success: (data) {
          List list = data['data'];
          for (var item in list) {
            var productModel = ProductModel.fromJson(item);
            _productList.add(productModel);
          }
          setState(() {});
        },
        error: (e) {
          LogUtil.logE("PaySuccessView", e.toString());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          backgroundColor: ColorsUtil.hexToColor('#F4F4F4'),
          appBar: UiUtils.getAppBarNoBackStyle(""),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: ScreenAdaper.height(60)),
                  child: Image.asset(PaySuccessImages.paySuccess),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: ScreenAdaper.height(30)),
                  child: Text(
                    "Order received",
                    style: TextStyle(
                        color: Colors.grey, fontSize: ScreenAdaper.sp(26)),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: ScreenAdaper.height(19)),
                  child: Text(
                    "Thank you. Your order has been received.",
                    style: TextStyle(
                        color: Colors.grey, fontSize: ScreenAdaper.sp(26)),
                  ),
                ),

                ///订单信息
                Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(top: ScreenAdaper.height(59)),
                    padding: EdgeInsets.only(
                        top: ScreenAdaper.height(11),
                        bottom: ScreenAdaper.height(20)),
                    child: Column(
                      children: <Widget>[
                        ContentItem(
                            "Order number :", widget.orderListModel.number),
                        ContentItem(
                            "Date :",
                            widget.orderListModel.dateCreated
                                ?.replaceAll("T", " ")
                                .toString()),
                        ContentItem("Email :",
                            widget.orderListModel.billing.email ?? " "),
                        ContentItem(
                            "Total :", widget.orderListModel.total ?? " "),
                        ContentItem("Paymfnt method :",
                            widget.orderListModel.paymentMethodTitle ?? " "),
                        Offstage(
                          offstage: isHideBankMsg,
                          child: Column(
                            children: <Widget>[
                              LineItem(),
                              TitleItem(),
                              ContentItem("Ola Mall Pte.Ltd :",
                                  _ourBankModel?.accountName ?? ""),
                              ContentItem(
                                  "Bank :", _ourBankModel?.bankName ?? ""),
                              ContentItem("Account Number :",
                                  _ourBankModel?.accountNumber ?? ""),
                              ContentItem(
                                  "Sort :", _ourBankModel?.sortCode ?? ""),
                              ContentItem("Iban :", _ourBankModel?.iban ?? ""),
                              ContentItem("Bic :", _ourBankModel?.bic ?? ""),
                            ],
                          ),
                        )
                      ],
                    )),

                ///按钮
                Container(
                  padding: EdgeInsets.only(
                      top: ScreenAdaper.height(39),
                      bottom: ScreenAdaper.height(30)),
                  color: Colors.white,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(ScreenAdaper.width(125),
                              0, ScreenAdaper.width(25), 0),
//                    height:ScreenAdaper.height(64),
                          alignment: Alignment.centerRight,
                          child: MaterialButton(
                            onPressed: () {
                              //todo  进去订单详情页面
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>  OrderDetailView(
                                        type: 1,
                                        orderListModel:
                                        widget.orderListModel,
                                      )));

                            },
                            child: Text(
                              "Order details",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenAdaper.sp(26)),
                            ),
                            color: ColorsUtil.hexColor(0xF83D00),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            minWidth: double.infinity,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(ScreenAdaper.width(25), 0,
                              ScreenAdaper.width(119), 0),
//                    width: MallApp.screenWidth - 23 - 23,
//                    height: 44,
                          alignment: Alignment.centerLeft,
                          child: MaterialButton(
                            onPressed: () {
                              ///返回到主页面
//                              Navigator.pop(context);
//                            Navigator.pushAndRemoveUntil(context,
//                                MaterialPageRoute(builder: (context)=>MallApp())
//                                , (route)=>route == null);
                              Navigator.of(context).popUntil(ModalRoute.withName('/main'));
                              eventBus.fire(MainSelectEvent(0));
                            },
                            child: Text(
                              "Home",
                              style: TextStyle(
                                  color: ColorsUtil.hexToColor("#F83D00"),
                                  fontSize: ScreenAdaper.sp(26)),
                            ),
                            color: ColorsUtil.hexToColor("#FFE4DB"),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            minWidth: double.infinity,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ///== You May Also Like ==
                Container(
                  margin: EdgeInsets.all(ScreenAdaper.height(40)),
                  alignment: Alignment.center,
                  child: Text(
                    "== You May Also Like ==",
                    style: TextStyle(
                        color: Colors.black, fontSize: ScreenAdaper.sp(26)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: ScreenAdaper.height(32)),
                  child: RelateList(_productList),
                )
              ],
            ),
          )),
    );
  }
}

class TitleItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
          top: ScreenAdaper.height(31), bottom: ScreenAdaper.height(11)),
      child: Text(
        "Our bank details",
        style: TextStyle(color: Colors.black, fontSize: ScreenAdaper.sp(24)),
      ),
    );
  }
}

class LineItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(
          top: ScreenAdaper.height(22),
          left: ScreenAdaper.width(19),
          right: ScreenAdaper.width(21)),
      height: ScreenAdaper.height(4),
      child: Container(
        color: ColorsUtil.hexToColor('#F4F4F4'),
      ),
    );
  }
}

class ContentItem extends StatelessWidget {
  String _title;
  String _Content;

  ContentItem(this._title, this._Content);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(top: ScreenAdaper.height(21)),
      alignment: Alignment.center,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: ScreenAdaper.width(30)),
            alignment: Alignment.centerRight,
            child: Text(
              _title ?? " ",
              style:
                  TextStyle(color: Colors.black, fontSize: ScreenAdaper.sp(24)),
            ),
          )),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: ScreenAdaper.width(30)),
            alignment: Alignment.centerLeft,
            child: Text(
              _Content ?? " ",
              style:
                  TextStyle(color: Colors.grey, fontSize: ScreenAdaper.sp(24)),
            ),
          ))
        ],
      ),
    );
  }
}
