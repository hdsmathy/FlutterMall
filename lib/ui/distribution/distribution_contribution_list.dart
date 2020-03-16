import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:olamall_app/config/Config.dart';
import 'package:olamall_app/model/DistributionContributionListModel.dart';
import 'package:olamall_app/net/NetWork.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/DateUtils.dart';
import 'package:olamall_app/utils/LogUtil.dart';
import 'package:olamall_app/utils/SharePreferencesUtil.dart';
import 'package:olamall_app/utils/UiUtils.dart';

class DistributionContributionListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DistributionContributionListView();
}

class _DistributionContributionListView
    extends State<DistributionContributionListView> {
  EasyRefreshController _controller = EasyRefreshController();
  int _page = 1;
  int _pageSize = 10;
  List<DataList> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiUtils.getAppBarStyle("Contribution details", context: context),
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
            child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: ListView.builder(
                  itemCount: list.length,
                  shrinkWrap: true,
                  physics: new NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return _getListItem(context, index);
                  },
                ))),
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
                 Text(
                   "${_getType(list[index].type)} people : ${list[index].sourceUserName}",
                   textAlign: TextAlign.left,
                   style: TextStyle(
                       fontSize: ScreenAdaper.sp(24),
                       color: ColorsUtil.hexToColor("#333333")),
                 ),
                 Padding(
                   padding: EdgeInsets.all(3),
                 ),
                 Text(
                   "${DateUtils.instance.getFormartData(timeSamp: list[index].addTime * 1000)}",
                   style: TextStyle(
                       fontSize: ScreenAdaper.sp(20),
                       color: ColorsUtil.hexToColor("#999999")),
                 ),
               ],
             ),
           ),
         ),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              "+ ${list[index].values}",
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
    NetWork.getInstance().post(Config.DISTRIBUTION_GOODS_CONTRIBUTION_LISTR_URL, params, (data) {
      _controller.finishRefresh(success: true);
      var model = DistributionContributionListModel.fromJson(data);
      if(model.code==200) {
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

  _getType(int type) {
    String type1 ="";
    switch(type){
      case 1 :type1 = "Direct downline";break;
      case 2:type1 = "Level 2 downline";break;
      case 3:type1 = "Level 3 downline";break;
    }
    return type1;
  }
}
