import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olamall_app/event/event.dart';
import 'package:olamall_app/net/api/woocommerce_config.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/utils/AppUtil.dart';
import 'package:olamall_app/utils/SharePreferencesUtil.dart';
import 'package:olamall_app/utils/ToastUtils.dart';
import 'package:olamall_app/utils/UiUtils.dart';

const int SHIPPING_ADDRESS_TYPE = 2;
const int BILLING_ADDRESS_TYPE = 1;

class AddressEditPage extends StatefulWidget {
  int type;

  AddressEditPage({Key key, @required this.type}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddressEditState(type: type);
}

class _AddressEditState extends State<AddressEditPage> {
  String _fristNameText = "";
  String _lastNameText = "";
  String _companyNameText = "";
  String _countyNameText = "Singapore";
  String _streetAddressText = "";
  String _streetAddressDetils = "";
  String townText = "";
  String _postcodeText = "";
  String _phoneText = "";
  String _emailText = "";
  String _otherText = "";
  int type;

  _AddressEditState({Key key, @required this.type}) {
    this.type = type;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: UiUtils.getAppBarStyle("Delivery Addresses", context: context),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              _FristName(),
              Container(
                height: 1,
                color: Color.fromRGBO(254, 252, 253, 1),
              ),
              _lastName(),
              Container(
                height: 1,
                color: Color.fromRGBO(254, 252, 253, 1),
              ),
              _companyName(),
              Container(
                height: 1,
                color: Color.fromRGBO(254, 252, 253, 1),
              ),
              _countyName(),
              Container(
                height: 1,
                color: Color.fromRGBO(254, 252, 253, 1),
              ),
              _streetAddress(),
              Container(
                height: 1,
                color: Color.fromRGBO(254, 252, 253, 1),
              ),
              __streetAddressEdit(),
              Container(
                height: 1,
                color: Color.fromRGBO(254, 252, 253, 1),
              ),
              _townEdit(),
              Container(
                height: 1,
                color: Color.fromRGBO(254, 252, 253, 1),
              ),
              _postcodeEdit(),
              _phoneAndEmail(),
              _otherEdit(),
//              Expanded(
//                child: Container(),
//              ),
              _save()
            ],
          ),
        ));
  }

  Widget _FristName() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: ScreenAdaper.height(64),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: RichText(
                text: TextSpan(
                    text: "First Name ",
                    style: TextStyle(
                        fontSize: ScreenAdaper.sp(26),
                        color: Color.fromRGBO(51, 51, 51, 1)),
                    children: <TextSpan>[
                      TextSpan(
                          text: "*",
                          style: TextStyle(
                              fontSize: ScreenAdaper.sp(26),
                              color: Color.fromRGBO(249, 59, 0, 1)))
                    ]),
              )),
          Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.centerLeft,
                height: ScreenAdaper.height(64),
                child: TextField(
                  onChanged: (value) {
                    this.setState(() {
                      _fristNameText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'First Name',
                    hintStyle: TextStyle(
                        fontSize: ScreenAdaper.sp(26),
                        color: Color.fromRGBO(102, 102, 102, 1)),
                    border: InputBorder.none,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _lastName() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: ScreenAdaper.height(64),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: RichText(
                text: TextSpan(
                    text: "Last Name ",
                    style: TextStyle(
                        fontSize: ScreenAdaper.sp(26),
                        color: Color.fromRGBO(51, 51, 51, 1)),
                    children: <TextSpan>[
                      TextSpan(
                          text: "*",
                          style: TextStyle(
                              fontSize: ScreenAdaper.sp(26),
                              color: Color.fromRGBO(249, 59, 0, 1)))
                    ]),
              )),
          Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.centerLeft,
                height: ScreenAdaper.height(64),
                child: TextField(
                  onChanged: (value) {
                    this.setState(() {
                      _lastNameText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Last Name',
                    hintStyle: TextStyle(
                        fontSize: ScreenAdaper.sp(26),
                        color: Color.fromRGBO(102, 102, 102, 1)),
                    border: InputBorder.none,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _companyName() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: ScreenAdaper.height(100),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: RichText(
                text: TextSpan(
                  text: "Company name (optional)",
                  style: TextStyle(
                      fontSize: ScreenAdaper.sp(26),
                      color: Color.fromRGBO(51, 51, 51, 1)),
                ),
              )),
          Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.centerLeft,
                height: ScreenAdaper.height(64),
                child: TextField(
                  onChanged: (value) {
                    this.setState(() {
                      _companyNameText = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _countyName() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
      height: ScreenAdaper.height(64),
      child: Row(
        children: <Widget>[
          Expanded(

              child: RichText(
                text: TextSpan(
                    text: "County ",
                    style: TextStyle(
                        fontSize: ScreenAdaper.sp(26),
                        color: Color.fromRGBO(51, 51, 51, 1)),
                    children: <TextSpan>[
                      TextSpan(
                          text: "*",
                          style: TextStyle(
                              fontSize: ScreenAdaper.sp(26),
                              color: Color.fromRGBO(249, 59, 0, 1)))
                    ]),
              )),
          Container(
              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
              alignment: Alignment.centerRight,
              height: ScreenAdaper.height(64),
              child: Container(
                alignment: Alignment.center,
                height: ScreenAdaper.height(48),
                width: ScreenAdaper.width(162),
                child: Text(
                  "Singapore",
                  style: TextStyle(color:Colors.grey,fontSize: ScreenAdaper.sp(24)),
                ),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(244, 244, 244, 1),
                    borderRadius: BorderRadius.all(Radius.circular(4))),
              ))
        ],
      ),
    );
  }

  Widget _streetAddress() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: ScreenAdaper.height(64),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: RichText(
                text: TextSpan(
                    text: "Street address ",
                    style: TextStyle(
                        fontSize: ScreenAdaper.sp(26),
                        color: Color.fromRGBO(51, 51, 51, 1)),
                    children: <TextSpan>[
                      TextSpan(
                          text: "*",
                          style: TextStyle(
                              fontSize: ScreenAdaper.sp(26),
                              color: Color.fromRGBO(249, 59, 0, 1)))
                    ]),
              )),
          Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.centerLeft,
                height: ScreenAdaper.height(64),
                child: TextField(
                  onChanged: (value) {
                    this.setState(() {
                      _streetAddressText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'House number and street name',
                    hintStyle: TextStyle(
                        fontSize: ScreenAdaper.sp(26),
                        color: Color.fromRGBO(102, 102, 102, 1)),
                    border: InputBorder.none,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  __streetAddressEdit() {
    return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        height: ScreenAdaper.height(64),
        child: TextField(
          onChanged: (value) {
            this.setState(() {
              _streetAddressDetils = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Apartment, suite, unit etc. (optional)',
            hintStyle: TextStyle(
                fontSize: ScreenAdaper.sp(26),
                color: Color.fromRGBO(102, 102, 102, 1)),
            border: InputBorder.none,
          ),
        ));
  }

  _townEdit() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: ScreenAdaper.height(64),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: RichText(
                text: TextSpan(
                  text: "Town/City(optional) ",
                  style: TextStyle(
                      fontSize: ScreenAdaper.sp(26),
                      color: Color.fromRGBO(51, 51, 51, 1)),
                ),
              )),
          Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.centerLeft,
                height: ScreenAdaper.height(64),
                child: TextField(
                  onChanged: (value) {
                    this.setState(() {
                      townText = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  _postcodeEdit() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: ScreenAdaper.height(64),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: RichText(
                text: TextSpan(
                    text: "Postcode / ZIP  ",
                    style: TextStyle(
                        fontSize: ScreenAdaper.sp(26),
                        color: Color.fromRGBO(51, 51, 51, 1)),
                    children: <TextSpan>[
                      TextSpan(
                          text: "*",
                          style: TextStyle(
                              fontSize: ScreenAdaper.sp(26),
                              color: Color.fromRGBO(249, 59, 0, 1)))
                    ]),
              )),
          Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.centerLeft,
                height: ScreenAdaper.height(64),
                child: TextField(
                  onChanged: (value) {
                    this.setState(() {
                      _postcodeText = value;
                    });
                  },
                  decoration: InputDecoration(
//                    hintText: 'Last Name',
//                    hintStyle: TextStyle(
//                        fontSize: ScreenAdaper.sp(26),
//                        color: Color.fromRGBO(102, 102, 102, 1)),
                    border: InputBorder.none,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  _phoneAndEmail() {
    return Offstage(
      offstage: type == BILLING_ADDRESS_TYPE ? false : true,
      child: Container(
        child: Column(
          children: <Widget>[_phoneEdit(), _emailEdit()],
        ),
      ),
    );
  }

  _phoneEdit() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: ScreenAdaper.height(64),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: RichText(
                text: TextSpan(
                    text: "Phone  ",
                    style: TextStyle(
                        fontSize: ScreenAdaper.sp(26),
                        color: Color.fromRGBO(51, 51, 51, 1)),
                    children: <TextSpan>[
                      TextSpan(
                          text: "*",
                          style: TextStyle(
                              fontSize: ScreenAdaper.sp(26),
                              color: Color.fromRGBO(249, 59, 0, 1)))
                    ]),
              )),
          Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.centerLeft,
                height: ScreenAdaper.height(64),
                child: TextField(
                  onChanged: (value) {
                    this.setState(() {
                      _phoneText = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  _emailEdit() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: ScreenAdaper.height(64),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: RichText(
                text: TextSpan(
                    text: "Email address ",
                    style: TextStyle(
                        fontSize: ScreenAdaper.sp(26),
                        color: Color.fromRGBO(51, 51, 51, 1)),
                    children: <TextSpan>[
                      TextSpan(
                          text: "*",
                          style: TextStyle(
                              fontSize: ScreenAdaper.sp(26),
                              color: Color.fromRGBO(249, 59, 0, 1)))
                    ]),
              )),
          Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.centerLeft,
                height: ScreenAdaper.height(64),
                child: TextField(
                  onChanged: (value) {
                    this.setState(() {
                      _emailText = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  _otherEdit() {
    return Container(
        height: ScreenAdaper.height(365),
        child: Offstage(
          offstage: type == 0 ? false : true,
          child: Column(
            children: <Widget>[
              _checkBox(),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                height: ScreenAdaper.height(68),
                child: Text(
                  "Order notes (optional)",
                  style: TextStyle(
                      fontSize: ScreenAdaper.sp(26),
                      color: Color.fromRGBO(51, 51, 51, 1)),
                ),
              ),
              Expanded(
                  child: Container(
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: TextField(
                        onChanged: (value) {
                          this.setState(() {
                            _otherText = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(1)),
                        border: Border.all(
                            width: 1, color: Color.fromRGBO(229, 229, 229, 1)),
                      ))),
            ],
          ),
        ));
  }

  bool isCheck = false;

  _checkBox() {
    return InkWell(
      onTap: () {
        setState(() {
          isCheck = !isCheck;
        });
      },
      child: Container(
        alignment: Alignment.centerLeft,
        height: ScreenAdaper.height(64),
        child: Row(
          children: <Widget>[
            Checkbox(
              value: isCheck,
            ),
            Text("Ship to a different address?",
                style: TextStyle(
                    fontSize: ScreenAdaper.sp(26),
                    color: Color.fromRGBO(51, 51, 51, 1)))
          ],
        ),
      ),
    );
  }

  _save() {
    return MaterialButton(
      onPressed: () {
        saveAddress();
      },
      child: Container(
        child: Container(
          height: ScreenAdaper.height(88),
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              color: Color.fromRGBO(248, 61, 0, 1)),
          child: Text(
            "Save",
            style:
                TextStyle(fontSize: ScreenAdaper.sp(26), color: Colors.white),
          ),
        ),
      ),
    );
  }

  saveAddress() async {
    ///获取登陆的用户信息
    String userid = await SharePreferencesUtil.getLoginMsg().then((data) {
      String uid = data["id"];
      return uid ??= null;
    });
    if (!checkData()) {
      return;
    }
    if (type == BILLING_ADDRESS_TYPE) {
      saveBillingAddress(userid);
    } else if (type == SHIPPING_ADDRESS_TYPE) {
      saveShippingAddress(userid);
    }
  }

  saveBillingAddress(userid) {
    var payLoad = {
      "billing": {
        "first_name": _fristNameText,
        "last_name": _lastNameText,
        "company": _companyNameText,
        "address_1": _streetAddressText,
        "address_2": _streetAddressDetils,
        "city": townText,
        "state": "CA",
        "postcode": _postcodeText,
        "country": _countyNameText,
        "email": _emailText,
        "phone": _phoneText
      }
    };
    WooCommerceConfig.getInstance().putDataAsync(
        endPoint: "customers",
        queryAtId: userid,
        payLoad: payLoad,
        success: (data) {
          ToastUtils.showToast("update success");
          eventBus.fire(AddressEvent());
          Navigator.pop(context);
        },
        error: (e) {
          print(e);
        });
  }

  bool checkData() {
    if (_fristNameText.isEmpty) {
      ToastUtils.showToast("Please input frist name");
      return false;
    }
    if (_lastNameText.isEmpty) {
      ToastUtils.showToast("Please input last name");
      return false;
    }

    if (_streetAddressText.isEmpty) {
      ToastUtils.showToast("Please input Street address ");
      return false;
    }
    if (_countyNameText.isEmpty) {
      ToastUtils.showToast("Please input Street County ");
      return false;
    }
    if (_postcodeText.isEmpty) {
      ToastUtils.showToast("Please input postcode");
      return false;
    }

    if (type == BILLING_ADDRESS_TYPE) {
      if (_phoneText.isEmpty) {
        ToastUtils.showToast("Please input phone");
        return false;
      }
      if (_emailText.isEmpty) {
        ToastUtils.showToast("Please input email");
        return false;
      }

      if (!AppUtil.isEmail(_emailText)) {
        ToastUtils.showToast("Please enter the correct email");
        return false;
      }
    }
    return true;
  }

  void saveShippingAddress(String userid) {
    var payLoad = {
      "shipping": {
        "first_name": _fristNameText,
        "last_name": _lastNameText,
        "company": _companyNameText,
        "address_1": _streetAddressText,
        "address_2": _streetAddressDetils,
        "city": townText,
        "state": "CA",
        "postcode": _postcodeText,
        "country": _countyNameText
      },
    };
    WooCommerceConfig.getInstance().putDataAsync(
        endPoint: "customers",
        queryAtId: userid,
        payLoad: payLoad,
        success: (data) {
          ToastUtils.showToast("update success");
          eventBus.fire(AddressEvent());
          Navigator.pop(context, true);
        },
        error: (e) {
          print(e);
        });
  }
}
