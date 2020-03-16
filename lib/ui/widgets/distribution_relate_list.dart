import 'package:flutter/material.dart';
import 'package:olamall_app/model/DistributionRelateModel.dart';
import 'package:olamall_app/services/ScreenAdaper.dart';
import 'package:olamall_app/ui/commodity/CommodityDetailsPage.dart';
import 'package:olamall_app/utils/ColorsUtil.dart';

class DistributionRelateList extends StatelessWidget {
  List<ProductList> productModelList;
  int crossAxisCount;
  bool isHideSale;

  DistributionRelateList(this.productModelList,
      {this.crossAxisCount = 2, this.isHideSale = false});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        color: Color.fromRGBO(246, 243, 247, 1),
        child: GridView.builder(
          physics: new NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.all(0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemCount: productModelList.length,
          itemBuilder: (context, index) {
            //处理图片
//            String pic = this._shopList[index].pic;
//          pic = Config.domain + pic.replaceAll('\\', '/');

            ProductList productModel;

            String imageUrl = " ";
            String name = " ";
            String showPrice;
            String dicount;
            String commission;
            if (null != productModelList && productModelList.length != 0) {
              productModel = productModelList[index];

              imageUrl = productModel.image;
              if (null == productModel.title || "" == productModel.title) {
                name = "title";
              } else {
                name = productModel.title;
              }

              var price = productModel.price;
              if (null == price || "" == price) {
                showPrice = "0.00";
              } else {
                showPrice = price;
              }

              var regularPrice = productModel.regularPrice;
              if (null == regularPrice ||
                  null == price ||
                  "" == regularPrice ||
                  "" == price) {
                dicount = "0%";
              } else {
                var regularPrice2 = double.parse(regularPrice);
                var chajia = regularPrice2 - double.parse(price);

                double a = (chajia / regularPrice2) * 100;
                var split = a.toString().split(".");
                dicount = split[0] + "%";
              }
            }
            if(productModel.commission!=null){
              commission = productModel.commission;
            }else{
              commission = "0.00";
            }
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommodityDetailsPage(
                              iD: productModel.id,commission: productModel.commission,
                            )),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      color: Colors.white),
                  // padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Offstage(
                        offstage: isHideSale,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                //设置四周圆角 角度
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                                border: Border.all(
                                    width: 1,
                                    color: Color.fromRGBO(254, 61, 61, 1))),
                            child: Text(
                              dicount,
                              style: TextStyle(
                                  fontSize: ScreenAdaper.sp(18),
                                  color: Color.fromRGBO(254, 61, 61, 1)),
                            ),
                          ),
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Stack(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(
                                    ScreenAdaper.width(25),
                                    0,
                                    ScreenAdaper.width(25),
                                    0),
                                child:
                                    Image.network(imageUrl, fit: BoxFit.cover),
                              ),
                            ),
                            Container(
                            alignment: Alignment.bottomLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  //设置四周圆角 角度
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                    border: Border.all(
                                        width: 1,
                                        color: Color.fromRGBO(254, 61, 61, 1))),
                                margin: EdgeInsets.fromLTRB(
                                    ScreenAdaper.width(25),
                                    0,
                                    ScreenAdaper.width(25),
                                    0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(254, 61, 61, 1),
                                          //设置四周圆角 角度
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(50)),
                                            border: Border.all(
                                                width: 1,
                                                color: Color.fromRGBO(254, 61, 61, 1))),
                                        child: Text(
                                          "Rebate",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: ScreenAdaper.sp(24),
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Text(
                                          "\$$commission",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: ScreenAdaper.sp(24),
                                              color: ColorsUtil.hexToColor("#FC3721")),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.fromLTRB(
                                ScreenAdaper.width(25),
                                ScreenAdaper.width(18),
                                ScreenAdaper.width(28),
                                0),
                            alignment: Alignment.topLeft,
                            constraints: BoxConstraints(
                              minHeight: ScreenAdaper.height(92),
                            ),
                            child: Text(name,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                // 显示不完，就在后面显示点点
                                style: TextStyle(
                                  fontSize: ScreenAdaper.sp(24), // 文字大小
                                  color: Color.fromRGBO(51, 51, 51, 1), // 文字颜色
                                ))),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(ScreenAdaper.width(25), 0,
                            ScreenAdaper.width(28), ScreenAdaper.width(30)),
                        alignment: Alignment.topLeft,
                        child: Text(
                          "\$ ${showPrice}",
                          style: TextStyle(
                            fontSize: ScreenAdaper.sp(30), // 文字大小
                            color: Color.fromRGBO(255, 89, 89, 1), // 文字颜色
                          ),
                        ),
                      )
                    ],
                  ),
                ));
          },
        ));
  }
}
