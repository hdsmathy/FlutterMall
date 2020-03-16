import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:olamall_app/config/Config.dart';
import 'package:olamall_app/constant/string.dart';
import 'package:olamall_app/model/DistributionBankCardModel.dart' as Model;
import 'package:olamall_app/net/NetWork.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/distribution/distribution_edit_card.dart';
import 'package:olamall_app/ui/mall.dart';
import 'package:olamall_app/ui/widgets/custom_line.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/LogUtil.dart';
import 'package:olamall_app/utils/SharePreferencesUtil.dart';
import 'package:olamall_app/utils/ToastUtils.dart';

class DistributionBankCardView extends StatefulWidget {
  @override
  _DistributionBankCardViewState createState() =>
      _DistributionBankCardViewState();
}

class _DistributionBankCardViewState extends State<DistributionBankCardView> {

  String _userId;
  Model.Data _model;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getBankMsg();
  }

  ///获取银行卡信息
  void _getBankMsg() async {
    _userId = await SharePreferencesUtil.getLoginMsg().then((data) {
      return data['distributionUid'] ?? "";
    });

    var params = FormData();
    params.add("user_id", _userId);
    NetWork.getInstance().get(Config.DIS_GET_BANK_LIST, params, (data) {
      if (data['code'] == 200) {
        var m = Model.DistributionBankCardModel.fromJson(data);
        if(m.data!=null&&m.data.length>0){
          _model = m.data[0];
        }
      } else {
        ToastUtils.showToast(data['msg']);
      }
      setState(() {});
    }, (e) {
      ToastUtils.showToast("Server exception");
      LogUtil.logE("DistributionBankCardView", e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _appbarWidget(),
        body: ListView.builder(
            itemCount: 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _titleItem();
              }
              return _cardItemWidget();
            }),
      ),
    );
  }

  Widget _cardItemWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(ScreenAdaper.width(23),
          ScreenAdaper.height(29), ScreenAdaper.width(23), 0),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bank Name",
                    style: TextStyle(
                        color: Colors.grey, fontSize: ScreenAdaper.sp(24)),
                  ),
                )),
                Expanded(
                    child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _model?.bankName ?? "",
                    style: TextStyle(
                        color: Colors.grey, fontSize: ScreenAdaper.sp(24)),
                  ),
                ))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: ScreenAdaper.height(20), bottom: ScreenAdaper.height(20)),
            child: CustomPaint(
              foregroundPainter: CustomLine(
                  width: MallApp.screenWidth - ScreenAdaper.width(23) * 2),
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bank Account",
                    style: TextStyle(
                        color: Colors.grey, fontSize: ScreenAdaper.sp(24)),
                  ),
                )),
                Expanded(
                    child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _model?.bankNumber ?? "",
                    style: TextStyle(
                        color: Colors.grey, fontSize: ScreenAdaper.sp(24)),
                  ),
                ))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: ScreenAdaper.height(20), bottom: ScreenAdaper.height(20)),
            child: CustomPaint(
              foregroundPainter: CustomLine(
                  width: MallApp.screenWidth - ScreenAdaper.width(23) * 2),
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Name",
                    style: TextStyle(
                        color: Colors.grey, fontSize: ScreenAdaper.sp(24)),
                  ),
                )),
                Expanded(
                    child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _model?.bankUserName ?? "",
                    style: TextStyle(
                        color: Colors.grey, fontSize: ScreenAdaper.sp(24)),
                  ),
                ))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: ScreenAdaper.height(20), bottom: ScreenAdaper.height(20)),
            child: CustomPaint(
              foregroundPainter: CustomLine(
                  width: MallApp.screenWidth - ScreenAdaper.width(23) * 2),
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Cellphone Number",
                    style: TextStyle(
                        color: Colors.grey, fontSize: ScreenAdaper.sp(24)),
                  ),
                )),
                Expanded(
                    child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _model?.userPhone ?? "",
                    style: TextStyle(
                        color: Colors.grey, fontSize: ScreenAdaper.sp(24)),
                  ),
                ))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
            child: CustomPaint(
              foregroundPainter: CustomLine(
                  width: MallApp.screenWidth - ScreenAdaper.width(23) * 2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleItem() {
    return Container(
      padding: EdgeInsets.fromLTRB(ScreenAdaper.width(23),
          ScreenAdaper.width(23), ScreenAdaper.width(23), 0),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "My beneficiary account",
              style:
                  TextStyle(color: Colors.black, fontSize: ScreenAdaper.sp(30)),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: ScreenAdaper.height(10)),
            child: Text(
              "For withdrawal, Olamall will transfer cash to the bank account",
              style:
                  TextStyle(color: Colors.grey, fontSize: ScreenAdaper.sp(20)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenAdaper.height(21)),
            child: CustomPaint(
              foregroundPainter: CustomLine(
                  strokeWidth: ScreenAdaper.height(20),
                  width: MallApp.screenWidth),
            ),
          )
        ],
      ),
    );
  }

  ///AppBar
  Widget _appbarWidget() {
    return AppBar(
      title: Text(
        "My Bank Account",
        style: TextStyle(
            fontSize: ScreenAdaper.sp(36), color: Color.fromRGBO(0, 0, 0, 1)),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: ColorsUtil.hexToColor("#010101"),
        ),
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () async {
            bool result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => DistributionEditCardView(
                      _model==null?1:2,
                          _userId,
                          banMsgModel: _model,
                        )));
            if (result) _getBankMsg();
          },
          child: Text(
            "Edite",
            style: TextStyle(color: Colors.grey, fontSize: ScreenAdaper.sp(24)),
          ),
        )
      ],
    );
  }


}
