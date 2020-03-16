class DistributionRelateModel {
  String message;
  int code;
  Data data;

  DistributionRelateModel({this.message, this.code, this.data});

  DistributionRelateModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String total;
  List<ProductList> productList;

  Data({this.total, this.productList});

  Data.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['product_list'] != null) {
      productList = new List<ProductList>();
      json['product_list'].forEach((v) {
        productList.add(new ProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.productList != null) {
      data['product_list'] = this.productList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductList {
  int id;
  String title;
  String sku;
  String image;
  String price;
  String regularPrice;
  int stockQuantity;
  String stockStatus;
  List<int> category;
  String commission;
  String url;

  ProductList(
      {this.id,
        this.title,
        this.sku,
        this.image,
        this.price,
        this.regularPrice,
        this.stockQuantity,
        this.stockStatus,
        this.category,
        this.commission,
        this.url});

  ProductList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    sku = json['sku'];
    image = json['image'];
    price = json['price'];
    regularPrice = json['regular_price'];
    stockQuantity = json['stock_quantity'];
    stockStatus = json['stock_status'];
    category = json['category'].cast<int>();
    commission = json['commission'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['sku'] = this.sku;
    data['image'] = this.image;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['stock_quantity'] = this.stockQuantity;
    data['stock_status'] = this.stockStatus;
    data['category'] = this.category;
    data['commission'] = this.commission;
    data['url'] = this.url;
    return data;
  }
}
