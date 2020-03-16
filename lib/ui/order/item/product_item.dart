import 'package:flutter/material.dart';
import 'package:olamall_app/model/CarItemModel.dart' as ItemModel;
import 'package:olamall_app/model/ProductModel.dart';
import 'package:olamall_app/net/api/woocommerce_config.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/LogUtil.dart';

class OrderProductItem extends StatefulWidget {

  ItemModel.Data data;
  double marginTop;

  OrderProductItem(this.data, {this.marginTop = 10});

  @override
  _OrderProductItemState createState() => _OrderProductItemState();
}

class _OrderProductItemState extends State<OrderProductItem> {

  // TODO: implement build
  String imageUrl = " ";
  String title = " ";
  String price = " ";
  String color = " ";
  String quantity = " ";
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (null != widget.data && null != widget.data.product) {

      imageUrl = widget.data.product.image;
      title = widget.data.product.title;
      price = widget.data.product.price;
      var attrs = widget.data.product.attributeSummaryArray;
      for (var s in attrs) {
        color = color + s.key + s.val + "; ";
      }
      quantity = widget.data.quantity.toString();

    }
    if(null != widget.data && null == widget.data.product){
      quantity = widget.data.quantity.toString();
      //获取商品详情
      WooCommerceConfig.getInstance().getDataAsync(
          endPoint: "products/${widget.data.productId}",
          success: (result) {
            var details = new ProductModel.fromJson(result);
            title = details.name;
            price = details.price;
            aa:for (var o in details.images) {
              imageUrl = o.src;
              break aa;
            }
            setState(() {});
          },
          error: (e) {
            print(e);
          });
    }
  }


  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: ScreenAdaper.height(widget.marginTop)),
      padding: EdgeInsets.only(
          left: ScreenAdaper.width(20), bottom: ScreenAdaper.height(30)),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: ScreenAdaper.width(212),
            height: ScreenAdaper.height(212),
            child: Image.network(imageUrl),
          ),
          Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        left: ScreenAdaper.width(13),
                        top: ScreenAdaper.width(36),
                        right: ScreenAdaper.width(124)),
                    child: Text(
                      title,
                      style: TextStyle(
                          color: Colors.black, fontSize: ScreenAdaper.sp(26)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: ScreenAdaper.width(13),
                        top: ScreenAdaper.height(19),
                        right: ScreenAdaper.width(25)),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            color??" ",
                            style: TextStyle(
                                color: Colors.grey, fontSize: ScreenAdaper.sp(20)),
                          ),
                        ),
                        Container(
                          child: Text(
                            "x ${quantity}",
                            style: TextStyle(
                                color: Colors.grey, fontSize: ScreenAdaper.sp(20)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: ScreenAdaper.width(14),
                        top: ScreenAdaper.height(56),
                        right: ScreenAdaper.width(25)),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "\$ ${price}",
                      style: TextStyle(
                          color: ColorsUtil.hexToColor("#FF1D1D"),
                          fontSize: ScreenAdaper.sp(20)),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}



