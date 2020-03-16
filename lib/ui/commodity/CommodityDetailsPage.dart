import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:olamall_app/config/Config.dart';
import 'package:olamall_app/event/event.dart';
import 'package:olamall_app/model/AddCarModel.dart';
import 'package:olamall_app/model/AttributesCheckModel.dart';
import 'package:olamall_app/model/AtttributesOption.dart';
import 'package:olamall_app/model/ErrorModel.dart';
import 'package:olamall_app/model/ProductModel.dart';
import 'package:olamall_app/model/VariationsModel.dart';
import 'package:olamall_app/net/DioManager.dart';
import 'package:olamall_app/net/api/woocommerce_config.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/widgets/progress_dialog.dart';
import 'package:olamall_app/ui/widgets/relate_list.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/DateUtils.dart';
import 'package:olamall_app/utils/LogUtil.dart';
import 'package:olamall_app/utils/SharePreferencesUtil.dart';
import 'package:olamall_app/utils/ToastUtils.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sharesdk_plugin/sharesdk_plugin.dart';

class CommodityDetailsPage extends StatefulWidget {
  final int iD;
  final String commission;
  CommodityDetailsPage({Key key, @required this.iD, @required this.commission})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => CommodityDetailsState();
}

class CommodityDetailsState extends State<CommodityDetailsPage> {
  //商品详情html
  String _url_content = "";
  String commodityTitle = "";
  String commodityMoney = "0.00";
  String commoditySize = "";
  List _imageUrl = [];
  List attributes = [];
  int imgIndex = 0;
  int imgSize = 0;
  String _type;
  //是商品列表
  int _Number = 1;
  List<ProductModel> _productList = List();
  List<VariationsModel> _variationslist = [];
  List<String> attr  = [];//用户提交购物车属性
  bool isSelect = false;
  bool _loading = true;
  String regular_price = "0.00";
  String stock_status = "outofstock";
  String shareTitle = "";
  String shareText = "";
  String shareUrl = "";
  @override
  void initState() {
    super.initState();
    LogUtil.logD("CommodityDetailsPage", "id = ${widget.iD}");
    _getData();
    _getProductList();
    _getVariations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressDialog(
        loading: _loading,
        msg: 'loading...',
        child:  Stack(
          children: <Widget>[
            _Content(),
            _getTopBar(context),
          ],
        ),
      ),
    );
  }

  Widget _getTopBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          0, MediaQueryData.fromWindow(window).padding.top, 0, 0),
      child: Container(
        height: ScreenAdaper.height(50),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(ScreenAdaper.width(20), 0, 0, 0),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(1);
                  },
                  child: Image.asset("images/icon_commodity_back.png",
//                      height: ScreenAdaper.height(40),
//                      width: ScreenAdaper.width(40),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showShareMenu(context);
              },
              child: Image.asset(
                "images/icon_commodity_share.png",
//                height: ScreenAdaper.height(40),
//                width: ScreenAdaper.width(40),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, ScreenAdaper.width(29), 0),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).popUntil(ModalRoute.withName('/main'));
                eventBus.fire(MainSelectEvent(2));
//                ToastUtils.showToast("购物车按钮");
              },
              child: Image.asset("images/icon_commodity_shop_car.png",
//                  height: ScreenAdaper.height(40),
//                  width: ScreenAdaper.width(40),
                  fit: BoxFit.cover),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, ScreenAdaper.width(20), 0),
            ),
          ],
        ),
      ),
    );
  }

  _getSwiperView() {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
              child: _swipper(),
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Offstage(
                    offstage: widget.commission == null,
                    child: _getCommission(),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(),
                  flex: 1,
                ),
                _getItemSize()
              ],
            ),
          )
        ],
      ),
    );
  }

  _getItemSize() {
    return Container(
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
        decoration: BoxDecoration(
            //设置四周圆角 角度
            borderRadius: BorderRadius.all(Radius.circular(50)),
            color: ColorsUtil.hexToColor("#DAD8D9")),
        child: Text(
          "$imgIndex/$imgSize",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: ScreenAdaper.sp(24), color: Colors.white),
        ),
      ),
    );
  }

  _getCommission() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(50)),
          border: Border.all(width: 1, color: Color.fromRGBO(254, 61, 61, 1))),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(254, 61, 61, 1),
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                      width: 1, color: Color.fromRGBO(254, 61, 61, 1))),
              child: Text(
                "Rebate",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: ScreenAdaper.sp(24), color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                "\$${widget.commission}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: ScreenAdaper.sp(24),
                    color: ColorsUtil.hexToColor("#FC3721")),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _swipper() {
    return AspectRatio(
        aspectRatio: 1 / 1,
        child: Swiper(
          key: ValueKey(_imageUrl.length),
          itemCount: _imageUrl.length,
          autoplay: false,
          onIndexChanged: (index) {
            setState(() {
              imgIndex = index + 1;
            });
          },
          itemBuilder: (BuildContext, int index) {
            return Image.network(
              _imageUrl[index],
              fit: BoxFit.fill,
            );
          },
//          pagination: SwiperPagination(),
        ));
  }

  Widget _Content() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(0),
//      child: Column(
            children: <Widget>[
              _getSwiperView(),
//              _swipper(),
              _details()
            ],
//      ),
          ),
        ),
        InkWell(
          onTap: () {
            if(!isSelect) {
              isSelect = true;
              _attrBottomSheet(context);
            }else{
              addCar();
            }
          },
          child: Container(
            alignment: Alignment.center,
            height: 44,
            color: Color.fromRGBO(248, 61, 0, 1),
            child: Text(
              "Add To Cart",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _details() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: ScreenAdaper.height(4),
            color: Color.fromARGB(255, 252, 249, 252),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                ScreenAdaper.width(22),
                ScreenAdaper.height(40),
                ScreenAdaper.width(82),
                ScreenAdaper.height(30)),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                commodityTitle,
                maxLines: 2,
                textAlign: TextAlign.left,
                softWrap: true,
                style: TextStyle(
                    fontSize: ScreenAdaper.sp(32),
                    color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(ScreenAdaper.width(22), 0,
                  ScreenAdaper.width(82), ScreenAdaper.height(28)),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "\$" + commodityMoney,
                  style: TextStyle(
                      fontSize: ScreenAdaper.sp(26),
                      color: Color.fromARGB(255, 255, 89, 89)),
                ),
              )),
          Container(
            height: ScreenAdaper.height(4),
            color: Color.fromARGB(255, 252, 249, 252),
          ),
          _select(),
          Container(
            height: ScreenAdaper.height(4),
            color: Color.fromARGB(255, 252, 249, 252),
          ),
          _webView(),
          _Relate(),

          ///Content
          Container(
            child: RelateList(_productList),
          ),
        ],
      ),
    );
  }

  Widget _select() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(
          ScreenAdaper.width(20), 0, ScreenAdaper.width(20), 0),
      height: ScreenAdaper.height(88),
      child: InkWell(
        onTap: (){
          _attrBottomSheet(context);
        },
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
                "select",
                style: TextStyle(
                    fontSize: ScreenAdaper.sp(26),
                    color: Color.fromARGB(255, 51, 51, 51)),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  commoditySize,
                  style: TextStyle(
                      fontSize: ScreenAdaper.sp(26),
                      color: Color.fromARGB(255, 102, 102, 102)),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Color.fromARGB(255, 161, 158, 162),
            )
          ],
        ),
      ),
    );
  }

  Widget _webView() {
    return Container(
      child: Column(
        children: <Widget>[
          _webTop(),
          Container(
            child: Html(
              data: _url_content,
              //Optional parameters:
              padding: EdgeInsets.all(8.0),
              backgroundColor: Colors.white70,
              defaultTextStyle: TextStyle(fontFamily: 'serif'),
              linkStyle: const TextStyle(
                color: Colors.redAccent,
              ),
              onLinkTap: (url) {
                // open url in a webview
              },
              onImageTap: (src) {
                // Display the image in large form.
              },
            ),
          ),
//
        ],
      ),
    );
  }

  Widget _webTop() {
    return Container(
      height: ScreenAdaper.height(104),
      child: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Text(
              "——",
              style: TextStyle(
                  fontSize: ScreenAdaper.sp(26),
                  color: Color.fromARGB(255, 229, 229, 229)),
            ),
            Text(
              " Porduct Description ",
              style: TextStyle(
                  fontSize: ScreenAdaper.sp(26),
                  color: Color.fromARGB(255, 0, 0, 0)),
            ),
            Text(
              "——",
              style: TextStyle(
                  fontSize: ScreenAdaper.sp(26),
                  color: Color.fromARGB(255, 229, 229, 229)),
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

  Widget _Relate() {
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
              "==",
              style: TextStyle(
                  fontSize: ScreenAdaper.sp(26),
                  color: Color.fromARGB(255, 229, 229, 229)),
            ),
            Text(
              " Related products ",
              style: TextStyle(
                  fontSize: ScreenAdaper.sp(26),
                  color: Color.fromARGB(255, 0, 0, 0)),
            ),
            Text(
              "==",
              style: TextStyle(
                  fontSize: ScreenAdaper.sp(26),
                  color: Color.fromARGB(255, 229, 229, 229)),
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

  void _getData() {
    //获取商品详情
    WooCommerceConfig.getInstance().getDataAsync(
        endPoint: "products/${widget.iD}",
        success: (data) {
          var details = new ProductModel.fromJson(data);
          setState(() {
            _imageUrl.clear();
            commodityTitle = details.name;
            commodityMoney = details.price;
            shareText = details.name;
            shareUrl = details.permalink;
            shareTitle =  details.name;
            _url_content = details.description;
            _type = details.type;
            List images = details.images;
            stock_status = details.stockStatus;
            regular_price = details.regularPrice??details.price;
            for (var img in images) {
              _imageUrl.add(img.src);
            }
            imgSize = _imageUrl.length;
            attributes.clear();
            List att = details.attributes;
            commoditySize = "";
            if (att != null && att.length > 0) {
              for (var a in att) {
                AttributesCheckModel model = AttributesCheckModel();
                model.id = a.id;
                model.name = a.name;
                model.position = a.position;
                List<AtttributesOption> op = [];
                for (var x in a.options) {
                  AtttributesOption o = AtttributesOption();
                  o.title = x;
                  o.isChecked = false;
                  op.add(o);
                }
                model.options = op;
                if (model.options.length > 0) {
                  model.options[0].isChecked = true;
                  commoditySize = commoditySize +" "+model.options[0].title;
                }
                attributes.add(model);
              }
            }
            _loading = false;
          });
        },
        error: (e) {
          setState(() {
            _loading = false;
          });
          print(e);
        });
  }

  Widget getBottom(state) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(18, 14, 0, 0),
            child: Container(
              child: Row(
                children: <Widget>[
                  Container(
                    height: 93,
                    width: 93,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Container(
                        child: Image.network(
                            _imageUrl != null && _imageUrl.length > 0
                                ? _imageUrl[0]
                                : "",
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Container(
                    height: 93,
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  "\$" + commodityMoney == null
                                      ? "0.00"
                                      : commodityMoney,
                                  style: TextStyle(
                                      fontSize: ScreenAdaper.sp(26),
                                      color: Color.fromARGB(255, 255, 89, 89)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              ),
                              Container(
                                child: Text(
                                  "$stock_status",
                                  style: TextStyle(
                                      fontSize: ScreenAdaper.sp(20),
                                      color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "\$" + regular_price == null
                                    ? "0.00"
                                    : regular_price,
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor:
                                        Color.fromRGBO(153, 153, 153, 1),
                                    decorationStyle: TextDecorationStyle.solid,
                                    fontSize: ScreenAdaper.sp(20),
                                    color: Color.fromRGBO(153, 153, 153, 1)),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              ),
                              Container(
                                child: Text(
                                  "$stock_status",
                                  style: TextStyle(
                                      fontSize: ScreenAdaper.sp(20),
                                      color: Color.fromRGBO(153, 153, 153, 1)),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          getAttributes(state),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Text(
                      "Quantiy",
                      style: TextStyle(
                          fontSize: 12, color: Color.fromRGBO(51, 51, 51, 1)),
                    ),
                  ),
                ),
                _getAdd(state)
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          InkWell(
            onTap: () {
              setSelect();
              Navigator.of(context).pop(1);
//              _attrBottomSheet();
              if(isSelect) {
                addCar();
              }else{
                isSelect = true;
              }
            },
            child: Container(
              alignment: Alignment.center,
              height: 44,
              color: Color.fromRGBO(248, 61, 0, 1),
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getAttributes(state) {
    return ListView.builder(
      physics: new NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: attributes.length,
      itemBuilder: (BuildContext context, int index) {
        return _getAttributesItem(index, state);
      },
    );
  }

  Widget _getAttributesItem(int index, state) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: <Widget>[
          Container(
            height: 48,
            alignment: Alignment.centerLeft,
            child: Text(
              attributes[index].name,
              style:
                  TextStyle(color: Color.fromRGBO(51, 51, 51, 1), fontSize: 12),
            ),
          ),
          Container(
              child: GridView.builder(
            physics: new NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.all(0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 160 / 60,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemCount: attributes[index].options.length,
            itemBuilder: (context, index1) {
              return GestureDetector(
                  onTap: () {
                    state(() {
                      for (var x in attributes[index].options) {
                        x.isChecked = false;
                      }
                      attributes[index].options[index1].isChecked = true;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        border: new Border.all(
                            width: 1,
                            color: attributes[index].options[index1].isChecked
                                ? Color.fromRGBO(252, 55, 33, 1)
                                : Colors.white),
                        color: attributes[index].options[index1].isChecked
                            ? Colors.white
                            : Color.fromRGBO(244, 244, 244, 1)),
                    child: Text(
                      attributes[index].options[index1].title,
                      style: TextStyle(
                          fontSize: 12,
                          color: attributes[index].options[index1].isChecked
                              ? Color.fromRGBO(252, 55, 33, 1)
                              : Color.fromRGBO(51, 51, 51, 1)),
                    ),
                  ));
            },
          )),
        ],
      ),
    );
  }

  _attrBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context1, state) {
            return Stack(children: <Widget>[getBottom(state)]);
          });
        });
  }

  Widget _getAdd(state) {
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
                state(() {
                  if (_Number > 1) {
                    _Number--;
                  } else {
                    _Number = 1;
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
                "$_Number",
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
                state(() {
                  _Number++;
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

  void addCar() async {
    String token = await SharePreferencesUtil.getToken().then((data) {
      return data;
    });
    var vid = widget.iD;
    if(_type == "variable"){
      for(var v in _variationslist){
        var attr = v.attributes;
        if(attr!=null){
          for(var a in attr){
            for(var s in this.attr) {
              if(a.option.contains(s)){
                vid = v.id;
              }
            }
          }
        }
      }
    }
    var options_key = "";
    for(var s in this.attr){
      options_key = options_key + s+",";
    }
    if (options_key != "") {
      options_key = options_key.substring(0, options_key.length - 1);
    }
//    FormData params = FormData.from({
//     ,
//      "number": ,
//      "variation_id": vid,
//      "options_key": options_key,
//      "token": token
//    });
    FormData params = FormData();
    params.add("product_id", widget.iD);
    params.add("number", _Number);
    params.add("token", token);
    if(_type == "variable") {
      params.add("variation_id", vid);
      params.add("options_key", options_key);
    }
    setState(() {
      _loading = true;
    });
    DioManager.getInstance().post(Config.ADD_TO_CAR_URL, params, (data) {
      setState(() {
        _loading = false;
      });
      try {
        var model = AddCarModel.fromJson(data);
        if (model.code == 200) {
          eventBus.fire(CarEvent(_Number));
          ToastUtils.showToast("add to car success!");
          Navigator.of(context).popUntil(ModalRoute.withName('/main'));
          eventBus.fire(MainSelectEvent(2));
        }
      } catch (e) {
        var error = ErrorModel.fromJson(data);
        ToastUtils.showToast(error.message);
      }
    }, (error) {
      setState(() {
        _loading = false;
      });
      ToastUtils.showToast(error.toString());
    });
  }

  _pop() {
    Navigator.pop(context);
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

  _getVariations(){
    //获取商品详情
    WooCommerceConfig.getInstance().getDataAsync(
        endPoint: "products/${widget.iD}/variations",
        success: (data) {
          List list = data["data"];
          for (var item in list) {
            var model = new VariationsModel.fromJson(item);
            _variationslist.add(model);
          }
          print(data.toString());
        },
        error: (e) {
          print(e);
        });
  }



  void showAlert(SSDKResponseState state, Map content, BuildContext context) {
    print("--------------------------> state:" + state.toString());
    String title = "失败";
    switch (state) {
      case SSDKResponseState.Success:
        title = "成功";
        break;
      case SSDKResponseState.Fail:
        title = "失败";
        break;
      case SSDKResponseState.Cancel:
        title = "取消";
        break;
      default:
        title = state.toString();
        break;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
            title: new Text(title),
            content: new Text(content != null ? content.toString() : ""),
            actions: <Widget>[
              new FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ]));
  }

  void showAlertText(String title, String content, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
            title: new Text(title),
            content: new Text(content != null ? content : ""),
            actions: <Widget>[
              new FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ]));
  }


  void showShareMenu(BuildContext context) {
//    SSDKMap params = SSDKMap()
//      ..setTwitter(
//        "这里是文本文档",
//        null,
//        null,
//        null,
//        null,
//        SSDKContentTypes.text,
//      );
//    SharesdkPlugin.share(
//        ShareSDKPlatforms.twitter, params, (SSDKResponseState state, Map userdata,
//        Map contentEntity, SSDKError error) {
//      showAlert(state, error.rawData, context);
//    });
    SSDKMap params = SSDKMap()
      ..setGeneral(
          shareTitle,
          shareText,
          null,
          null,
          null,
          shareUrl+"?temp=${DateTime.now().millisecondsSinceEpoch}",
          null,
          null,
          null,
          null,
          SSDKContentTypes.webpage);
    SharesdkPlugin.showMenu(null, params, (SSDKResponseState state,
        ShareSDKPlatform platform,
        Map userData,
        Map contentEntity,
        SSDKError error) {
      showAlert(state, error.rawData, context);
    });
  }

  void setSelect() {
    attr.clear();
    commoditySize = "";
    for (var s in attributes) {
      AttributesCheckModel model = s;
      for (var op in model.options) {
        if (op.isChecked) {
          attr.add(op.title);
          commoditySize = commoditySize +" "+op.title;
        }
      }
    }
    setState(() {

    });
  }
}
