import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:olamall_app/model/ProductModel.dart';
import 'package:olamall_app/ui/widgets/relate_list.dart';
import 'package:olamall_app/ui/widgets/search_appbar_widget.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/ToastUtils.dart';
import 'package:olamall_app/utils/UiUtils.dart';
import 'package:olamall_app/net/api/woocommerce_config.dart';
class SearchGoodsListView extends StatefulWidget{


  @override
  State<StatefulWidget> createState() =>SearchGoodsListViewState();

}

class SearchGoodsListViewState extends State<SearchGoodsListView>{
  EasyRefreshController _controller = EasyRefreshController();
  TextEditingController _textEditingController = new TextEditingController();
  int _page = 1;
  int _pageSize = 10;
  List<ProductModel> _productList = List();
  String _search = "";
  @override
  void initState() {
    // TODO: implement initState
    _textEditingController.addListener((){
      _search = _textEditingController.text;
      if(_search!=null&&_search.length>0) {
        _getList();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: SearchAppBarWidget(
        controller: _textEditingController,
          elevation: 2.0,
          hintText: "what are you looking for?",
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios,color:  ColorsUtil.hexToColor("#999999"),),
              onPressed: () {
                Navigator.pop(context);
              }),
          inputFormatters: [
            LengthLimitingTextInputFormatter(50),
          ],
          ),
      body: Container(
        child: ListView(
          children: <Widget>[
            RelateList(_productList)
          ],
        )),
    );
  }

  void _getList() {
    WooCommerceConfig.getInstance().getDataAsync(
        endPoint:
        "products?page=$_page&per_page=$_pageSize&search=$_search",
        success: (data) {
          _productList.clear();
          List list = data["data"];
          for (var l in list) {
            var p = ProductModel.fromJson(l);
            _productList.add(p);
          }
          setState(() {});
        },
        error: (e) {
//          ToastUtils.showToast("Server exception");
        });
  }

}