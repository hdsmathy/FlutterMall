import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:olamall_app/config/Config.dart';
import 'package:olamall_app/model/DistributionOfflineModel.dart';
import 'package:olamall_app/net/NetWork.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/DateUtils.dart';
import 'package:olamall_app/utils/LogUtil.dart';
import 'package:olamall_app/utils/SharePreferencesUtil.dart';
import 'package:olamall_app/utils/UiUtils.dart';

class DistributionOfflineListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DistributionOfflineListView();
}

class _DistributionOfflineListView extends State<DistributionOfflineListView> {
  EasyRefreshController _controller = EasyRefreshController();
  String _directSize = "0";
  String _level2Size = "0";
  String _level3Size = "0";
  var list = [];
  int _page = 1;
  int _pageSize = 10;
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getList();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // TODO: implement build
    return Container(
      child: Scaffold(
        appBar: UiUtils.getAppBarStyle("Downline pepole list",context: context),
        backgroundColor: ColorsUtil.hexToColor("#F4F4F4"),
        body: Container(
          child: EasyRefresh(
            controller: _controller,
            // ignore: missing_return
            onRefresh: () {
              _page = 1;
              _getList();
            },
            // ignore: missing_return
            onLoad: () {
              _page++;
              _getList();
            },
            child: ListView(
              children: <Widget>[
                _getTop(),
                _listContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getTop() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: _getTopItem("Direct downline", "$_directSize people"),
          ),
          Expanded(
            flex: 1,
            child: _getTopItem("Level 2 downline", "$_level2Size people"),
          ),
          Expanded(
            flex: 1,
            child: _getTopItem("Level3 downline", "$_level3Size people"),
          ),
        ],
      ),
    );
  }

  _getTopItem(String title, String size) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: ScreenAdaper.sp(24),
                  color: ColorsUtil.hexToColor("#333333")),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          Container(
            child: Text(
              size,
              style: TextStyle(
                  fontSize: ScreenAdaper.sp(20),
                  color: ColorsUtil.hexToColor("#999999")),
            ),
          )
        ],
      ),
    );
  }

  _listContent() {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: ListView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          physics: new NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return _getListItem(context, index);
          },
        ));
  }

  _getListItem(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 1),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: ClipOval(
              child: new Image.asset(
                "images/ic_defult_head.png",
                width: ScreenAdaper.width(66),
                height: ScreenAdaper.height(66),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${list[index].userName}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: ScreenAdaper.sp(24),
                        color: ColorsUtil.hexToColor("#333333")),
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.5),
                  ),
                  Text(
                    "Registration date ${DateUtils.instance.getFormartData(timeSamp: list[index].registerTime*1000,format: "yyyy-MM-dd")}",
                    style: TextStyle(
                        fontSize: ScreenAdaper.sp(20),
                        color: ColorsUtil.hexToColor("#999999")),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _getList() async {
    var distributionUid = await SharePreferencesUtil.getLoginMsg().then((data) {
      return data["distributionUid"];
    });
    var params = new FormData();
    params.add("user_id", distributionUid);
    params.add("page", _page);
    params.add("page_size", _pageSize);
    NetWork.getInstance().post(Config.MY_CHILDREN_USER_URL, params, (data) {
      _controller.finishRefresh(success: true);
      var model = DistributionOfflineModel.fromJson(data);
      if(model.code==200) {
        _directSize = "${model.data.firstCount}";
        _level2Size = "${model.data.secondCount}";
        _level3Size = "${model.data.thrCount}";
        if (_page == 1) {
          list.clear();
          list.addAll(model.data.dataList);
        } else {
          if(model.data.dataList.length>0) {
            list.addAll(model.data.dataList);
          }
        }
        if(_pageSize>model.data.dataList.length){
          _controller.finishLoad(success: true, noMore: true);
        }else{
          _controller.finishLoad(success: true, noMore: false);
        }
        setState(() {
        });
      }
    }, (e) {
      _controller.finishRefresh(success: true);
      _controller.finishLoad(success: true, noMore: false);
      LogUtil.logE("MineView", e.toString());
    });
  }
}
