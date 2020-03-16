import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:olamall_app/config/Config.dart';
import 'package:olamall_app/model/DistributionRelateModel.dart';
import 'package:olamall_app/net/DioManager.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/widgets/distribution_relate_list.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/UiUtils.dart';

class DistributionGoodsListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DistributionGoodsListViewState();
}

class _DistributionGoodsListViewState extends State<DistributionGoodsListView> {
  EasyRefreshController _controller = EasyRefreshController();
  List<ProductList> list = [];

  int _page = 1;
  int _pageSize = 10;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: UiUtils.getAppBarStyle("Distribution", context: context),
      backgroundColor: ColorsUtil.hexToColor("#F4F4F4"),
      body: Container(
        margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
        child: EasyRefresh(
          controller: _controller,
          // ignore: missing_return
          onRefresh: () {
            _page = 1;
            _getData();
          },
          // ignore: missing_return
          onLoad: () {
            _page++;
            _getData();
          },
          child: ListView(
            children: <Widget>[DistributionRelateList(list)],
          ),
        ),
      ),
    );
  }

  _getData() {
    FormData params = FormData();
    params.add("page", _page);
    params.add("page_size", _pageSize);
    DioManager.getInstance().post(Config.DISTRIBUTION_GOODS_LIST_URL, params,
        (data) {
      _controller.finishRefresh(success: true);
      var model = DistributionRelateModel.fromJson(data);
      if (model.code == 200) {
        if (_page == 1) {
          list.clear();
          list.addAll(model.data.productList);
        } else {
          if (model.data.productList.length > 0) {
            list.addAll(model.data.productList);
          } else {
            _page--;
          }
        }
        if (_pageSize > model.data.productList.length) {
          _controller.finishLoad(success: true, noMore: true);
        } else {
          _controller.finishLoad(success: true, noMore: false);
        }
        setState(() {});
      }
    }, (error) {});
  }
}
