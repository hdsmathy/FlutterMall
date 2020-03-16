import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:olamall_app/config/Config.dart';
import 'package:olamall_app/constant/images.dart';
import 'package:olamall_app/constant/string.dart';
import 'package:olamall_app/model/DistributionMemberModel.dart' as MemberModel;
import 'package:olamall_app/model/DistributionMemberModel.dart';
import 'package:olamall_app/net/NetWork.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/distribution/distribution_contribution_list.dart';
import 'package:olamall_app/ui/distribution/distribution_rules.dart';
import 'package:olamall_app/ui/mall.dart';
import 'package:olamall_app/ui/widgets/custom_line.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/LogUtil.dart';
import 'package:olamall_app/utils/SharePreferencesUtil.dart';
import 'package:olamall_app/utils/ToastUtils.dart';
import 'package:olamall_app/utils/UiUtils.dart';

import 'distribution_Invitation_code.dart';
import 'distribution_bank_card.dart';
import 'distribution_commission_list.dart';
import 'distribution_goods_list.dart';
import 'distribution_offline_list.dart';
import 'distribution_wallet.dart';

class DistributionHomeView extends StatefulWidget {
  ///分销员信息
  MemberModel.DistributionMemberModel _distributionMemberModel;

  DistributionHomeView(this._distributionMemberModel);

  @override
  _DistributionHomeViewState createState() =>
      _DistributionHomeViewState(_distributionMemberModel.data);
}

class _DistributionHomeViewState extends State<DistributionHomeView> {
  MemberModel.Data _data;

  _DistributionHomeViewState(this._data);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: UiUtils.getAppBarStyle("OLA Partner", context: context),
        backgroundColor: ColorsUtil.hexToColor("#F4F4F4"),
        body: Container(
          margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ///头部等级栏
                _levelWidget(),

                ///分销员基本信息
                _contributionWidget(),

                ///中部是个按钮 Downline people list；DistributionSquare ；Commission details；Bank card
                _centerFourBtnWidget(),

                ///邀请码
                _invitationWidget(),

                ///distributionSquare
                _distributionSquareWidget(),

                ///任务中心
                _taskCenterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///任务中心item
  Widget _taskCenterItem(
    String title,
    String single,
    int singleStatus,
    String cumulative,
    int cumulativeStatus,
    String formermarch,
    int formermarchStatus,
  ) {
    return Container(
      margin: EdgeInsets.only(top: ScreenAdaper.height(10)),
      padding: EdgeInsets.all(ScreenAdaper.width(20)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(ScreenAdaper.width(10))),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              title ?? "",
              style:
                  TextStyle(color: Colors.black, fontSize: ScreenAdaper.sp(24)),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                top: ScreenAdaper.height(23), bottom: ScreenAdaper.height(22)),
            margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(ScreenAdaper.width(10))),
                color: ColorsUtil.hexToColor("#F6F6F6")),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: ScreenAdaper.width(39)),
                  alignment: Alignment.topCenter,
                  child: Text("."),
                ),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(left: ScreenAdaper.width(22)),
                  alignment: Alignment.topCenter,
                  child: Text(
                    "All records are full of single consumption ${single}\$",
                    style: TextStyle(
                        color: ColorsUtil.hexToColor("#666666"),
                        fontSize: ScreenAdaper.sp(24)),
                  ),
                )),
                Expanded(
                    child: Container(
                  alignment: Alignment.topCenter,
                  child: MaterialButton(
                    onPressed: () {},
                    child: Container(
                      alignment: Alignment.center,
                      width: ScreenAdaper.width(160),
                      height: ScreenAdaper.height(44),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(22)),
                          color: Colors.white),
                      child: Text(
                        singleStatus == 1 ? "Undone" : "Completed",
                        style: TextStyle(
                            color: singleStatus == 1
                                ? Colors.grey
                                : ColorsUtil.hexToColor("#E2C99B"),
                            fontSize: ScreenAdaper.sp(24)),
                      ),
                    ),
                  ),
                ))
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                top: ScreenAdaper.height(23), bottom: ScreenAdaper.height(22)),
            margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(ScreenAdaper.width(10))),
                color: ColorsUtil.hexToColor("#F6F6F6")),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: ScreenAdaper.width(39)),
                  alignment: Alignment.topCenter,
                  child: Text("."),
                ),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(left: ScreenAdaper.width(22)),
                  alignment: Alignment.topCenter,
                  child: Text(
                    "All records accumulated full sales ${cumulative}\$",
                    style: TextStyle(
                        color: ColorsUtil.hexToColor("#666666"),
                        fontSize: ScreenAdaper.sp(24)),
                  ),
                )),
                Expanded(
                    child: Container(
                  alignment: Alignment.topCenter,
                  child: MaterialButton(
                    onPressed: () {},
                    child: Container(
                      alignment: Alignment.center,
                      width: ScreenAdaper.width(160),
                      height: ScreenAdaper.height(44),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(22)),
                          color: Colors.white),
                      child: Text(
                        cumulativeStatus == 1 ? "Undone" : "Completed",
                        style: TextStyle(
                            color: singleStatus == 1
                                ? Colors.grey
                                : ColorsUtil.hexToColor("#E2C99B"),
                            fontSize: ScreenAdaper.sp(24)),
                      ),
                    ),
                  ),
                ))
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                top: ScreenAdaper.height(23), bottom: ScreenAdaper.height(22)),
            margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(ScreenAdaper.width(10))),
                color: ColorsUtil.hexToColor("#F6F6F6")),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: ScreenAdaper.width(39)),
                  alignment: Alignment.topCenter,
                  child: Text("."),
                ),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(left: ScreenAdaper.width(22)),
                  alignment: Alignment.topCenter,
                  child: Text(
                    "All records accumulated full sales ${formermarch}\$",
                    style: TextStyle(
                        color: ColorsUtil.hexToColor("#666666"),
                        fontSize: ScreenAdaper.sp(24)),
                  ),
                )),
                Expanded(
                    child: Container(
                  alignment: Alignment.topCenter,
                  child: MaterialButton(
                    onPressed: () {},
                    child: Container(
                      alignment: Alignment.center,
                      width: ScreenAdaper.width(160),
                      height: ScreenAdaper.height(44),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(22)),
                          color: Colors.white),
                      child: Text(
                        formermarchStatus == 1 ? "Undone" : "Completed",
                        style: TextStyle(
                            color: formermarchStatus == 1
                                ? Colors.grey
                                : ColorsUtil.hexToColor("#E2C99B"),
                            fontSize: ScreenAdaper.sp(24)),
                      ),
                    ),
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  ///任务中心
  Widget _taskCenterWidget() {
    return Container(
        margin: EdgeInsets.fromLTRB(
            ScreenAdaper.width(20),
            ScreenAdaper.height(59),
            ScreenAdaper.width(20),
            ScreenAdaper.height(20)),
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Task center",
                      style: TextStyle(
                          color: Colors.black, fontSize: ScreenAdaper.sp(24)),
                    ),
                  )),
                  Expanded(
                      child: Container(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return DistributionRulesView();
                            }));
                      },
                      child: Text(
                        "Rules",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenAdaper.sp(24),
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  )),
                ],
              ),
            ),
            ListView.builder(
                itemCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var item;
                  switch (index) {
                    case 0:
                      item = _taskCenterItem(
                        "Relegation Mission: ${_data.currentLevel.levelName} Member",
                        _data.currentLevel.levelDemo.singleStroke,
                        _data.currentLevel.levelDemo.singleStrokeStatus,
                        _data.currentLevel.levelDemo.cumulativeSales,
                        _data.currentLevel.levelDemo.cumulativeSalesStatus,
                        _data.currentLevel.levelDemo.formermarchSales,
                        _data.currentLevel.levelDemo.formermarchSalesStatus,
                      );
                      break;
                    case 1:
                      item = _taskCenterItem(
                        "Promotion task: ${_data.upLevel.levelName} Member",
                        _data.upLevel.levelDemo.singleStroke,
                        _data.upLevel.levelDemo.singleStrokeStatus,
                        _data.upLevel.levelDemo.cumulativeSales,
                        _data.upLevel.levelDemo.cumulativeSalesStatus,
                        _data.upLevel.levelDemo.formermarchSales,
                        _data.upLevel.levelDemo.formermarchSalesStatus,
                      );
                      break;
                  }
                  return item;
                })
          ],
        ));
  }

  ///distributionSquare
  Widget _distributionSquareWidget() {
    return InkWell(
      child: Container(
        height: ScreenAdaper.height(80),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(
            left: ScreenAdaper.width(20), right: ScreenAdaper.width(20)),
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenAdaper.width(10))),
            image: DecorationImage(
                image: AssetImage(DistributionImages.distributionSquareBg),
                fit: BoxFit.cover)),
        child: Container(
          margin: EdgeInsets.only(right: ScreenAdaper.width(42)),
          width: ScreenAdaper.width(40),
          height: ScreenAdaper.height(40),
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.all(Radius.circular(ScreenAdaper.width(20))),
              color: Colors.white),
          child: Image.asset(SubmitOrderImages.rightArrows),
        ),
      ),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => DistributionGoodsListView())),
    );
  }

  ///邀请码
  Widget _invitationWidget() {
    return Container(
      margin: EdgeInsets.fromLTRB(ScreenAdaper.width(20), 0,
          ScreenAdaper.width(20), ScreenAdaper.height(10)),
      color: Colors.white,
      alignment: Alignment.topCenter,
      child: Row(
        children: <Widget>[
          Expanded(
              child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                    top: ScreenAdaper.height(37),
                    left: ScreenAdaper.width(30),
                    right: ScreenAdaper.width(27)),
                child: RichText(
                    text: TextSpan(
                        text: "Invitation code\t\t\t\t",
                        style: TextStyle(
                            color: ColorsUtil.hexToColor("#666666"),
                            fontSize: ScreenAdaper.sp(24)),
                        children: <TextSpan>[
                      TextSpan(
                          text: "${_data.userInfo.invitationCode ?? ""}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenAdaper.sp(36)))
                    ])),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: ScreenAdaper.height(29),
                    left: ScreenAdaper.width(30),
                    right: ScreenAdaper.width(27),
                    bottom: ScreenAdaper.height(20)),
                child: Text(
                  "When the user fill in the invitation code when register will become your downline",
                  style: TextStyle(
                      color: Colors.grey, fontSize: ScreenAdaper.sp(20)),
                ),
              )
            ],
          )),
          Container(
            margin: EdgeInsets.only(
              top: ScreenAdaper.height(12),
            ),
            child: CustomPaint(
                foregroundPainter:
                    CustomHorLine(height: ScreenAdaper.height(135))),
          ),
          Expanded(
              child: Column(
            children: <Widget>[
              InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DistributionInvitationCodeView(
                              invitationCode: _data.userInfo.invitationCode,
                              invitationUrl: _data.codeUrl,
                            ))),
                child: Container(
                  margin: EdgeInsets.only(top: ScreenAdaper.height(25)),
                  child: Image.asset(DistributionImages.qrCode),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: ScreenAdaper.height(16)),
                child: Text(
                  "Scan code invitation registration",
                  style: TextStyle(
                      color: Colors.grey, fontSize: ScreenAdaper.sp(20)),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  ///按钮 item
  Widget _btnItem(String imageUrl, String title, Function onClick) {
    return Expanded(
        child: InkWell(
      child: Column(
        children: <Widget>[
          Container(
            child: Image.asset(imageUrl ?? ""),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenAdaper.height(21)),
            child: Text(
//              ,
              title ?? " ",
              style:
                  TextStyle(color: Colors.black, fontSize: ScreenAdaper.sp(20)),
            ),
          )
        ],
      ),
      onTap: onClick,
    ));
  }

  /// 中部是个按钮 Downline people list；DistributionSquare ；Commission details；Bank card
  Widget _centerFourBtnWidget() {
    return Container(
      padding: EdgeInsets.only(
          top: ScreenAdaper.height(35), bottom: ScreenAdaper.height(15)),
      child: Row(
        children: <Widget>[
          _btnItem(DistributionImages.downLine, Strings.DISTRIBUTION_DOWNLINE,
              () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DistributionOfflineListView()));
          }),
          _btnItem(DistributionImages.distributionSquare,
              Strings.DISTRIBUTION_SQUARE, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
//        return SettingView();
              return DistributionGoodsListView();
            }));
          }),
          _btnItem(
              DistributionImages.commission, Strings.DISTRIBUTION_COMMISSION,
              () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
//        return SettingView();
              return DistributionCommissionView();
            }));
          }),
          _btnItem(
              DistributionImages.bankCard,
              Strings.DISTRIBUTION_CARD,
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DistributionBankCardView()))),
        ],
      ),
    );
  }

  ///分销员基本信息
  Widget _contributionWidget() {
    String balance = _data.userInfo.balance.toString();
    String balanceFont;
    String balanceLater;
    if (balance != null && balance.contains(".")) {
      var split = balance.split(".");
      balanceFont = split[0];
      balanceLater = split[1];
    }
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(ScreenAdaper.width(10)),
              bottomLeft: Radius.circular(ScreenAdaper.width(10)))),
      margin: EdgeInsets.only(
          left: ScreenAdaper.width(20), right: ScreenAdaper.width(20)),
      padding: EdgeInsets.only(
          left: ScreenAdaper.width(20), right: ScreenAdaper.width(20)),
      child: Column(
        children: <Widget>[
          ///余额
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: ScreenAdaper.height(29)),
            child: Text(
              "Balance",
              style:
                  TextStyle(color: Colors.black, fontSize: ScreenAdaper.sp(24)),
            ),
          ),
          Row(
            children: <Widget>[
              InkWell(
                child: Container(
                  margin: EdgeInsets.only(top: ScreenAdaper.height(33)),
                  child: RichText(
                      text: TextSpan(
                          text: "\$ ${balanceFont ?? ""}",
                          style: TextStyle(
                              color: ColorsUtil.hexToColor("#BE925F"),
                              fontSize: ScreenAdaper.sp(36)),
                          children: <TextSpan>[
                        TextSpan(
                            text: ".${balanceLater ?? ""}",
                            style: TextStyle(
                                color: ColorsUtil.hexToColor("#BE925F"),
                                fontSize: ScreenAdaper.sp(24)))
                      ])),
                ),
                onTap: () async {
                  bool refresh = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DistributionWalletView(widget._distributionMemberModel)));
                  LogUtil.logD("refresh222", "${refresh}");
                  if(refresh) _getData();
                },
              ),
              Expanded(
                  child: Container(
                alignment: Alignment.centerRight,
                child: MaterialButton(
                  onPressed: () async {
                    bool refresh = await  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DistributionWalletView(
                                widget._distributionMemberModel)));
                    LogUtil.logD("refresh2333", "${refresh}");
                    if(refresh) _getData();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: ScreenAdaper.width(150),
                    height: ScreenAdaper.height(44),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(22)),
                        color: ColorsUtil.hexToColor("#BE925F")),
                    child: Text(
                      "My Wallet",
                      style: TextStyle(
                          color: Colors.white, fontSize: ScreenAdaper.sp(24)),
                    ),
                  ),
                ),
              ))
            ],
          ),

          ///
          Container(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  ScreenAdaper.width(10),
                  ScreenAdaper.height(5),
                  ScreenAdaper.width(10),
                  ScreenAdaper.height(5)),
              margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(ScreenAdaper.width(20))),
                  border: Border.all(color: Colors.grey, width: 1)),
              child: Text(
                "Self-purchase cashback interest: ${_data.isBuyReturnStatus == 1 ? "not obtained" : "obtained"}",
                style: TextStyle(
                    color: ColorsUtil.hexToColor("#BE925F"),
                    fontSize: ScreenAdaper.sp(20)),
              ),
            ),
          ),

          InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DistributionGoodsListView())),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(
                  ScreenAdaper.width(10),
                  ScreenAdaper.height(5),
                  ScreenAdaper.width(10),
                  ScreenAdaper.height(5)),
              margin: EdgeInsets.only(top: ScreenAdaper.height(16)),
              child: Text(
                "Buy at least one item worth \$ ${_data.isBuyReturn ?? ""} and complete the order >",
                style: TextStyle(
                    color: Colors.grey, fontSize: ScreenAdaper.sp(20)),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: ScreenAdaper.height(12),
            ),
            child: CustomPaint(
              foregroundPainter: new CustomLine(
                  width: MallApp.screenWidth - ScreenAdaper.width(20) * 4),
            ),
          ),

          /// Total contribution  Total commission
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(
                top: ScreenAdaper.height(30), bottom: ScreenAdaper.height(20)),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
//        return SettingView();
                      return DistributionContributionListView();
                    }));
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          "${_data.userInfo.contributionValue ?? ""}",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenAdaper.sp(24)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: ScreenAdaper.height(13)),
                        child: Text(
                          "Total contribution",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenAdaper.sp(24)),
                        ),
                      )
                    ],
                  ),
                )),
                Container(
                  margin: EdgeInsets.only(
                    top: ScreenAdaper.height(12),
                  ),
                  child: CustomPaint(
                      foregroundPainter:
                          CustomHorLine(height: ScreenAdaper.height(50))),
                ),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
//        return SettingView();
                      return DistributionCommissionView();
                    }));
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          "${_data.settlementTotalMoney ?? ""}",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenAdaper.sp(24)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: ScreenAdaper.height(13)),
                        child: Text(
                          "Total commission",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenAdaper.sp(24)),
                        ),
                      )
                    ],
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  ///头部等级栏
  Widget _levelWidget() {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenAdaper.width(20), right: ScreenAdaper.width(20)),
      padding: EdgeInsets.all(ScreenAdaper.width(10)),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          color: ColorsUtil.hexToColor("#2E313F"),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ScreenAdaper.width(10)),
              topRight: Radius.circular(ScreenAdaper.width(10)))),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: ScreenAdaper.width(10)),
            height: ScreenAdaper.height(60),
            width: ScreenAdaper.width(60),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ScreenAdaper.width(30))),
            child: Image.asset("images/ic_mine_star.png"),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: ScreenAdaper.width(10)),
            child: Text(
              "${_data.currentLevel.levelName ?? "Bronze"} Member",
              style:
                  TextStyle(color: Colors.white, fontSize: ScreenAdaper.sp(24)),
            ),
          ))
        ],
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
            _data = distributionMemberModel.data;

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
