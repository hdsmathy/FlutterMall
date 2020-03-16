import 'package:flutter/material.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';
import 'package:olamall_app/utils/UiUtils.dart';

class DistributionRulesView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DistributionRulesView();
}

class _DistributionRulesView
    extends State<DistributionRulesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiUtils.getAppBarStyle("OLA Partner Promotion rules", context: context),
      backgroundColor: ColorsUtil.hexToColor("#F4F4F4"),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(10,10,10,10),
              child: Image.asset("images/bg_rules.png"),
            )
          ],
        ),
      ),
    );
  }
}
