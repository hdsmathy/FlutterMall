import 'package:flutter/material.dart';

class NewProductModel {
  String message;
  int code;
  Data data;

  NewProductModel({this.message, this.code, this.data});

  NewProductModel.fromJson(Map<String, dynamic> json) {
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
  List<ProductList> productList;
  List<CategoryList> categoryList;

  Data({this.productList, this.categoryList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['product_list'] != null) {
      productList = new List<ProductList>();
      json['product_list'].forEach((v) {
        productList.add(new ProductList.fromJson(v));
      });
    }
    if (json['category_list'] != null) {
      categoryList = new List<CategoryList>();
      json['category_list'].forEach((v) {
        categoryList.add(new CategoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productList != null) {
      data['product_list'] = this.productList.map((v) => v.toJson()).toList();
    }
    if (this.categoryList != null) {
      data['category_list'] = this.categoryList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductList {
  String title;
  String sku;
  String image;
  String price;
  int productId;
  int stockQuantity;
  String stockStatus;
  List<int> category;

  ProductList(
      {this.title,
        this.sku,
        this.image,
        this.price,
        this.stockQuantity,
        this.stockStatus,
        this.category,this.productId});

  ProductList.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    sku = json['sku'];
    image = json['image'];
    price = json['price'];
    productId = json['product_id'];
    stockQuantity = json['stock_quantity'];
    stockStatus = json['stock_status'];
    category = json['category'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['sku'] = this.sku;
    data['image'] = this.image;
    data['price'] = this.price;
    data['stock_quantity'] = this.stockQuantity;
    data['stock_status'] = this.stockStatus;
    data['category'] = this.category;
    data['product_id']= this.productId;
    return data;
  }
}

class CategoryList {
  String termId;
  String name;
  String slug;
  String termGroup;
  String code;
  String title;
  String isTip;
  Color color;

  CategoryList(
      {this.termId,
        this.name,
        this.slug,
        this.termGroup,
        this.code,
        this.title,
        this.isTip,
        this.color=Colors.white});

  CategoryList.fromJson(Map<String, dynamic> json) {
    termId = json['term_id'];
    name = json['name'];
    slug = json['slug'];
    termGroup = json['term_group'];
    code = json['code'];
    title = json['title'];
    isTip = json['is_tip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['term_id'] = this.termId;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['term_group'] = this.termGroup;
    data['code'] = this.code;
    data['title'] = this.title;
    data['is_tip'] = this.isTip;
    return data;
  }
}

