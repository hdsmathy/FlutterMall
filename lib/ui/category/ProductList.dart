import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olamall_app/config/Config.dart';
import 'package:olamall_app/model/CateModel.dart';
import 'package:olamall_app/model/OldProdeuctListModel.dart';
import 'package:olamall_app/net/DioManager.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/commodity/CommodityDetailsPage.dart';
import 'package:olamall_app/utils/LogUtil.dart';
import 'package:olamall_app/ui/goods/search_goods_list_view.dart';
class ProductListPage extends StatefulWidget {
  Ch ch;

  ProductListPage({Key key, @required this.ch}) : super(key: key);

  _ProductListPageState createState() => _ProductListPageState(ch);
}

class _ProductListPageState extends State<ProductListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List screenCardList = [];
  int _selectIndex = 0; //选中的下标
  int showScreenSize = 4; //显示多少个
  bool isShowMore = false;
  int category = 0;

  _ProductListPageState(Ch ch1) {
    var ch = ch1.ch;
    screenCardList = ch;
    if (ch != null && ch.length > 0) {
      category = screenCardList[0].iD;
    } else {
      category = ch1.iD;
    }
    if (screenCardList.length > 4) {
      showScreenSize = 4;
    } else {
      showScreenSize = screenCardList.length;
    }
  }

  @override
  void initState() {
    super.initState();
    _getProductlist();
  }

  List _productList = [];

  //商品列表
  Widget _productListWidget() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(
          top: ScreenAdaper.height(150) +
              MediaQueryData.fromWindow(window).padding.top),
      child: _getRelateList(),
    );
  }

  //筛选导航
  Widget _subHeaderWidget() {
    return Positioned(
      top: 0,
      width: ScreenAdaper.width(750),
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.fromLTRB(
            0, MediaQueryData.fromWindow(window).padding.top, 0, 0),
        height: ScreenAdaper.height(96) +
            MediaQueryData.fromWindow(window).padding.top,
        child: Column(
          children: <Widget>[_getTitle(), _getSort()],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
//        appBar: AppBar(
//          title: Text("商品列表"),
//          // leading: Text(""),
//          actions: <Widget>[Text("")],
//        ),
        endDrawer: Drawer(
          child: _getScreen(),
        ),
        body: Stack(
          children: <Widget>[
            _productListWidget(),
            _subHeaderWidget(),
          ],
        ));
  }

  Widget _getScreen() {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: Text(
                    "Categories",
                    style: TextStyle(
                        fontSize: ScreenAdaper.sp(26),
                        color: Color.fromRGBO(51, 51, 51, 1)),
                  ),
                ),
                _getScreenList(),
                _getShowMore(),
//                _getScreenPrice()
              ],
            ),
          ),
        ),
        Container(height: 1, color: Color.fromRGBO(248, 246, 249, 1)),
        Container(
          height: ScreenAdaper.height(86),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Reset",
                    style: TextStyle(
                        fontSize: ScreenAdaper.sp(28),
                        color: Color.fromRGBO(102, 102, 102, 1)),
                  ),
                ),
              ),
              Container(width: 1, color: Color.fromRGBO(248, 246, 249, 1)),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Done",
                    style: TextStyle(
                        fontSize: ScreenAdaper.sp(28),
                        color: Color.fromRGBO(249, 59, 0, 1)),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _getScreenList() {
    return GridView.builder(
      shrinkWrap: true,
      physics: new NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 240 / 86,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemCount: showScreenSize,
      itemBuilder: (context, index) {
        return _ScreenListCard(index);
      },
    );
  }

  Widget _ScreenListCard(index) {
    return GestureDetector(
        onTap: () {
          setState(() {
            _selectIndex = index;
          });
          category = screenCardList[index].iD;
          _getProductlist();
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            //设置四周圆角 角度
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            color: _selectIndex == index
                ? Colors.white
                : Color.fromRGBO(244, 244, 244, 1),
            //设置四周边框
            border: new Border.all(
                width: 1,
                color: _selectIndex == index
                    ? Color.fromRGBO(220, 74, 64, 1)
                    : Color.fromRGBO(244, 244, 244, 1)),
          ),
          child: Text(
            screenCardList[index].title,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            // 显示不完，就在后面显示点点
            style: TextStyle(
              fontSize: ScreenAdaper.sp(24),
              color: _selectIndex == index
                  ? Color.fromRGBO(220, 74, 64, 1)
                  : Color.fromRGBO(102, 102, 102, 1),
            ),
          ),
        ));
  }

  /**
   * 筛选跟多按钮
   */
  Widget _getShowMore() {
    return GestureDetector(
        onTap: () {
          setState(() {
            isShowMore = !isShowMore;
            if (isShowMore) {
              showScreenSize = screenCardList.length;
            } else {
              showScreenSize = 4;
            }
          });
        },
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Text(
                    "show more",
                    style: TextStyle(
                        fontSize: ScreenAdaper.sp(24),
                        color: Color.fromRGBO(102, 102, 102, 1)),
                  ),
                  Icon(
                    isShowMore
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Color.fromRGBO(153, 153, 153, 1),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
            ),
            Container(
              color: Color.fromRGBO(229, 229, 229, 1),
              height: 1,
              margin: EdgeInsets.fromLTRB(
                  ScreenAdaper.width(20),
                  ScreenAdaper.height(20),
                  ScreenAdaper.width(20),
                  ScreenAdaper.height(20)),
            )
          ],
        ));
  }

  Widget _getScreenPrice() {
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: Text(
              "Price",
              style: TextStyle(
                  fontSize: ScreenAdaper.sp(26),
                  color: Color.fromRGBO(51, 51, 51, 1)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Expanded(
                  child: Theme(
                data: new ThemeData(
                    primaryColor: Color.fromRGBO(153, 153, 153, 1),
                    hintColor: Colors.black),
                child: TextField(
                  textAlign: TextAlign.center,
                  cursorColor: Colors.black,
                  style: TextStyle(
                      fontSize: ScreenAdaper.sp(24), color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
//                    contentPadding: EdgeInsets.fromLTRB(ScreenAdaper.width(10), ScreenAdaper.height(5), ScreenAdaper.width(10), ScreenAdaper.height(5)),
                    hintText: 'min',
                    hintStyle: TextStyle(
                        fontSize: ScreenAdaper.sp(24),
                        color: Color.fromRGBO(153, 153, 153, 1)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              )),
              Padding(
                padding: EdgeInsets.all(6),
              ),
              Container(
                height: 1,
                width: ScreenAdaper.width(28),
                color: Color.fromRGBO(153, 153, 153, 1),
              ),
              Padding(
                padding: EdgeInsets.all(6),
              ),
              Expanded(
                  child: Theme(
                data: new ThemeData(
                    primaryColor: Color.fromRGBO(153, 153, 153, 1),
                    hintColor: Colors.black),
                child: TextField(
                  textAlign: TextAlign.center,
                  cursorColor: Colors.black,
                  style: TextStyle(
                      fontSize: ScreenAdaper.sp(24), color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
//                    contentPadding: EdgeInsets.fromLTRB(ScreenAdaper.width(10), ScreenAdaper.height(5), ScreenAdaper.width(10), ScreenAdaper.height(5)),
                    hintText: 'max',
                    hintStyle: TextStyle(
                        fontSize: ScreenAdaper.sp(24),
                        color: Color.fromRGBO(153, 153, 153, 1)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              )),
              Padding(
                padding: EdgeInsets.all(10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getTitle() {
    return Container(
        child: Row(
      children: <Widget>[
        Container(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop(1);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: ScreenAdaper.height(64),
            margin: EdgeInsets.fromLTRB(
                ScreenAdaper.width(20),
                ScreenAdaper.height(12),
                ScreenAdaper.height(12),
                ScreenAdaper.width(20)),
            padding: EdgeInsets.fromLTRB(ScreenAdaper.width(30), 0, 0, 0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 244, 244, 244),
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            child:InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SearchGoodsListView()),);
              },
              child:  Row(
                children: <Widget>[
                  Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 181, 181, 182),
                  ),
                  Text("搜索",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // 显示不完，就在后面显示点点
                      style: TextStyle(
                        fontSize: ScreenAdaper.sp(26), // 文字大小
                        color: Color.fromARGB(255, 187, 188, 189), // 文字颜色
                      ))
                ],
              ),
            ),
          ),
        ),
        Container(
          width: ScreenAdaper.width(50),
          height: ScreenAdaper.height(50),
          child: Stack(
            children: <Widget>[
              Container(
                child: Image.asset("images/ic_product_car.png"),
                margin: EdgeInsets.fromLTRB(
                    ScreenAdaper.width(5),
                    ScreenAdaper.width(5),
                    ScreenAdaper.width(5),
                    ScreenAdaper.width(5)),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(ScreenAdaper.width(20), 0, 0, 0),
                alignment: Alignment.center,
                width: ScreenAdaper.width(25),
                height: ScreenAdaper.height(25),
                child: Text(
                  "99",
                  style: TextStyle(
                      fontSize: ScreenAdaper.sp(20), color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
              )
            ],
          ),
        )
      ],
    ));
  }

  Widget _getSort() {
    return Container(
      height: ScreenAdaper.height(31),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(
                ScreenAdaper.width(20), 0, ScreenAdaper.width(20), 0),
            child: Text(
              "Sort by popularity",
              style: TextStyle(
                  fontSize: ScreenAdaper.sp(24),
                  color: Color.fromRGBO(102, 102, 102, 1)),
            ),
          ),
          Image.asset("images/ic_product_sort.png"),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                ScreenAdaper.width(20), 0, ScreenAdaper.width(20), 0),
            child: InkWell(
              child: Image.asset("images/ic_product_screen.png"),
              onTap: () {
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _getRelateList() {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: GridView.builder(
//          physics: new NeverScrollableScrollPhysics(),
//          shrinkWrap: true,
          padding: EdgeInsets.all(0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemCount: _productList.length,
          itemBuilder: (context, index) {
            //处理图片
//            String pic = this._shopList[index].pic;
//          pic = Config.domain + pic.replaceAll('\\', '/');
            String dicount;

            var productModel = _productList[index];
            var price = productModel.price;
            var regularPrice = productModel.regularPrice;
            if (null == regularPrice ||
                null == price ||
                "" == regularPrice ||
                "" == price) {
              dicount = "0%";
            } else {
              var regularPrice2 = double.parse(regularPrice);
              var chajia = regularPrice2 - double.parse(price);

              double a = (chajia / regularPrice2) * 100;
              var split = a.toString().split(".");
              dicount = split[0]+"%";
            }
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CommodityDetailsPage(iD: _productList[index].id)),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      color: Colors.white),
                  // padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              //设置四周圆角 角度
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all(
                                  width: 1,
                                  color: Color.fromRGBO(254, 61, 61, 1))),
                          child: Text(
                            dicount,
                            style: TextStyle(
                                fontSize: ScreenAdaper.sp(18),
                                color: Color.fromRGBO(254, 61, 61, 1)),
                          ),
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(ScreenAdaper.width(25),
                              0, ScreenAdaper.width(25), 0),
                          child: Image.network(
                              _productList[index].images[0].src,
                              fit: BoxFit.cover),
                        ),
                      ),
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.fromLTRB(
                                ScreenAdaper.width(25),
                                ScreenAdaper.width(18),
                                ScreenAdaper.width(28),
                                0),
                            alignment: Alignment.topLeft,
                            constraints: BoxConstraints(
                              minHeight: ScreenAdaper.height(92),
                            ),
                            child: Text(_productList[index].title,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                // 显示不完，就在后面显示点点
                                style: TextStyle(
                                  fontSize: ScreenAdaper.sp(24), // 文字大小
                                  color: Color.fromRGBO(51, 51, 51, 1), // 文字颜色
                                ))),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(ScreenAdaper.width(25), 0,
                            ScreenAdaper.width(28), ScreenAdaper.width(30)),
                        alignment: Alignment.topLeft,
                        child: Text(
                          "\$ " + _productList[index].price,
                          style: TextStyle(
                            fontSize: ScreenAdaper.sp(30), // 文字大小
                            color: Color.fromRGBO(255, 89, 89, 1), // 文字颜色
                          ),
                        ),
                      )
                    ],
                  ),
                ));
          },
        ));
  }

  void _getProductlist() {
    FormData params = FormData.from({"category": category});

    DioManager.getInstance().get(Config.COMMODITY_DETAILS_URL, params, (data) {
      var products = new OldProdeuctListModel.fromJson(data);
      if (products != null) {
        setState(() {
          _productList.addAll(products.products);
        });
      }
//      setState(() {
//        this._leftCateList = left.data;
//      });
    }, (error) {
//      ToastUtils.showToast(error.toString());
      LogUtil.logE("ProductListPageProductListPage", error.toString());
    });
  }
}
