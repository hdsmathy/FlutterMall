import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:olamall_app/config/Config.dart';
import 'package:olamall_app/constant/string.dart';
import 'package:olamall_app/model/OrderListModel.dart';
import 'package:olamall_app/net/DioManager.dart';
import 'package:olamall_app/net/api/woocommerce_config.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/card/bind_card.dart';
import 'package:olamall_app/ui/mall.dart';
import 'package:olamall_app/ui/order/order_detail.dart';
import 'package:olamall_app/ui/payment/pay_success.dart';
import 'package:olamall_app/ui/payment/payment.dart';
import 'package:olamall_app/ui/widgets/custom_line.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/LogUtil.dart';
import 'package:olamall_app/utils/SharePreferencesUtil.dart';
import 'package:olamall_app/utils/ToastUtils.dart';
import 'package:olamall_app/utils/UiUtils.dart';
import 'dart:convert' as convert;

/**
 * 订单管理界面
 */

class OrderManagementView extends StatefulWidget {
  @override
  _OrderManagementViewState createState() => _OrderManagementViewState();
}

class _OrderManagementViewState extends State<OrderManagementView> {
  EasyRefreshController _controller = EasyRefreshController();
  var _page = 1;
  var _per_page = 10;
  List<OrderListModel> orderListModelList = new List();
  String _userid;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Scaffold(
        backgroundColor: ColorsUtil.hexToColor('#F4F4F4'),
        appBar: UiUtils.getAppBarStyle("My Orders", context: context),
        body: EasyRefresh(
//          emptyWidget: Center(child: Text("not data"),),
//          header: CustomHeader(), ///需要自定义
//          header: MaterialHeader(),
          header: ClassicalHeader(extent: 70),
          firstRefresh: true,
          controller: _controller,
          child: ListView.builder(
            itemCount: orderListModelList.length,
            itemBuilder: (context, i) =>
                OrderManagementItem(orderListModelList[i],(){
                  _deleteOrder(orderListModelList[i].id.toString());
                }),
//          controller: _scrollController,
          ),
          onRefresh: _onRefresh,
          onLoad: _onLoad,
        ),
      ),
    );
  }

  Future<void> _onLoad() async {
    _page++;
    _getData();
    return null;
  }

  Future<void> _onRefresh() async {
    _page = 1;
    _getData();
    return null;
  }

  void _getData() async {
    if (null == _userid) {
      ///获取登陆的用户信息
      _userid = await SharePreferencesUtil.getLoginMsg().then((data) {
        String uid = data["id"];
        return uid ??= null;
      });
    }
    WooCommerceConfig.getInstance().getDataAsync(
        endPoint: "orders?&page=$_page&per_page=$_per_page&customer=$_userid",
        success: (data) {
          try {
            List list = data["data"];
            LogUtil.logD("orders", "size = ${list.length}");
            List<OrderListModel> list1 = new List();
            for (var item in list) {
              var orderListModel = OrderListModel.fromJson(item);
              for (var o in orderListModel.lineItems) {
                orderListModel.totalNumber =
                    orderListModel.totalNumber + o.quantity;
              }
              list1.add(orderListModel);
            }
            if(_page == 1){
              orderListModelList.clear();
              orderListModelList.addAll(list1);
            }else{
              orderListModelList.addAll(list1);
            }
            if(_per_page>list.length){
              _controller.finishLoad(success: true, noMore: true);
            }else{
              _controller.finishLoad(success: true, noMore: false);
            }
            setState(() {});
          } catch(e){
            LogUtil.logE("OrderManagementView", e.toString());
          }
        },
        error: (e) {
          LogUtil.logE("OrderManagementView", e.toString());
          _controller.finishLoad(success: true);
          setState(() {});
        });
  }


  ///点击删除订单
  void _deleteOrder(String id) {
//    ToastUtils.showToast("点击删除订单,请先忽略");
    WooCommerceConfig.getInstance()
        .deleteDataAsync(endPoint: "orders/${id}", queryAtId: null,success: (data){
      if(data['id'].toString() == id){
        _onRefresh();
        ToastUtils.showToast("Delete success");
      }else{
        ToastUtils.showToast("Delete fail");
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller?.dispose();
  }
}

class OrderManagementItem extends StatelessWidget {
  OrderListModel _orderListModel;
  Function cancel;

  OrderManagementItem(this._orderListModel,this.cancel);

  bool _isHidePayBtn = false;
  bool _isHideViewBtn = false;
  bool _isHideCancelBtn = false;

  @override
  Widget build(BuildContext context) {
    var status = _orderListModel.status;

    ///根据订单状态显示隐藏 按钮
    if ("completed" == status) {
      _isHidePayBtn = true;
      _isHideCancelBtn = true;

    } else if ("processing" == status) {
      if(_orderListModel.paymentMethodTitle.contains("Credit Card") || _orderListModel.paymentMethodTitle.contains("MPGS")){
        _isHidePayBtn = false;
      }else
        _isHidePayBtn = true;
    } else if ("pending" == status) {
      _isHidePayBtn = true;
    }

    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: ScreenAdaper.height(10)),
      child: Column(
        children: <Widget>[

          ///order订单
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(
                ScreenAdaper.width(20),
                ScreenAdaper.height(30),
                ScreenAdaper.width(20),
                ScreenAdaper.height(30)),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text(
                    "Order",
                    style: TextStyle(
                        color: Colors.black, fontSize: ScreenAdaper.sp(26)),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: ScreenAdaper.width(30)),
                    child: Text(
                      "#${_orderListModel.number}",
                      style: TextStyle(
                          color: ColorsUtil.hexToColor("#666666"),
                          fontSize: ScreenAdaper.sp(26)),
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    status,
                    style: TextStyle(
                        color: ColorsUtil.hexToColor("#666666"),
                        fontSize: ScreenAdaper.sp(26)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: CustomPaint(
              foregroundPainter: new CustomLine(width: MallApp.screenWidth),
            ),
          ),

          ///date 日期
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(
                ScreenAdaper.width(20),
                ScreenAdaper.height(30),
                ScreenAdaper.width(20),
                ScreenAdaper.height(30)),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text(
                    "Date",
                    style: TextStyle(
                        color: Colors.black, fontSize: ScreenAdaper.sp(26)),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: ScreenAdaper.width(30)),
                    child: Text(
                      _orderListModel.dateCreated
                          .replaceAll("T", " ")
                          .toString(),
                      style: TextStyle(
                          color: ColorsUtil.hexToColor("#666666"),
                          fontSize: ScreenAdaper.sp(26)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          ///Total
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(ScreenAdaper.width(20), 0,
                ScreenAdaper.width(20), ScreenAdaper.height(30)),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text(
                    "Total",
                    style: TextStyle(
                        color: Colors.black, fontSize: ScreenAdaper.sp(26)),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: ScreenAdaper.width(30)),
                    child: Text(
                      "\$  ${_orderListModel?.total ?? ""} for ${_orderListModel.totalNumber} item",
                      style: TextStyle(
                          color: ColorsUtil.hexToColor("#FF1D1D"),
                          fontSize: ScreenAdaper.sp(26)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: CustomPaint(
              foregroundPainter: new CustomLine(
                  width: MallApp.screenWidth - ScreenAdaper.width(20) * 2),
            ),
          ),

          ///三个按钮 Pay View Cancel
          Container(
            padding: EdgeInsets.only(
                top: ScreenAdaper.height(30), bottom: ScreenAdaper.height(30)),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Offstage(
                      offstage: _isHidePayBtn,
                      child: Container(
                        height: ScreenAdaper.height(64),
                        margin: EdgeInsets.only(left: ScreenAdaper.width(20)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),

                            ///圆角
                            border: Border.all(
                                color: ColorsUtil.hexToColor("#F83D00"),
                                width: 1)

                          ///边框颜色、宽
                        ),
                        child: MaterialButton(
                          onPressed: () {

                            //todo  结算付款按钮 总金额还需要加上邮费 widget._totalPrice + 邮费
                            String payway =  _orderListModel.paymentMethodTitle;
                            LogUtil.logD("payway", "${payway}");
                            ///判断选择支付方式跳转
                            if (payway.contains("Credit Card") || payway.contains("MPGS")) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => BindCardView(_orderListModel)));
                            } else if (payway.contains("Cash on Delivery") || payway.contains("货到付款")) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PaySuccessView(
                                              type: 2, orderListModel: _orderListModel)));
                            } else if (payway.contains("Bank Transfer") || payway.contains("银行汇款")) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PaySuccessView(
                                              type: 1, orderListModel: _orderListModel)));
                            } else if (payway.contains("PayPal")) {}
//                            ///点击支付
//                            Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) =>
//                                        PaymentView(_orderListModel)));
                          },
                          child: Text(
                            Strings.ORDER_PAY,
                            style: TextStyle(
                                color: ColorsUtil.hexToColor("#F83D00"),
                                fontSize: ScreenAdaper.sp(30)),
                          ),
//                      shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.all(Radius.circular(30)),
//                      ),

                          minWidth: double.infinity,
                        ),
                      ),
                    )),

                ///View
                Expanded(
                    child: Offstage(
                      offstage: _isHideViewBtn,
                      child: Container(
                        height: ScreenAdaper.height(64),
                        margin: EdgeInsets.only(left: ScreenAdaper.width(64)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),

                            ///圆角
                            border: Border.all(color: Colors.grey, width: 1)

                          ///边框颜色、宽
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OrderDetailView(type: 2,
                                          orderListModel: _orderListModel,
                                        )));
                          },
                          child: Text(
                            Strings.ORDER_VIEW,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: ScreenAdaper.sp(30)),
                          ),
//                      shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.all(Radius.circular(30)),
//                      ),

                          minWidth: double.infinity,
                        ),
                      ),
                    )),

                /// 删除
                Expanded(
                    child: Offstage(
                      offstage: _isHideCancelBtn,
                      child: Container(
                        height: ScreenAdaper.height(64),
                        margin: EdgeInsets.only(
                            left: ScreenAdaper.width(64),
                            right: ScreenAdaper.width(20)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),

                            ///圆角
                            border: Border.all(color: Colors.grey, width: 1)

                          ///边框颜色、宽
                        ),
                        child: MaterialButton(
                          onPressed: cancel,
                          child: Text(
                            Strings.ORDER_CANCEL,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: ScreenAdaper.sp(30)),
                          ),
//                      shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.all(Radius.circular(30)),
//                      ),

                          minWidth: double.infinity,
                        ),
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }


}
