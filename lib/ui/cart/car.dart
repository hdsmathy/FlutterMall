import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:olamall_app/config/Config.dart';
import 'package:olamall_app/event/event.dart';
import 'package:olamall_app/model/CarItemModel.dart';
import 'package:olamall_app/model/ProductModel.dart';
import 'package:olamall_app/net/DioManager.dart';
import 'package:olamall_app/net/api/woocommerce_config.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/order/submit_order.dart';
import 'package:olamall_app/ui/widgets/relate_list.dart';
import 'package:olamall_app/utils/LogUtil.dart';
import 'package:olamall_app/utils/SharePreferencesUtil.dart';
import 'package:olamall_app/utils/ToastUtils.dart';
import 'package:olamall_app/utils/UiUtils.dart';

class CarView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CarViewState();
  }
}

class _CarViewState extends State<CarView> {
  List<Data> carList = [];
  double totalPrice = 0.0;
  StreamSubscription carSubscription;
  CarItemModel _car;

  ///as you also like数据
  List<ProductModel> _productList = List();
  StreamSubscription mSubscription;
  String token;

  @override
  void initState() {
    super.initState();
    getData();
    _getProductList();
    //订阅eventbus
    carSubscription = eventBus.on<CarEvent>().listen((event) {
      getData();
    });
    mSubscription = eventBus.on<ClearCarEvent>().listen((event) {
      var list = event.getCarList();
      String cart_item_keys = "";
      for (var l in list) {
        cart_item_keys = cart_item_keys + l.key + ",";
      }
      if (cart_item_keys != "") {
        cart_item_keys = cart_item_keys.substring(0, cart_item_keys.length - 1);
      }
      _deleData(token, cart_item_keys);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: UiUtils.getAppBarNoBackStyle("Shopping Cart"),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Color.fromRGBO(245, 245, 245, 1),
              child: ListView(
                children: <Widget>[
                  _getContent(),
                  _updateBtn(),
//                  _getRemoved(),
                  _getTitleRelate(),
                  RelateList(_productList)
                ],
              ),
            ),
          ),
          _getBottom()
        ],
      ),
    );
  }

  Widget _getContent() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: carList.length,
      physics: new NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _getCarListView(index);
      },
    );
  }

  Widget _getCarListView(index) {
    var model = carList[index];
    var product = model.product;
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(
                ScreenAdaper.width(72),
                ScreenAdaper.height(20),
                ScreenAdaper.width(44),
                ScreenAdaper.height(20)),
            child: Row(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      width: ScreenAdaper.width(220),
                      height: ScreenAdaper.height(220),
                      child: Image.network(product.image, fit: BoxFit.cover),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0, ScreenAdaper.height(180), 0, 0),
                      width: ScreenAdaper.width(220),
                      height: ScreenAdaper.width(40),
                      color: Color.fromRGBO(255, 89, 89, 1),
                      alignment: Alignment.center,
                      child: Text(
                        product.stockStatus,
                        style: TextStyle(
                            color: Colors.white, fontSize: ScreenAdaper.sp(24)),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: _shopInfo(index),
                )
              ],
            ),
          ),
          Offstage(
            offstage: true, //控制显示隐藏true 表示隐藏，false表示显示
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(
                  ScreenAdaper.width(20),
                  ScreenAdaper.height(10),
                  ScreenAdaper.width(17),
                  ScreenAdaper.height(10)),
              color: Color.fromRGBO(244, 228, 231, 1),
              child: Row(
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.fromLTRB(0, 0, ScreenAdaper.width(10), 0),
                    child: Image.asset("images/ic_car_wraning.png"),
                  ),
                  Expanded(
                    child: Text(
                      "This item is not in stock. Please edit your cart and try again.",
                      style: TextStyle(
                          fontSize: ScreenAdaper.sp(20),
                          color: Color.fromRGBO(51, 51, 51, 1)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _shopInfo(index) {
    var model = carList[index];
    var product = model.product;
    var attrs = product.attributeSummaryArray;
    var size = "";
    for (var s in attrs) {
      if(s.val!=null&&s.val!=""&&s.val !=" ") {
        size = size + s.key + ": " + s.val + "; ";
      }
    }
    return Container(
      padding: EdgeInsets.fromLTRB(ScreenAdaper.width(18), 0, 0, 0),
      alignment: Alignment.topLeft,
      child: Column(
        children: <Widget>[
          UiUtils.getTextBlack26(product.title, maxLine: 2),
          Padding(
            padding: EdgeInsets.fromLTRB(0, ScreenAdaper.height(20), 0, 0),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              size,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: ScreenAdaper.sp(20),
                  color: Color.fromRGBO(153, 153, 153, 1)),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, ScreenAdaper.height(60), 0, 0),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text(
                    "\$" + product.price,
                    style: TextStyle(
                        fontSize: ScreenAdaper.sp(20),
                        color: Color.fromRGBO(255, 29, 29, 1)),
                  ),
                ),
                Expanded(child: Container()),
                _getAdd(index)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _getAdd(index) {
    var model = carList[index];
    var product = model.product;
    return Offstage(
      offstage: false,
      child: Container(
        width: ScreenAdaper.width(160),
        alignment: Alignment.centerRight,
        child: Row(
          children: <Widget>[
            Expanded(
                child: InkWell(
              onTap: () {
                setState(() {
                  if (model.quantity > 0) {
                    model.quantity = model.quantity - 1;
                  } else {
                    model.quantity = 0;
                  }
                });
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "-",
                  style: TextStyle(
                      color: Color.fromRGBO(153, 153, 153, 1),
                      fontSize: ScreenAdaper.sp(26)),
                ),
              ),
            )),
            Container(
              width: 1,
              height: ScreenAdaper.height(50),
              color: Color.fromRGBO(153, 153, 153, 1),
            ),
            Expanded(
                child: Container(
              alignment: Alignment.center,
              child: Text(
                model.quantity.toString(),
                style: TextStyle(
                    color: Color.fromRGBO(153, 153, 153, 1),
                    fontSize: ScreenAdaper.sp(26)),
              ),
            )),
            Container(
              width: 1,
              height: ScreenAdaper.height(50),
              color: Color.fromRGBO(153, 153, 153, 1),
            ),
            Expanded(
                child: InkWell(
              onTap: () {
                setState(() {
//                  if (model.quantity < product.stockQuantity) {
                  model.quantity = model.quantity + 1;
//                  } else {
//                    model.quantity = product.stockQuantity;
//                  }
                });
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "+",
                  style: TextStyle(
                      color: Color.fromRGBO(153, 153, 153, 1),
                      fontSize: ScreenAdaper.sp(26)),
                ),
              ),
            ))
          ],
        ),
        decoration: new BoxDecoration(
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          //设置四周边框
          border:
              new Border.all(width: 1, color: Color.fromRGBO(170, 170, 170, 1)),
        ),
      ),
    );
  }

  Widget _updateBtn() {
    return InkWell(
      onTap: () {
        _updateCar();
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(
            ScreenAdaper.width(0),
            ScreenAdaper.height(20),
            ScreenAdaper.width(0),
            ScreenAdaper.height(20)),
        color: Color.fromRGBO(255, 89, 89, 1),
        child: Text(
          "Update cart",
          style: TextStyle(
              fontSize: ScreenAdaper.sp(24),
              color: Color.fromRGBO(229, 229, 229, 1)),
        ),
      ),
    );
  }

  Widget _getRemoved() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, ScreenAdaper.width(20), 0, 0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 2,
        physics: new NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return _getCarListView(index);
        },
      ),
    );
  }

  Widget _getTitleRelate() {
    return Container(
      color: Color.fromRGBO(246, 243, 247, 1),
      height: ScreenAdaper.height(104),
      child: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Text(
              "== You Might Also Like ==",
              style: TextStyle(
                  fontSize: ScreenAdaper.sp(26),
                  color: Color.fromARGB(255, 0, 0, 0)),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            )
          ],
        ),
      ),
    );
  }

  Widget _getBottom() {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(
                  ScreenAdaper.width(0),
                  ScreenAdaper.height(0),
                  ScreenAdaper.width(10),
                  ScreenAdaper.height(0)),
              alignment: Alignment.centerRight,
              child: Text(
                "Total:",
                style: TextStyle(
                    color: Color.fromRGBO(153, 153, 153, 1),
                    fontSize: ScreenAdaper.sp(24)),
              ),
            ),
          ),
          Text(
            "\$${formatNum(totalPrice,2)}",
            style: TextStyle(
                color: Color.fromRGBO(242, 63, 43, 1),
                fontSize: ScreenAdaper.sp(24)),
          ),
          MaterialButton(
            child: Container(
              alignment: Alignment.center,
              height: ScreenAdaper.height(88),
              margin: EdgeInsets.fromLTRB(
                  ScreenAdaper.width(48),
                  ScreenAdaper.height(0),
                  ScreenAdaper.width(0),
                  ScreenAdaper.height(0)),
              padding: EdgeInsets.fromLTRB(
                  ScreenAdaper.width(65), 0, ScreenAdaper.width(65), 0),
              child: Text(
                "Check Out",
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenAdaper.sp(30)),
              ),
              decoration: BoxDecoration(
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Color.fromRGBO(248, 61, 0, 1)),
            ),
            onPressed: () {
              _checkOut();
            },
          )
        ],
      ),
    );
  }

  getData() async {
    String token = await SharePreferencesUtil.getToken().then((data) {
      return data;
    });
    if (null == token) {
      return;
    }
    var params = FormData();
    params.add("token", token);
    DioManager.getInstance().post(Config.LIST_CAR_PRODUCTS, params, (data) {
      _car = CarItemModel.fromJson(data);
      carList.clear();
      totalPrice = 0.00;
      for (var item in _car.data) {
        if (item.product.stockStatus == "outofstock") {
          item.quantity = item.addQuantity = 0;
        }
        totalPrice =
            (item.quantity * double.parse(item.product.price ?? "0.00")) +
                totalPrice;
        carList.add(item);
      }
      setState(() {});
    }, (error) {
      LogUtil.logE("CarView", error.toString());
    });
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

  _updateCar() async {
    token = await SharePreferencesUtil.getToken().then((data) {
      return data;
    });
    if (null == token) {
      return;
    }
    for (var a in carList) {
      if (a.addQuantity == a.quantity) {
        continue;
      }
      if (a.quantity == 0) {
        _deleData(token, a.key);
      }
      var params = FormData();
      params.add("token", token);
      params.add("cart_item_key", a.key);
      params.add("number", (a.quantity - a.addQuantity));
      DioManager.getInstance().post(Config.UPDATE_TO_CAR_URL, params, (data) {
        getData();
      }, (error) {
        ToastUtils.showToast(error);
      });
    }
  }

  _deleData(String token, key) async {
    if (token == null || token == "") {
      token = await SharePreferencesUtil.getToken().then((data) {
        return data;
      });
    }
    var params = FormData();
    params.add("token", token);
    params.add("cart_item_key", key);
    DioManager.getInstance().post(Config.DEL_TO_CAR_URL, params, (data) {
      getData();
    }, (error) {
      ToastUtils.showToast(error);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //取消订阅
    carSubscription?.cancel();
    mSubscription?.cancel();
  }

  void _checkOut() {
    LogUtil.logD("CarView", "len =" + carList.length.toString());
    if (null != carList && carList.length != 0 && null != totalPrice) {
      List<Data> list = [];
      var price = 0.00;
      for (var l in carList) {
        if (l.product.stockStatus == "instock") {
          list.add(l);
          price =
              (l.quantity * double.parse(l.product.price ?? "0.00")) + price;
        }
      }

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SubmitOrderView(totalPrice, list)));
    } else {
      ToastUtils.showToast("Car not product");
    }
  }


  formatNum(double num,int postion){
    if((num.toString().length-num.toString().lastIndexOf(".")-1)<postion){
      //小数点后有几位小数
      return num.toStringAsFixed(postion).substring(0,num.toString().lastIndexOf(".")+postion+1);
    }else{
      return num.toString().substring(0,num.toString().lastIndexOf(".")+postion+1);
    }
  }
}
