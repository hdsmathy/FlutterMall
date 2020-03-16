import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:olamall_app/config/Config.dart';
import 'package:olamall_app/constant/images.dart';
import 'package:olamall_app/constant/string.dart';
import 'package:olamall_app/generated/i18n.dart';
import 'package:olamall_app/model/DistributionBankCardModel.dart';
import 'package:olamall_app/net/NetWork.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/distribution/distribution_edit_card.dart';
import 'package:olamall_app/ui/mall.dart';
import 'package:olamall_app/ui/widgets/custom_line.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/LogUtil.dart';
import 'package:olamall_app/utils/SharePreferencesUtil.dart';
import 'package:olamall_app/utils/ToastUtils.dart';
import 'package:olamall_app/utils/UiUtils.dart';

import '../../utils/LogUtil.dart';
import 'distribution_bank_card.dart';

class DistributionWithdrawalView extends StatefulWidget {
  String _balance;

  DistributionWithdrawalView(this._balance);

  @override
  _DistributionWithdrawalViewState createState() =>
      _DistributionWithdrawalViewState(_balance);
}

class _DistributionWithdrawalViewState
    extends State<DistributionWithdrawalView> {
  String _balance = "";

  TextEditingController _controller = new TextEditingController();

  _DistributionWithdrawalViewState(this._balance);

  var _canWithdraw = false;
  String _bankName;
  String _bankId;
  String _bankAccount;
  String _bankUserPhone;
  String _userId;
  String _inputPrice;
  String _smsCode;
  String _showTips;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    LogUtil.logD("DistributionWithdrawalView", "balance = $_balance");
    _showTips = "Available balance \$${_balance ?? "0.00"}";
    _controller.addListener(() {
      _inputPrice = _controller.text.toString();
      double price;
      if (null == _inputPrice || _inputPrice.length == 0) {
        _showTips = "Available balance \$${_balance ?? "0.00"}";
        _canWithdraw = false;
        setState(() {});
        return;
      }
      try {
        price = double.parse(_inputPrice);
        var a = double.parse(_balance) - price;
        if (a >= 0) {
          _canWithdraw = true;
          _showTips = "Available balance \$${_balance ?? "0.00"}";
        } else {
          _canWithdraw = false;
          _showTips = "Your change is not enough";
        }
        setState(() {});
      } catch (e) {
        ToastUtils.showToast("Please enter the correct number");
      }
    });
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
        if (null != data['data'] && data['data'].length != 0) {
          var distributionBankCardModel =
              DistributionBankCardModel.fromJson(data);

          for (var model in distributionBankCardModel.data) {
            _bankName = model.bankName;
            _bankAccount = model.bankNumber;
            _bankUserPhone = model.userPhone;
            _bankId = model.bankId.toString();
          }
        } else {
          ToastUtils.showToast("Please add bank card");
        }
        setState(() {});
      } else {
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
          backgroundColor: ColorsUtil.hexToColor("#F4F4F4"),
          appBar: _appbarWidget(),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ///银行卡信息
                _bankItemWidget(),

                ///提现信息
                _withdrawalAmountWidget(),

                ///提交按钮
                _confirmBtnWidget(),
              ],
            ),
          )),
    );
  }

  ///提交按钮
  Widget _confirmBtnWidget() {
    return Container(
      margin: EdgeInsets.fromLTRB(
          ScreenAdaper.width(45),
          ScreenAdaper.height(100),
          ScreenAdaper.width(45),
          ScreenAdaper.height(100)),
      height: ScreenAdaper.height(88),
      width:
          MallApp.screenWidth - ScreenAdaper.width(59) - ScreenAdaper.width(37),
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenAdaper.height(40))),
          color: _canWithdraw
              ? ColorsUtil.hexToColor("#F83D00")
              : ColorsUtil.hexToColor("#D5D5D5")),
      child: MaterialButton(
        onPressed: showGetSms,
        child: Text(
          "Confirm To Withdraw",
          style: TextStyle(color: Colors.white, fontSize: ScreenAdaper.sp(30)),
        ),
      ),
    );
  }

  ///提现信息
  Widget _withdrawalAmountWidget() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: ScreenAdaper.height(10)),
      padding: EdgeInsets.fromLTRB(
          ScreenAdaper.width(20),
          ScreenAdaper.height(39),
          ScreenAdaper.width(20),
          ScreenAdaper.height(20)),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Withdrawal Amount",
              style:
                  TextStyle(color: Colors.grey, fontSize: ScreenAdaper.sp(26)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenAdaper.height(100)),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: "SGD",
                  hintStyle: TextStyle(
                      color: ColorsUtil.hexToColor("#666666"),
                      fontSize: ScreenAdaper.sp(36))),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
            alignment: Alignment.centerLeft,
            child: Text(
              _showTips ?? "",
              style: TextStyle(
                  color: _showTips.contains("enough")
                      ? ColorsUtil.hexToColor("#F83D00")
                      : Colors.grey,
                  fontSize: ScreenAdaper.sp(24)),
            ),
          )
        ],
      ),
    );
  }

  ///银行卡信息
  Widget _bankItemWidget() {
    String bankStr;
    if (null != _bankName && null != _bankAccount) {
      if (_bankAccount.length > 4)
        bankStr = _bankName +
            "(****" +
            _bankAccount?.substring(
                _bankAccount.length - 4, _bankAccount.length) +
            ")";
      else
        bankStr = _bankName + "(****" + _bankAccount.toString() + ")";
    }

    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: ScreenAdaper.height(10)),
      padding: EdgeInsets.fromLTRB(
          ScreenAdaper.width(23),
          ScreenAdaper.height(36),
          ScreenAdaper.width(23),
          ScreenAdaper.height(36)),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Receiving Bank Account",
              style:
                  TextStyle(color: Colors.black, fontSize: ScreenAdaper.sp(30)),
            ),
          ),
          Expanded(
            child: InkWell(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: ScreenAdaper.height(10)),
                child: Text(
                  bankStr ?? "",
                  style: TextStyle(
                      color: Colors.grey, fontSize: ScreenAdaper.sp(24)),
                ),
              ),
              onTap: _editBankCard,
            ),
          ),
          InkWell(
            child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: ScreenAdaper.height(21)),
                child: Image.asset(SubmitOrderImages.rightArrows)),
            onTap: _editBankCard,
          )
        ],
      ),
    );
  }

  ///AppBar
  Widget _appbarWidget() {
    return AppBar(
      title: Text(
        "Withdrawal",
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
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: showRulesDialog,
          child: Text(
            "Withdrawal Rules",
            style: TextStyle(color: Colors.grey, fontSize: ScreenAdaper.sp(24)),
          ),
        )
      ],
    );
  }

  ///编辑银行卡
  void _editBankCard() async {
    if (null == _bankName && null == _bankAccount) {
      bool result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DistributionEditCardView(1, _userId)));
      if (result) _getBankMsg();
    } else {
      bool result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => DistributionBankCardView()));
      if (result) _getBankMsg();
    }
  }

  ///显示Withdrawal rules
  void showRulesDialog() {
    showDialog<Null>(
        context: context,
        barrierDismissible: true, //点击空白处关闭对话框
        builder: (BuildContext context) {
          return new AlertDialog(
              content: GestureDetector(
            child: new SingleChildScrollView(
              child: Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Withdrawal rules",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenAdaper.sp(36)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(ScreenAdaper.width(20)),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: ColorsUtil.hexToColor("#999999"),
                                width: 1)),
                        child: Text(
                          Strings.WITHDRAWAL_RULES,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenAdaper.sp(20)),
                        ),
                        margin: EdgeInsets.only(top: ScreenAdaper.height(30)),
                      )
                    ],
                  )),
            ),
            onTap: () => Navigator.pop(context),
          ));
        });
  }

  ///显示获取验证码弹窗
  void showGetSms() {
    if (!_canWithdraw) {
      ToastUtils.showToast("Please enter the correct number");
      return;
    }
    String phonTips = "";
    if (_bankUserPhone.length > 4)
      phonTips =
          "You will be receiving a SMS to ${_bankUserPhone?.substring(0, 3)}***${_bankUserPhone?.substring(_bankUserPhone?.length - 3, _bankUserPhone?.length)} with a verification code";
    else
      phonTips =
          "You will be receiving a SMS to ${_bankUserPhone} with a verification code";

    showDialog<Null>(
        context: context,
        barrierDismissible: false, //点击空白处关闭对话框
        builder: (BuildContext context) {
          return new AlertDialog(
              content: GestureDetector(
            child: new SingleChildScrollView(
              child: Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "SMS verification",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenAdaper.sp(36)),
                        ),
                      ),
                      Container(
//                        padding: EdgeInsets.all(ScreenAdaper.width(24)),

                        child: Text(
                          phonTips ?? "",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenAdaper.sp(20)),
                        ),
                        margin: EdgeInsets.only(top: ScreenAdaper.height(30)),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: ScreenAdaper.height(30)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(ScreenAdaper.width(8))),
                            border: Border.all(
                                color: ColorsUtil.hexToColor("#E5E5E5"))),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: TextField(
                              onChanged: (value) {
                                this.setState(() {
                                  _smsCode = value;
                                });
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "   Verification code",
                                  hintStyle: TextStyle(
                                      color: ColorsUtil.hexToColor("#999999"),
                                      fontSize: ScreenAdaper.sp(24))),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenAdaper.sp(24)),
                            )),
                            Container(
                              child: CustomPaint(
                                foregroundPainter: CustomHorLine(
                                    height: ScreenAdaper.height(40)),
                              ),
                            ),
                            Container(
                              child: MaterialButton(
                                onPressed: _getSmsCode,
                                child: Text(
                                  "Send",
                                  style: TextStyle(
                                      color: ColorsUtil.hexToColor("#999999"),
                                      fontSize: ScreenAdaper.sp(24)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: ScreenAdaper.height(29)),
                        decoration: BoxDecoration(
//                            border: Border.all(color:ColorsUtil.hexToColor("#E5E5E5"))
                            border: Border(
                                top: BorderSide(
                                    color: ColorsUtil.hexToColor("#E5E5E5")))),
                        child: MaterialButton(
                          minWidth: double.infinity,

                          ///充满父布局宽度
                          onPressed: () {
                            if (null != _smsCode) {
                              _confirmMsg();
                              Navigator.pop(context);
                            } else {
                              ToastUtils.showToast(
                                  'Please fill in the verification code');
                            }
                          },
                          child: Text(
                            "Ok",
                            style: TextStyle(
                                color: ColorsUtil.hexToColor("#F93B00"),
                                fontSize: ScreenAdaper.sp(28)),
                          ),
                        ),
                      )
                    ],
                  )),
            ),
            onTap: () => Navigator.pop(context),
          ));
        });
  }

  ///提交提现申请
  void _confirmMsg() {
    var params = FormData();
    params.add("user_id", _userId);
    params.add("bank_id", _bankId);
    params.add("cash_money", _inputPrice);
    params.add("codes", _smsCode);
    NetWork.getInstance().post(Config.DIS_GET_CASH, params, (data) {
      if (data['code'] == 3004) {
        ToastUtils.showToast("Withdrawal success");
        Navigator.pop(context,true);
      } else {
        ToastUtils.showToast(data['msg']);
      }
    }, (e) {
      ToastUtils.showToast("Server exception");
      LogUtil.logE("DistributionBankCardView", e.toString());
    });
  }

  ///获取验证码
  void _getSmsCode() {
    var params = FormData();
    params.add("phone", _bankUserPhone);
    NetWork.getInstance().post(Config.DIS_SEND_SMS, params, (data) {
      if (data['code'] == 200) {
        ToastUtils.showToast("The verification code was successfully obtained");
      } else {
        ToastUtils.showToast(data['msg']);
      }
    }, (e) {
      ToastUtils.showToast("Server exception");
      LogUtil.logE("DistributionBankCardView", e.toString());
    });
  }
}
