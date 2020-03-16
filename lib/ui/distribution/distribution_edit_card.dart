import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:olamall_app/config/Config.dart';
import 'package:olamall_app/net/NetWork.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/mall.dart';
import 'package:olamall_app/ui/widgets/custom_line.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/LogUtil.dart';
import 'package:olamall_app/utils/ToastUtils.dart';
import 'package:olamall_app/utils/UiUtils.dart';
import 'package:olamall_app/model/DistributionBankCardModel.dart' as Model;

class DistributionEditCardView extends StatefulWidget {
  int _type; // 1 添加银行卡，2 编辑银行卡
  String _uid;
  Model.Data banMsgModel;

  DistributionEditCardView(this._type, this._uid, {this.banMsgModel});

  @override
  _DistributionEditCardViewState createState() =>
      _DistributionEditCardViewState();
}

class _DistributionEditCardViewState extends State<DistributionEditCardView> {
  var _bankName;
  var _bankAccount;
  var _bankUserName;
  var _bankUserPhone;
  var _title;
  var _titleMsg;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget._type == 1) {
      _title = "Please set up your beneficiary account (savings account)";
      _titleMsg =
          "Olamall will transfer cash to this bank account for withdraw";
    } else {
      _title = "Edit my beneficiary account";
      _titleMsg =
          "For withdrawal, Olamall will transfer cash to the bank account";
      _bankName = widget.banMsgModel?.bankName ?? "";
      _bankAccount = widget.banMsgModel?.bankNumber;
      _bankUserName = widget.banMsgModel?.bankUserName;
      _bankUserPhone = widget.banMsgModel?.userPhone;
    }
  }

  void _addOrEditBankMsg() {
    var params = FormData();
    String url;
    if (widget._type == 1) {
      url = Config.DIS_ADD_BANK;
    } else {
      url = Config.DIS_EDIT_BANK_CARD;
      params.add("bank_id", widget.banMsgModel.bankId);
    }

    params.add("user_id", widget._uid);
    params.add("bank_name", _bankName);
    params.add("bank_number", _bankAccount);
    params.add("bank_user_name", _bankUserName);
    params.add("user_phone", _bankUserPhone);
    NetWork.getInstance().post(url, params, (data) {
      if (data['code'] == 1004) {
        ToastUtils.showToast("success");
        Navigator.pop(context, true);
      }else{
        ToastUtils.showToast(data['msg']);
      }
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
        appBar: UiUtils.getAppBarStyle("My Bank Account", context: context),
        body: ListView(
          children: <Widget>[
            ///顶部title
            _titleItem(),

            ///编辑银行卡
            _cardItemWidget(),

            ///提交按钮
            _confirmBtnWidget()
          ],
        ),
      ),
    );
  }

  Widget _confirmBtnWidget() {
    return Container(
      margin: EdgeInsets.fromLTRB(
          ScreenAdaper.width(45),
          ScreenAdaper.height(100),
          ScreenAdaper.width(45),
          ScreenAdaper.height(100)),
      height: ScreenAdaper.height(88),
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenAdaper.height(40))),
          color: ColorsUtil.hexToColor("#F83D00")),
      child: MaterialButton(
        onPressed: _addOrEditBankMsg,
        child: Text(
          "Confirm",
          style: TextStyle(color: Colors.white, fontSize: ScreenAdaper.sp(30)),
        ),
      ),
    );
  }

  Widget _cardItemWidget() {
    var style = TextStyle(fontSize: ScreenAdaper.sp(24), color: Colors.grey);
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
                    "*Bank Name",
                    style: TextStyle(
                        color: Colors.black, fontSize: ScreenAdaper.sp(30)),
                  ),
                )),
                Expanded(
                    child: Container(
                  alignment: Alignment.centerLeft,
                  height: ScreenAdaper.height(64),
                  child: TextField(
                    onChanged: (value) {
                      this.setState(() {
                        _bankName = value;
                      });
                    },
                    controller: TextEditingController.fromValue(
                        TextEditingValue(
                            text: _bankName ?? "",
                            selection: TextSelection.fromPosition(TextPosition(
                                affinity: TextAffinity.downstream,
                                offset: '${this._bankName}'.length)))),

                    ///有值的时候，设置默认值
                    style: style,
                    decoration: InputDecoration(
                      hintText: 'Please enter the bank name',
                      hintStyle: TextStyle(
                          fontSize: ScreenAdaper.sp(24), color: Colors.grey),
                      border: InputBorder.none,
                    ),
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
                    "*Bank Account",
                    style: TextStyle(
                        color: Colors.black, fontSize: ScreenAdaper.sp(30)),
                  ),
                )),
                Expanded(
                    child: Container(
                  alignment: Alignment.centerLeft,
                  height: ScreenAdaper.height(64),
                  child: TextField(
                    controller: TextEditingController.fromValue(
                        TextEditingValue(
                            text: _bankAccount ?? "",
                            selection: TextSelection.fromPosition(TextPosition(
                                affinity: TextAffinity.downstream,
                                offset: '${this._bankAccount}'.length)))),

                    ///有值的时候，设置默认值
                    style: style,
                    onChanged: (value) {
                      this.setState(() {
                        _bankAccount = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Please enter bank account',
                      hintStyle: TextStyle(
                          fontSize: ScreenAdaper.sp(24), color: Colors.grey),
                      border: InputBorder.none,
                    ),
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
                    "*Name",
                    style: TextStyle(
                        color: Colors.black, fontSize: ScreenAdaper.sp(30)),
                  ),
                )),
                Expanded(
                    child: Container(
                  alignment: Alignment.centerLeft,
                  height: ScreenAdaper.height(64),
                  child: TextField(
                    controller: TextEditingController.fromValue(
                        TextEditingValue(
                            text: _bankUserName ?? "",
                            selection: TextSelection.fromPosition(TextPosition(
                                affinity: TextAffinity.downstream,
                                offset: '${this._bankUserName}'.length)))),

                    ///有值的时候，设置默认值
                    style: style,
                    onChanged: (value) {
                      this.setState(() {
                        _bankUserName = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Please enter bank account',
                      hintStyle: TextStyle(
                          fontSize: ScreenAdaper.sp(24), color: Colors.grey),
                      border: InputBorder.none,
                    ),
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
                    "*Cellphone Number",
                    style: TextStyle(
                        color: Colors.black, fontSize: ScreenAdaper.sp(30)),
                  ),
                )),
                Expanded(
                    child: Container(
                  alignment: Alignment.centerLeft,
                  height: ScreenAdaper.height(64),
                  child: TextField(
                    controller: TextEditingController.fromValue(
                        TextEditingValue(
                            text: _bankUserPhone ?? "",
                            selection: TextSelection.fromPosition(TextPosition(
                                affinity: TextAffinity.downstream,
                                offset: '${this._bankUserPhone}'.length)))),

                    ///有值的时候，设置默认值
                    onChanged: (value) {
                      this.setState(() {
                        _bankUserPhone = value;
                      });
                    },
                    style: style,
                    decoration: InputDecoration(
                      hintText: 'Please enter the account holder phone number',
                      hintStyle: TextStyle(
                          fontSize: ScreenAdaper.sp(24), color: Colors.grey),
                      border: InputBorder.none,
                    ),
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
              _title ?? "",
              style:
                  TextStyle(color: Colors.black, fontSize: ScreenAdaper.sp(30)),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: ScreenAdaper.height(10)),
            child: Text(
              _titleMsg ?? "",
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
}
