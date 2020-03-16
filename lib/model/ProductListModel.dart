

import 'package:olamall_app/model/ProductModel.dart';

class ProductListModel{

  List<ProductModel> productmoels;

  factory ProductListModel.fromJson(List<dynamic> json) {
    List<ProductModel> productmoels = new List<ProductModel>();
    productmoels = json.map((i) => ProductModel.fromJson(i)).toList();
    return ProductListModel(productmoels : productmoels);
  }

  ProductListModel({this.productmoels});

}