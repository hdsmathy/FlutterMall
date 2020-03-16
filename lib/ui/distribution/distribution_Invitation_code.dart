import 'package:flutter/material.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/UiUtils.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DistributionInvitationCodeView extends StatefulWidget {
  ///邀请码
  var invitationCode;
  ///邀请链接
  var invitationUrl;


  DistributionInvitationCodeView({this.invitationCode, this.invitationUrl});

  @override
  State<StatefulWidget> createState() => _DistributionInvitationCodeView();
}

class _DistributionInvitationCodeView
    extends State<DistributionInvitationCodeView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Scaffold(
        appBar: UiUtils.getAppBarStyle("Invited QR code",context: context),
        backgroundColor: ColorsUtil.hexToColor("#F4F4F4"),
        body: Container(
          child: _getContent(),
        ),
      ),
    );
  }

  _getContent() {
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
              top: ScreenAdaper.height(200),
              left: ScreenAdaper.width(20),
              right: ScreenAdaper.width(20),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenAdaper.width(20)))),
                height: ScreenAdaper.height(620),
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding:
                      EdgeInsets.fromLTRB(0, 0, 0, ScreenAdaper.height(100)),
                  child: QrImage(
                    data: "${widget.invitationUrl}",
                    size: 150.0,
                  ),
                ),
              )),
          Positioned(
            top: ScreenAdaper.width(110),
            left: ScreenAdaper.width(0),
            right: ScreenAdaper.width(0),
            child: Container(
              height: ScreenAdaper.height(432),
              child: Column(
                children: <Widget>[
                  Container(
                    child: ClipOval(
                      child: new Image.asset("images/ic_defult_head.png"),
                    ),
                    height: ScreenAdaper.height(184),
                    width: ScreenAdaper.width(184),
                  ),
                  Container(
                    child: Text(
                      "Olamall has invited \n you to join Olamall",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: ScreenAdaper.sp(24),
                          color: ColorsUtil.hexToColor("#6A4B08")),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
