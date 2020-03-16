import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:olamall_app/config/Config.dart';
import 'package:olamall_app/model/DistributionRecordModel.dart';
import 'package:olamall_app/net/NetWork.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/DateUtils.dart';
import 'package:olamall_app/utils/SharePreferencesUtil.dart';
import 'package:olamall_app/utils/UiUtils.dart';

class DistributionCommissionView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DistributionCommissionView();
}

class _DistributionCommissionView
    extends State<DistributionCommissionView> {
  EasyRefreshController _controller = EasyRefreshController();
  int _page = 1;
  int _pageSize = 10;
  List<DataList> list = [];
  int _settledTotal = 0;
  int _unsettledTotal = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiUtils.getAppBarStyle("Distribution commission details", context: context),
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
            child:ListView(
              children: <Widget>[
//                _getTop(),
                _listContent(),
              ],
            )),
      ),
    );
  }

  Widget _getListItem(BuildContext context, int index) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child:  Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _itemText3("Distribution cashback :" +"${list[index].userName}"),
                  _itemText9("(${_getLevel(list[index].type)})"),
                  _itemText6("Amount of consumption : ${list[index].orderPayMoney}"),
                  _itemText6("Status : ${_getStatus(list[index].settlementStatus)}"),
                  _itemText9("${DateUtils.instance.getFormartData(timeSamp:list[index].orderSettlementTime * 1000,format: "yyyy-MM-dd hh:mm:ss")}"),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              "+ ${list[index].recordMoney}",
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: ScreenAdaper.sp(36),
                  color: ColorsUtil.hexToColor("#4ACA6D")),
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
    NetWork.getInstance().post(Config.DISTRIBUTION_RECORD_MONEY_LIST_URL, params, (data) {
      _controller.finishRefresh(success: true);
      var model = DistributionRecordModel.fromJson(data);
      if(model.code==200) {
//        _settledTotal = model.data.
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
    });
  }

  _getTop() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: _getTopItem("Settled total commission", "$_settledTotal"),
          ),
          Expanded(
            flex: 1,
            child: _getTopItem("Unsettled total commission", "$_unsettledTotal"),
          )
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

  _itemText3(String s1){
   return Text(
      "$s1",
      textAlign: TextAlign.left,
      style: TextStyle(
          fontSize: ScreenAdaper.sp(24),
          color: ColorsUtil.hexToColor("#333333")),
    );
  }
  _itemText6(String s1){
    return Text(
      "$s1",
      textAlign: TextAlign.left,
      style: TextStyle(
          fontSize: ScreenAdaper.sp(20),
          color: ColorsUtil.hexToColor("#666666")),
    );
  }
  
  _itemText9(String s1){
    return Text(
      "$s1",
      textAlign: TextAlign.left,
      style: TextStyle(
          fontSize: ScreenAdaper.sp(20),
          color: ColorsUtil.hexToColor("#999999")),
    );
  }

  _getStatus(int type){
    if(type == 1) {
      return "Unsettled";
    }else{
      return "Settled";
    }

  }

  _getLevel(int type) {
    var str = "Level 1 distribution";
    switch(type){
      case 1: str = "Self purchase";break;
      case 2: str = "Level 1 distribution";break;
      case 3: str = "Level 2 distribution";break;
      case 4: str = "Level 3 distribution";break;
    }
    return str;
  }
}
