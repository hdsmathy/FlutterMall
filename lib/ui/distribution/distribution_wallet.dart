import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:olamall_app/config/Config.dart';
import 'package:olamall_app/constant/images.dart';
import 'package:olamall_app/model/DistributionMemberModel.dart';
import 'package:olamall_app/net/NetWork.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/distribution/distribution_goods_list.dart';
import 'package:olamall_app/ui/mall.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/LogUtil.dart';
import 'package:olamall_app/utils/SharePreferencesUtil.dart';
import 'package:olamall_app/utils/ToastUtils.dart';

import 'distribution_bank_card.dart';
import 'distribution_offline_list.dart';
import 'distribution_withdrawal.dart';

class DistributionWalletView extends StatefulWidget {
  ///分销员信息
  DistributionMemberModel _distributionMemberModel;

  DistributionWalletView(this._distributionMemberModel);

  @override
  State<StatefulWidget> createState() =>
      _DistributionWalletView(_distributionMemberModel);
}

class _DistributionWalletView extends State<DistributionWalletView> {
  ///分销员信息
  DistributionMemberModel _distributionMemberModel;
  String total = "0.00";
  String balance = "0.00";
  _DistributionWalletView(this._distributionMemberModel);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    balance = _distributionMemberModel.data.userInfo.balance;
    total = "${_distributionMemberModel.data.settlementTotalMoney}";

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _Content(),
          _getTopBar(),
        ],
      ),
    );
  }

  _getTopBar() {
    return InkWell(
      child: Container(
        margin: EdgeInsets.fromLTRB(12, MallApp.statusHeight + 12, 12, 12),
        child: Image.asset(LoginImages.GoBack,
            width: ScreenAdaper.width(16), height: ScreenAdaper.height(30)),
      ),
      onTap: () => Navigator.pop(context,true),
    );
  }

  _Content() {
    return Container(
      height: double.infinity,
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Positioned(
              child: Container(
            color: ColorsUtil.hexToColor("#C9B079"),
            height: ScreenAdaper.height(380),
            child: Container(),
          )),
          Positioned(
            top: ScreenAdaper.width(100) + MallApp.statusHeight,
            left: ScreenAdaper.width(20),
            right: ScreenAdaper.width(20),
            child: Container(
              child: Column(
                children: <Widget>[
                  _walletInfo(),
                  _listItem(
                      "images/ic_wallet_bank_card.png", "Bank card management",
                      () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DistributionBankCardView();
                    }));
                  }),
                  _listItem("images/ic_wallet_details.png", "Funding details",
                      () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DistributionOfflineListView();
                    }));
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getRow(String s, String t) {
    return Column(
      children: <Widget>[
        Container(
          child: Text(
            "$s",
            style: TextStyle(
                fontSize: ScreenAdaper.sp(24),
                color: ColorsUtil.hexToColor("#333333")),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          child: Text(
            "$t",
            style: TextStyle(
                fontSize: ScreenAdaper.sp(24),
                color: ColorsUtil.hexToColor("#666666")),
          ),
        ),
      ],
    );
  }

  /**
   * 钱包详情
   */
  _walletInfo() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenAdaper.width(20)))),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                "Total assets (\$)",
                style: TextStyle(
                    fontSize: ScreenAdaper.sp(24),
                    color: ColorsUtil.hexToColor("#6A4B08")),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "$total",
                style: TextStyle(
                    fontSize: ScreenAdaper.sp(64),
                    color: ColorsUtil.hexToColor("#2E313F")),
              ),
            ),
            Container(
              child: Text(
                "Balance：$balance",
                style: TextStyle(
                    fontSize: ScreenAdaper.sp(24),
                    color: ColorsUtil.hexToColor("#2E313F")),
              ),
            ),

            MaterialButton(
              onPressed: () async {
               bool refresh = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DistributionWithdrawalView(
                            _distributionMemberModel.data.userInfo.balance)));
               LogUtil.logD("refresh1111", "${refresh}");
               if(refresh) _getData();
              },
              child: Text(
                "withdraw",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              color: ColorsUtil.hexToColor("#BE925F"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              minWidth: double.infinity,
            ),
            Container(
              child: Text(
                "Withdraw during 20th to 25th of each month",
                style: TextStyle(
                    fontSize: ScreenAdaper.sp(20),
                    color: ColorsUtil.hexToColor("#999999")),
              ),
            )
          ],
        ),
      ),
    );
  }

  _listItem(String img, String msg, Function click) {
    return InkWell(
      onTap: () {
        if (click != null) {
          click();
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: 48,
        child: Row(
          children: <Widget>[
            Image.asset(img),
            Padding(
              padding: EdgeInsets.all(5),
            ),
            Expanded(
              child: Text(
                msg,
                style: TextStyle(
                    fontSize: ScreenAdaper.sp(24),
                    color: ColorsUtil.hexToColor("#333333")),
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

  void _getData() {
    ///获取登陆的用户信息
    SharePreferencesUtil.getLoginMsg().then((data) {
//      print("isLogin ==== " + data["isLogin"].toString());
      var distributionUid;
      distributionUid = data["distributionUid"];
      return distributionUid ??= null;
    }).then((distributionUid) {
      ///获取分销员信息
      var params = new FormData();
      params.add("user_id", distributionUid);

      ///分销测试接口
      NetWork.getInstance().post(Config.DISTRIBUTION_USER, params, (data) {
        var distributionMemberModel = DistributionMemberModel.fromJson(data);
        if (distributionMemberModel.code == 200) {
          setState(() {
            _distributionMemberModel = distributionMemberModel;
            balance = _distributionMemberModel.data.userInfo.balance;
            total = "${_distributionMemberModel.data.settlementTotalMoney}";
          });
        } else {
          ToastUtils.showToast(distributionMemberModel.msg);
        }
      }, (e) {
//          ToastUtils.showToast(e.toString());
        LogUtil.logE("MineView", e.toString());
      });
    });
  }


}
