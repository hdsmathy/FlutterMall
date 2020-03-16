import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:olamall_app/constant/string.dart';
import 'package:olamall_app/generated/i18n.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/cart/car.dart';
import 'package:olamall_app/ui/home/home.dart';
import 'package:olamall_app/ui/mine/mine.dart';
import 'package:olamall_app/event/event.dart';
import 'category/category.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:ui';
import 'package:flutter_bugly/flutter_bugly.dart';

class MallApp extends StatelessWidget {
  int startIndex;

  /// 状态栏高度
  static double statusHeight = MediaQueryData.fromWindow(window).padding.top;

  /// 屏幕宽度
  static double screenWidth = MediaQueryData.fromWindow(window).size.width;

  /// 屏幕高度
  static double screenHeight = MediaQueryData.fromWindow(window).size.height;

//  FlutterBugly.init(androidAppId: "8f7299b5fe",iOSAppId: "your iOS app id");
  @override
  Widget build(BuildContext context) {
    FlutterBugly.init(androidAppId: "8f7299b5fe", iOSAppId: "your iOS app id");
    // TODO: implement build
    return new MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      routes: {
        '/main': (context) => MallMainView(),
      },
      initialRoute: '/main',
//      home: MallMainView(),
    );
  }
}

class MallMainView extends StatefulWidget {
  @override
  _MallMainViewState createState() => _MallMainViewState();
}

class _MallMainViewState extends State<MallMainView>
    with SingleTickerProviderStateMixin {
  List<Widget> _list = List();
  int _selectedIndex = 0;
  StreamSubscription mSubscription;
  @override
  void initState() {
    super.initState();
    _list
      ..add(HomeView())
      ..add(CategoryView())
      ..add(CarView())
      ..add(MineView());
    //订阅eventbus
    mSubscription = eventBus.on<MainSelectEvent>().listen((event) {
      _onItemTapped(event.index);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //注意用ScreenAdaper必须得在build方法里面初始化
    ScreenAdaper.init(context);
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _list,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(Strings.HOME),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            title: Text(Strings.CATEGORY),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text(Strings.SHOP_CAR),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text(Strings.MINE),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrangeAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
