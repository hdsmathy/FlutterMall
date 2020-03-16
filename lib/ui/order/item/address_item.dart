import 'package:flutter/material.dart';
import 'package:olamall_app/model/OrderListModel.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/widgets/custom_line.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';

import '../../mall.dart';

class AddressItem extends StatelessWidget {
  Billing billing;
  Shipping shipping;

  AddressItem({this.billing, this.shipping});

  @override
  Widget build(BuildContext context) {
    String addressType;
    String line1Msg;
    String address;
    String postcode;
    String detailAddress;
    String email;
    String phone;
    String company;
    String city;

    if (null != billing) {
      addressType = "Billing address";
      line1Msg = (billing.firstName ?? "") + " & " + (billing.lastName ?? "");
      phone = (billing.phone ?? "");
      address = (billing.address1 ?? "") +
          ", " +
          (billing.city ?? "") +
          ", " +
          (billing.country ?? "");
      postcode = billing.postcode;
      detailAddress = billing.address2;
      email = billing.email;
      company = billing.company;
      city = billing.city;
    } else {
      addressType = "Shipping address";
      line1Msg = (shipping.firstName ?? "") + " & " + (shipping.lastName ?? "");
      address = (shipping.address1 ?? "") +
          ", " +
          (shipping.city ?? "") +
          ", " +
          (shipping.country ?? "");
      detailAddress = shipping.address2;
      postcode = shipping.postcode;
      company = shipping.company;
      city = shipping.city;
    }
    return Container(
      margin: EdgeInsets.only(top: ScreenAdaper.height(4)),
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
          ScreenAdaper.width(21),
          ScreenAdaper.width(29),
          ScreenAdaper.width(19),
          ScreenAdaper.width(20)),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              addressType,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenAdaper.sp(32),
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
            child: CustomPaint(
              foregroundPainter: new CustomLine(
                  width: MallApp.screenWidth - ScreenAdaper.width(20) * 2),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  line1Msg ?? " ",
                  style: TextStyle(
                      color: Colors.black, fontSize: ScreenAdaper.sp(26)),
                )),
                Container(
                  child: Text(
                    phone ?? " ",
                    style: TextStyle(
                        color: ColorsUtil.hexToColor("#666666"),
                        fontSize: ScreenAdaper.sp(24)),
                  ),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: ScreenAdaper.height(19)),
            child: Text(
              address ?? " ",
              style:
                  TextStyle(color: Colors.grey, fontSize: ScreenAdaper.sp(24)),
            ),
          ),
          Offstage(
            offstage:detailAddress == null ||detailAddress == "" ? true : false,
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
              child: Text(
                detailAddress ?? " ",
                style: TextStyle(
                    color: Colors.grey, fontSize: ScreenAdaper.sp(24)),
              ),
            ),
          ),
          Offstage(
            offstage: null == postcode ? true : false,
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
              child: Text(
                postcode ?? " ",
                style: TextStyle(
                    color: Colors.grey, fontSize: ScreenAdaper.sp(24)),
              ),
            ),
          ),
          Offstage(
            offstage: email == null || email==""? true : false,
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
              child: Text(
                email ?? " ",
                style: TextStyle(
                    color: Colors.grey, fontSize: ScreenAdaper.sp(24)),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
            child: CustomPaint(
              foregroundPainter: new CustomLine(
                  width: MallApp.screenWidth - ScreenAdaper.width(20) * 2),
            ),
          ),
          Offstage(
            offstage: company == null ||company == ""? true : false,
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
              child: Text(
                "Company name :" + (company ?? " "),
                style: TextStyle(
                    color: Colors.grey, fontSize: ScreenAdaper.sp(24)),
              ),
            ),
          ),
          Offstage(
            offstage: city == null ||city == ""? true : false,
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: ScreenAdaper.height(20)),
              child: Text(
                "Town / City :" + (city ?? " "),
                style: TextStyle(
                    color: Colors.grey, fontSize: ScreenAdaper.sp(24)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
