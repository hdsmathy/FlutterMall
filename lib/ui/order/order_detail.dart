import 'package:flutter/material.dart';
import 'package:olamall_app/constant/string.dart';
import 'package:olamall_app/model/CarItemModel.dart' as ItemModel;
import 'package:olamall_app/model/OrderListModel.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/order/item/address_item.dart';
import 'package:olamall_app/ui/order/order_management.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/UiUtils.dart';

import 'item/list_title_item.dart';
import 'item/product_item.dart';

/**
 * 订单详情页面
 */

class OrderDetailView extends StatefulWidget {
  int type;

  /// 1 是支付成功页面跳转而来  2 其他页面
  OrderListModel orderListModel;

  OrderDetailView({this.type = 1, this.orderListModel});

  @override
  _OrderDetailViewState createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  var _totalPrice;

  List<ItemModel.Data> _productList = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (null != widget.orderListModel) {}

    _totalPrice = widget.orderListModel.total ?? " ";
    for (var item in widget.orderListModel.lineItems) {
      ItemModel.Data data = new ItemModel.Data();
      data.quantity = item.quantity;
      data.productId = item.productId;
      _productList.add(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          backgroundColor: ColorsUtil.hexToColor("#F4F4F4"),
          appBar: UiUtils.getAppBar("Order Details", () {
            if (widget.type == 1)///支付成功页面跳转而来，返回则回到主页
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OrderManagementView()));
            else
              Navigator.pop(context);
          }),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                /// 订单基本信息 OrderNumber Placed on: Status
                Container(
                  margin: EdgeInsets.only(top: ScreenAdaper.height(10)),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        var item;
                        switch (index) {
                          case 0:
                            item = ListTitleItem(
                                title: "Order#",
                                content: widget.orderListModel?.number,
                                padTop: 40);
                            break;
                          case 1:
                            item = ListTitleItem(
                                title: "Placed on:",
                                content: widget.orderListModel.dateCreated
                                    .replaceAll("T", " "),
                                padTop: 30);
                            break;
                          case 2:
                            item = ListTitleItem(
                              title: "Status:",
                              content: widget.orderListModel.status,
                              padTop: 21,
                              padBottom: 39,
                            );
                            break;
                        }
                        return item;
                      }),
                ),

                ///product 产品
                _informationItem(Strings.ORDER_DETAIL_PRODUCT, "",
                    marginTop: 10),

                ///每个商品item
                Container(
                  child: ListView.builder(
                    itemCount: _productList.length,
                    itemBuilder: (context, i) => OrderProductItem(
                      _productList[i],
                      marginTop: 4,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), //禁用ListView滚动事件
                  ),
                ),

                ///Subtotal 产品
                _informationItem(
                    Strings.ORDER_DETAIL_SUBTOTAL, "\$ ${_totalPrice}",
                    marginTop: 2,
                    titleColor: Colors.grey,
                    informationColor: ColorsUtil.hexToColor("#FF1D1D")),

                ///Shipping:
                _informationItem(
                    Strings.ORDER_DETAIL_SHIPPING, r"Via Shipping fee $0.00",
                    marginTop: 10),

                ///Payment method:
                _informationItem(Strings.ORDER_DETAIL_PAYMENT,
                    "${widget.orderListModel.paymentMethodTitle=="MPGS"?"Credit Card":widget.orderListModel.paymentMethodTitle?? ""}",
                    marginTop: 2),

                ///Total :
                _informationItem(
                    Strings.ORDER_DETAIL_TOTAL, "\$ ${_totalPrice}",
                    marginTop: 2),

                Container(
                  margin: EdgeInsets.only(
                      top: ScreenAdaper.height(6),
                      bottom: ScreenAdaper.height(50)),
                  child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (context, i) {
                      var item;
                      switch (i) {
                        case 0:
                          item = AddressItem(
                              billing: widget.orderListModel.billing);
                          break;
                        case 1:
                          item = AddressItem(
                              shipping: widget.orderListModel.shipping);
                          break;
                      }
                      return item;
                    },
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), //禁用ListView滚动事件
                  ),
                ),
              ],
            ),
          )),
    );
  }

  ///单个横条组件
  Widget _informationItem(String title, String information,
      {double titleSize = 26,
      Color titleColor = Colors.black,
      double informationSize = 26,
      Color informationColor = Colors.grey,
      double marginTop = 0}) {
    return Container(
        margin: EdgeInsets.only(top: ScreenAdaper.height(marginTop)),
        color: Colors.white,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(
            left: ScreenAdaper.width(20),
            top: ScreenAdaper.height(33),
            bottom: ScreenAdaper.height(33)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
//            Strings.ORDER_DETAIL_PRODUCT,
                title,
                style: TextStyle(
                    color: titleColor,
                    fontSize: ScreenAdaper.sp(titleSize),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: ScreenAdaper.width(22)),
              child: Text(
                information,
                style: TextStyle(
                  color: informationColor,
                  fontSize: ScreenAdaper.sp(informationSize),
                ),
              ),
            )
          ],
        ));
  }
}
