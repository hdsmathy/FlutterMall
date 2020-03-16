import 'package:flutter/material.dart';
import 'package:olamall_app/net/DioManager.dart';
import 'package:olamall_app/ui/goods/search_goods_list_view.dart';
import 'package:olamall_app/utils/ToastUtils.dart';
import 'dart:ui';

import '../../services/ScreenAdaper.dart';
import '../../config/Config.dart';
import 'package:dio/dio.dart';
import '../../model/CateModel.dart';
import 'ProductList.dart';

class CategoryView extends StatefulWidget {
  CategoryView({Key key}) : super(key: key);

  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryView> {
  int _selectIndex = 0;
  List _leftCateList = [];
  List _rightCateList = [];

  @override
  void initState() {
    super.initState();
    _getLeftCateData();
  }

  //左侧分类
  _getLeftCateData() async {
    FormData params = FormData.from({"language_id": 1});

    DioManager.getInstance().post(Config.MAIN_CLASSIFY_URL, params, (data) {
      var left = new CateModel.fromJson(data);
      setState(() {
        this._leftCateList = left.data;
      });
      _getRightCateData(this._leftCateList[0].ch);
    }, (error) {
      ToastUtils.showToast(error.toString());
    });
  }

  //右侧分类
  _getRightCateData(ch) async {
    setState(() {
      this._rightCateList = ch;
    });
  }

  Widget _leftCateWidget(leftWidth) {
    if (this._leftCateList.length > 0) {
      return Container(
        width: leftWidth,
        height: double.infinity,
        // color: Colors.red,
        child: ListView.builder(
          padding: EdgeInsets.all(0),
          itemCount: this._leftCateList.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectIndex = index;
                      this._getRightCateData(this._leftCateList[index].ch);
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: ScreenAdaper.height(118),
                    alignment: Alignment.center,
                    child: Text("${this._leftCateList[index].title}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ScreenAdaper.sp(24), // 文字大小
                          color: _selectIndex == index
                              ? Color.fromARGB(255, 249, 59, 0)
                              : Color.fromARGB(255, 102, 102, 102), // 文字颜色
                        )),
                    color: _selectIndex == index
                        ? Color.fromRGBO(240, 246, 246, 0.9)
                        : Colors.white,
                  ),
                ),
                Divider(height: 1),
              ],
            );
          },
        ),
      );
    } else {
      return Container(width: leftWidth, height: double.infinity);
    }
  }

  Widget _rightCateWidget(rightItemWidth, rightItemHeight) {
    if (this._rightCateList.length > 0) {
      return Expanded(
        flex: 1,
        child: Container(
            padding: EdgeInsets.all(10),
            height: double.infinity,
            color: Color.fromRGBO(240, 246, 246, 0.9),
            child: GridView.builder(
              padding: EdgeInsets.all(0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: rightItemWidth /
                      (rightItemHeight + ScreenAdaper.height(30)),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: this._rightCateList.length,
              itemBuilder: (context, index) {
                //处理图片
                String pic = this._rightCateList[index].thumbnailImg;

                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductListPage(
                                ch: this._rightCateList[index])),
                      );
                    },
                    child: Container(
                      // padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 1 / 1,
                            child: Image.network("${pic}", fit: BoxFit.cover),
                          ),
                          Container(
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    0, ScreenAdaper.height(13), 0, 0),
                                child:
                                    Text("${this._rightCateList[index].title}",
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        // 显示不完，就在后面显示点点
                                        style: TextStyle(
                                          fontSize: ScreenAdaper.sp(24), // 文字大小
                                          color: Color.fromARGB(
                                              255, 51, 51, 51), // 文字颜色
                                        ))),
                          )
                        ],
                      ),
                    ));
              },
            )),
      );
    } else {
      return Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(10),
            height: double.infinity,
            color: Color.fromRGBO(240, 246, 246, 0.9),
            child: Text("loading..."),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    //左侧宽度
    var leftWidth = ScreenAdaper.getScreenWidth() / 4;
    //右侧每一项宽度=（总宽度-左侧宽度-GridView外侧元素左右的Padding值-GridView中间的间距）/3
    var rightItemWidth =
        (ScreenAdaper.getScreenWidth() - leftWidth - 20 - 20) / 3;
    //获取计算后的宽度
    rightItemWidth = ScreenAdaper.width(rightItemWidth);
    //获取计算后的高度
    var rightItemHeight = rightItemWidth + ScreenAdaper.height(28);

    return Column(children: <Widget>[
      Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(
              0, MediaQueryData.fromWindow(window).padding.top, 0, 0),
          child: Container(
              height: ScreenAdaper.height(64),
              margin: EdgeInsets.fromLTRB(
                  ScreenAdaper.width(20),
                  ScreenAdaper.height(12),
                  ScreenAdaper.height(12),
                  ScreenAdaper.width(20)),
              padding: EdgeInsets.fromLTRB(ScreenAdaper.width(30), 0, 0, 0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 244, 244, 244),
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              child: InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) =>
                          SearchGoodsListView()),);
                },
                child: Row(
                  children: <Widget>[
                    //          Padding(padding: EdgeInsets.fromLTRB(0, MediaQueryData.fromWindow(window).padding.top, 0, 0),),
                    Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 181, 181, 182),
                    ),
                    Text("搜索",
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // 显示不完，就在后面显示点点
                        style: TextStyle(
                          fontSize: ScreenAdaper.sp(26), // 文字大小
                          color: Color.fromARGB(255, 187, 188, 189), // 文字颜色
                        ))
                  ],
                ),
              ))),
      Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              _leftCateWidget(leftWidth),
              _rightCateWidget(rightItemWidth, rightItemHeight)
            ],
          )),
    ]);
  }
}
