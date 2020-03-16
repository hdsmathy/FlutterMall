import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:olamall_app/config/Config.dart';
import 'package:olamall_app/constant/images.dart';
import 'package:olamall_app/constant/string.dart';
import 'package:olamall_app/model/BannerAdsModel.dart' as HomeBanner;
import 'package:olamall_app/model/NewProductModel.dart';
import 'package:olamall_app/model/OrderListModel.dart';
import 'package:olamall_app/model/ProductModel.dart';
import 'package:olamall_app/model/ShippingMethodModel.dart';
import 'package:olamall_app/model/ShippingZonesModel.dart';
import 'package:olamall_app/net/DioManager.dart';
import 'package:olamall_app/net/api/woocommerce_config.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/commodity/CommodityDetailsPage.dart';
import 'package:olamall_app/ui/goods/search_goods_list_view.dart';
import 'package:olamall_app/ui/mall.dart';
import 'package:olamall_app/ui/widgets/progress_dialog.dart';
import 'package:olamall_app/ui/widgets/relate_list.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/LogUtil.dart';
import 'package:olamall_app/utils/SharePreferencesUtil.dart';
import 'package:olamall_app/utils/ToastUtils.dart';
import 'dart:ui';
const APPBAE_SCROLL_OFFSET = 100;

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {
  String _adsUrlTop;
  String _adsUrlBottom;
  List<HomeBanner.Banner> _imageUrl = new List();
  double alphaAppBar = 1;
  List<HomeBanner.ThemefarmerHomeProductTabs> _hotProductTabs = new List();
  List<CategoryList> _newProductTabs = new List();
  List<ProductList> _newProductList = new List();
  List<ProductList> _hotProductList = new List();
  var _newProductType;
  var _order = "desc";
  var _orderby = "slug";
  var _stock_status = "instock";
  bool _loading = true;

  ///as you also like数据
  List<ProductModel> _productList = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getData();
  }

  Future<void> _getData() async {
    _newProductTabs.clear();
    _newProductList.clear();
    _hotProductList.clear();
    _imageUrl.clear();
    _hotProductTabs.clear();

    ///获取new Product 和 tabs
    await _getNewProductAndAds();

    ///获取banner和广告 HotProductTabs
    await _getBannerAndHotProductTabs();

    ///获取HotProduct
    await _getHotProduct();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressDialog(
        loading: _loading, child: Scaffold(
        backgroundColor: ColorsUtil.hexToColor("#F4F4F4"),
        body: Stack(
          children: <Widget>[
            MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: NotificationListener(
                    onNotification: (ScrollNotification scrollNotification) {
                      ScrollMetrics metrics = scrollNotification.metrics;
                      if (scrollNotification is ScrollUpdateNotification) {
                        if(metrics.axis == Axis.vertical) {
                          _onScroll(scrollNotification.metrics.pixels);
                        }
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          ///banner 和 其下面的快捷按钮
                          _bannerAndQuickBtn(),

                          ///广告图片
                          _imageAdvertising(_adsUrlTop),

                          ///New Products title
                          _productsTitle(1, HomeImages.homeBg1, "New\nProducts",
                              newProductTabs: _newProductTabs),

                          ///New Products
                          _productsContent(1, newProductList: _newProductList),

                          ///广告图片
                          _imageAdvertising(_adsUrlBottom),

                          ///Hot Product Title
                          _productsTitle(2, HomeImages.homeBg2, "Hot\nProducts",
                              hotProductTabs: _hotProductTabs),

                          ///Hot Products
                          _productsContent(2, newProductList: _hotProductList),

                          ///== You May Also Like ==
                          Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: new Text("== You May Also Like ==",
                                style: TextStyle(
                                  color: ColorsUtil.hexToColor("#333333"),
                                  fontSize: 13,
                                )),
                          ),

                          ///Content
                          Container(
                            child: RelateList(_productList),
                          ),
                        ],
                      ),
                    ))),
            Stack(
              children: <Widget>[
                Opacity(
                  opacity: alphaAppBar,
                  child: Container(
                    height: 80,
                    padding: EdgeInsets.only(top: MediaQueryData.fromWindow(window).padding.top),
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  height: 38,
                  margin: EdgeInsets.fromLTRB(10, 5 + MediaQueryData.fromWindow(window).padding.top, 10, 5),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SearchGoodsListView()),);
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.search,color: ColorsUtil.hexToColor("#999999"),),
                        Text(
                          "what are you looking for?",
                          style: TextStyle(
                              color: ColorsUtil.hexToColor("#999999"), fontSize: ScreenAdaper.sp(24)),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    //设置四周圆角 角度
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: ColorsUtil.hexToColor("#F4F4F4")),
                )
              ],
            )
          ],
        )));
  }

  /// Products title
  Widget _productsTitle(int type, String bgUrl, String titleName,
      {List<CategoryList> newProductTabs,
      List<HomeBanner.ThemefarmerHomeProductTabs> hotProductTabs}) {
    int len;
    if (type == 1) {
      len = newProductTabs.length;
    } else {
      len = hotProductTabs.length;
    }

    return Container(
        height: ScreenAdaper.height(90),
        width: MallApp.screenWidth,
        margin: EdgeInsets.fromLTRB(ScreenAdaper.width(20),
            ScreenAdaper.height(19), ScreenAdaper.width(20), 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ScreenAdaper.width(20)),
                topRight: Radius.circular(ScreenAdaper.width(20))),
            color: Colors.white),
        child: Row(
          children: <Widget>[
            ///图片 newProduct
            _imageTitle(bgUrl, titleName),

            ///可选择项
            Expanded(
                child: Container(
              height: ScreenAdaper.height(60),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: len,
                  itemBuilder: (context, index) {
                    var item;
                    if (type == 1) {
                      ///new product
                      item = _productTextTitle(newProductTabs[index].name, 18,
                          newProductTabs[index].color, () {
                        for (var i = 0; i < newProductTabs.length; ++i) {
                          var newProductTab = newProductTabs[i];
                          if (i == index)
                            newProductTab.color = Colors.red;
                          else
                            newProductTab.color = Colors.white;
                        }
                        _newProductType =
                            newProductTabs[index].termId.toString();
                        setState(() {});
                      });
                    } else {
                      /// hot products
                      item = _productTextTitle(hotProductTabs[index].name, 18,
                          hotProductTabs[index].color, () {
                        _order = hotProductTabs[index].order;
                        _orderby = hotProductTabs[index].orderby;
                        for (var i = 0; i < hotProductTabs.length; ++i) {
                          var hotProductTab = hotProductTabs[i];
                          if (i == index)
                            hotProductTab.color = Colors.red;
                          else
                            hotProductTab.color = Colors.white;
                        }
                        _getHotProduct();
                        setState(() {});
                      });
                    }
                    return item;
                  }),
            ))
          ],
        ));
  }

  ///Products Content
  Widget _productsContent(int type, {List<ProductList> newProductList}) {
    List<ProductList> showDatas = new List();
    int len;
    if (type == 1) {
      ///new product
      for (var newProduct in newProductList) {
        for (var category in newProduct.category) {
          if (_newProductType == category.toString()) {
            showDatas.add(newProduct);
          }
        }
      }
      len = showDatas.length;
    } else {
      if (newProductList.length > 15) {
        for (var i = 0; i < 15; i++) {
          showDatas.add(newProductList[i]);
        }
      } else {
        showDatas.addAll(newProductList);
      }
      len = showDatas.length;
    }

    return Container(
      height: ScreenAdaper.height(352),
      width: MallApp.screenWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(ScreenAdaper.width(20)),
              bottomRight: Radius.circular(ScreenAdaper.width(20))),
          color: Colors.white),
      margin: EdgeInsets.fromLTRB(
          ScreenAdaper.width(20), 0, ScreenAdaper.width(20), 0),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: len ?? 4,
          itemBuilder: (context, index) {
            if (type == 1)
              return _productItem(type, newProduct: showDatas[index]);
            else
              return _productItem(type, newProduct: showDatas[index]);
          }),
    );
  }

  ///广告图片
  Widget _imageAdvertising(String imageUrl) {
    return Container(
      height: ScreenAdaper.height(168),
      alignment: Alignment.center,
      width: MallApp.screenWidth,
      margin: EdgeInsets.fromLTRB(ScreenAdaper.width(20),
          ScreenAdaper.height(20), ScreenAdaper.width(20), 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(ScreenAdaper.width(20))),
        color: Colors.white,
      ),
      child: ConstrainedBox(
        child: Image.network(
          imageUrl ?? "null",
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        constraints: new BoxConstraints.expand(),
      ),
    );
  }

  ///banner 下面的快捷按钮
  Widget _quickButton(String name, String imageUrl) {
    return Expanded(
        child: InkWell(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: ScreenAdaper.height(40)),
            child: Image.asset(imageUrl),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenAdaper.height(49)),
            child: Text(
              name,
              style:
                  TextStyle(color: Colors.black, fontSize: ScreenAdaper.sp(20)),
            ),
          )
        ],
      ),
    ));
  }

  /// Product 文本title
  Widget _productTextTitle(String titleName, double leftMargin,
      Color borderColor, Function onClick) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: leftMargin),
        padding: EdgeInsets.fromLTRB(
            ScreenAdaper.width(17),
            ScreenAdaper.height(13),
            ScreenAdaper.width(14),
            ScreenAdaper.height(10)),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenAdaper.width(30))),
            border: Border.all(color: borderColor ?? Colors.white, width: 1)),
        child: Text(
          titleName.replaceAll("_", " ").toString(),
          style: TextStyle(color: Colors.black, fontSize: ScreenAdaper.sp(24)),
        ),
      ),
      onTap: onClick,
    );
  }

  /// Product image title
  Widget _imageTitle(String bgUrl, String titleName) {
    return Container(
      height: ScreenAdaper.height(90),
      padding: EdgeInsets.fromLTRB(
          ScreenAdaper.width(28),
          ScreenAdaper.height(16),
          ScreenAdaper.width(34),
          ScreenAdaper.height(16)),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(bgUrl), fit: BoxFit.cover),
      ),
      child: Text(
        titleName.toUpperCase(),
        style: TextStyle(color: Colors.white, fontSize: ScreenAdaper.sp(24)),
      ),
    );
  }

  ///banner 和 其下面的快捷按钮
  Widget _bannerAndQuickBtn() {
    return Container(
      height: ScreenAdaper.height(569),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          Container(
            height: ScreenAdaper.height(569),
          ),
          Positioned(
            top: ScreenAdaper.height(0),
            left: ScreenAdaper.width(0),
            right: ScreenAdaper.width(0),
            bottom: ScreenAdaper.height(137),
            child: Container(
              height: ScreenAdaper.height(432),
              child: Swiper(
                autoplayDelay: 8000,
                itemCount: _imageUrl.length,
                autoplay: true,
                itemBuilder: (BuildContext, int index) {
                  return Image.network(
                    _imageUrl[index].image,
                    fit: BoxFit.fill,
                  );
                },
                pagination: SwiperPagination(),
              ),
            ),
          ),
          Positioned(
              top: ScreenAdaper.height(300),
              left: ScreenAdaper.width(20),
              right: ScreenAdaper.width(20),
              bottom: 0.0,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenAdaper.width(20)))),
                height: ScreenAdaper.height(217),
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    _quickButton(Strings.HOME_SHOES, HomeImages.shoes),
                    _quickButton(
                        Strings.HOME_KIDS_FASHION, HomeImages.kidsFashion),
                    _quickButton(Strings.HOME_CD_DVD, HomeImages.cdDvd),
                    _quickButton(Strings.HOME_LIVING, HomeImages.homeLiving),
                    _quickButton(Strings.HOME_HEALTH, HomeImages.heath),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  ///单个商品  Product
  Widget _productItem(int type, {ProductList newProduct}) {
    var _imageUrl;
    var _title;
    var _price;

    var _id = newProduct.productId;
    if (type == 1) {
      _imageUrl = newProduct.image.toString();
      _title = newProduct.title.toString();
      _price = newProduct.price.toString();
    } else {
      _imageUrl = newProduct.image.toString();
      _title = newProduct.title.toString();
      _price = newProduct.price.toString();
    }
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CommodityDetailsPage(
                      iD: _id,
                    )),
          );
        },
        child: Container(
          width: ScreenAdaper.width(236),
          height: ScreenAdaper.height(300),
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(0, ScreenAdaper.height(35), 0, 0),
          // padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                height: ScreenAdaper.height(153),
                width: ScreenAdaper.width(153),
                child: Image.network(
                    _imageUrl ??
                        "http://pic1.win4000.com/pic/5/46/bf09318286.jpg",
                    fit: BoxFit.cover),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(ScreenAdaper.width(25),
                      ScreenAdaper.width(19), ScreenAdaper.width(28), 0),
                  alignment: Alignment.topLeft,
                  child: Text(_title ?? "no title",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      // 显示不完，就在后面显示点点
                      style: TextStyle(
                        fontSize: ScreenAdaper.sp(24), // 文字大小
                        color: Color.fromRGBO(51, 51, 51, 1), // 文字颜色
                      ))),
              Container(
                margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
                padding: EdgeInsets.fromLTRB(ScreenAdaper.width(25), 0,
                    ScreenAdaper.width(28), ScreenAdaper.width(19)),
                alignment: Alignment.topLeft,
                child: Text(
                  "\$ ${_price ?? "no price"}",
                  style: TextStyle(
                    fontSize: ScreenAdaper.sp(24), // 文字大小
                    color: Color.fromRGBO(255, 89, 89, 1), // 文字颜色
                  ),
                ),
              )
            ],
          ),
        ));
  }

  /**
   * 计算滑动
   */
  _onScroll(offset) {
    double alpha = offset / APPBAE_SCROLL_OFFSET;
    print(alpha);
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      alphaAppBar = alpha;
    });

  }

  Future<bool> _getBannerAndHotProductTabs() async {
    DioManager.getInstance().post(Config.MAIN_BANNER_ADS, FormData(), (data) {
      HomeBanner.BannerAdsModel bannerAdsModel =
          HomeBanner.BannerAdsModel.fromJson(data);
      if (bannerAdsModel.code == 200) {
        var data = bannerAdsModel.data;

        _imageUrl.addAll(data.banner);
        for (var i = 0;
            i < bannerAdsModel.data.themefarmerHomeProductTabs.length;
            ++i) {
          var tab = bannerAdsModel.data.themefarmerHomeProductTabs[i];
          if (i == 0) tab.color = Colors.red;
          _hotProductTabs.add(tab);
        }

        _adsUrlTop = data.themefarmerHomeBanners[0].image;
        _adsUrlBottom = data.themefarmerHomeBanners[1].image;
        LogUtil.logI("HomeView", "adsUrlBottom = " + _adsUrlBottom);

        setState(() {});
      } else {
        ToastUtils.showToast("获取广告失败");
      }
    }, (e) {
      LogUtil.logE("HomeView", e.toString());
    });
    return true;
  }

  Future<bool> _getNewProductAndAds() async {
    ///获取new Product 和 tabs
    DioManager.getInstance().get(Config.MAIN_NEW_PRODUCT_TITLE, FormData(),
        (data) {
      var newProductModel = NewProductModel.fromJson(data);
      if (newProductModel.code == 200) {
        var data = newProductModel.data;
        for (var i = 0; i < data.categoryList.length; ++i) {
          var tab = data.categoryList[i];
          if (i == 0) {
            tab.color = Colors.red;
            _newProductType = tab.termId;
          }
          _newProductTabs.add(tab);
        }
        _newProductList.addAll(data.productList);
        LogUtil.logI("HomeView", "newProduct = " + data.toString());
        setState(() {});
      } else {
        ToastUtils.showToast("获取新产品列表失败");
      }
    }, (e) {
      ToastUtils.showToast("Server exception");

      LogUtil.logE("HomeView", e.toString());
    });
    return true;
  }

  ///web上，hot products是主题设置的，有Best Selling Products\Sale Products
  ///\Featured Products\Recent Products\Top Rated Products这几个标签，
  ///分别是销量倒序、折扣倒序、特色商品、最新商品、评分最高。接口有这些排序吗？
  ///如果没有，就按销量倒序吧，那些标签就改成显示的15个商品所属分类
  Future<bool> _getHotProduct() async {
    WooCommerceConfig.getInstance().getDataAsync(
        endPoint:
            "products?order=$_order&orderby=$_orderby&stock_status=$_stock_status",
        success: (data) {
          List list = data["data"];
          for (var l in list) {
            var p = ProductModel.fromJson(l);
            var pl = ProductList();
            pl.price = p.price;
            pl.title = p.name;
            pl.productId = p.id;
            pl.image =
                p.images != null && p.images.length > 0 ? p.images[0].src : "";
            pl.stockStatus = p.stockStatus;
            pl.stockQuantity = int.parse(
                p.stockQuantity == null || p.stockQuantity == "null"
                    ? "0"
                    : p.stockQuantity);
            List<int> list = [];
            for (var a in p.categories) {
              list.add(a.id);
            }
            pl.category = list;
            _hotProductList.add(pl);
            _productList.add(p);
          }

          print(_hotProductList.toString());
          setState(() {
            _loading = false;
          });
        },
        error: (e) {
          setState(() {
            _loading = false;
          });
          ToastUtils.showToast("Server exception");
          LogUtil.logE("HomeView", e.toString());
        });
    return true;
  }
}
