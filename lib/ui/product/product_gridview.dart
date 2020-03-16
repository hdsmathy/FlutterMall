import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductGridView extends StatelessWidget {
  List<String> productListData;
  ProductGridView(this.productListData);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 0.8),
          itemBuilder: (BuildContext context, int index) {
            return _getGridViewItem(context, productListData[index]);
          }),
    );
  }

  Widget _getGridViewItem(BuildContext context, String goodsProduct) {
    return Container(
      child: InkWell(
        child: Card(
          elevation: 2.0,
          margin: EdgeInsets.all(6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.all(5.0),
                  height: 150,
                  child: Image.network(
                      "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=4118995111,3080179733&fm=26&gp=0.jpg",
                      fit: BoxFit.cover)),
              Padding(
                padding: EdgeInsets.only(top: 4.0),
              ),
              Container(
                padding: EdgeInsets.only(left: 4.0, top: 4.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  goodsProduct,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black54, fontSize: 12.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
