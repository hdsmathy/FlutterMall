class CarItemModel {
  String message;
  int code;
  List<Data> data;

  CarItemModel({this.message, this.code, this.data});

  CarItemModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    code = json['code'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String key;
  int productId;
  int variationId;

//  Variation variation;
  int quantity;
  String dataHash;

//  int lineSubtotal;
//  int lineSubtotalTax;
//  int lineTotal;
//  int lineTax;
  Product product;
  int addQuantity;

  Data(
      {this.key,
      this.productId,
      this.variationId,
//        this.variation,
      this.quantity,
      this.dataHash,
//        this.lineSubtotal,
//        this.lineSubtotalTax,
//        this.lineTotal,
//        this.lineTax,
      this.product});

  Data.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    productId = json['product_id'];
    variationId = json['variation_id'];
//    variation = json['variation'] != null
//        ? new Variation.fromJson(json['variation'])
//        : null;
    addQuantity = quantity = json['quantity'];
    dataHash = json['data_hash'];
//    lineSubtotal = json['line_subtotal'];
//    lineSubtotalTax = json['line_subtotal_tax'];
//    lineTotal = json['line_total'];
//    lineTax = json['line_tax'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['product_id'] = this.productId;
    data['variation_id'] = this.variationId;
//    if (this.variation != null) {
//      data['variation'] = this.variation.toJson();
//    }
    data['quantity'] = this.quantity;
    data['data_hash'] = this.dataHash;
//    data['line_subtotal'] = this.lineSubtotal;
//    data['line_subtotal_tax'] = this.lineSubtotalTax;
//    data['line_total'] = this.lineTotal;
//    data['line_tax'] = this.lineTax;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'Data{key: $key, productId: $productId, variationId: $variationId, quantity: $quantity, dataHash: $dataHash,  product: $product}';
  }
}

class Variation {
  String attributeAttributePaColor;

  Variation({this.attributeAttributePaColor});

  Variation.fromJson(Map<String, dynamic> json) {
    attributeAttributePaColor = json['attribute_attribute_pa_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attribute_attribute_pa_color'] = this.attributeAttributePaColor;
    return data;
  }
}

class Product {
  String title;
  String sku;
  String image;
  String price;

//  AttributeSummary attributeSummary;
  int stockQuantity;
  String stockStatus;
  List<AttributeSummaryArray> attributeSummaryArray;

  Product(
      {this.title,
      this.sku,
      this.image,
      this.price,
//        this.attributeSummary,
      this.stockQuantity,
      this.stockStatus,
      this.attributeSummaryArray});

  Product.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    sku = json['sku'];
    image = json['image'];
    price =
        json['price'] == null || json['price'] == "" ? "0.00" : json['price'];
//    attributeSummary = json['attribute_summary'] != null
//        ? new AttributeSummary.fromJson(json['attribute_summary'])
//        : null;
    stockQuantity = json['stock_quantity'];
    stockStatus = json['stock_status'];
    if (json['attribute_summary_array'] != null) {
      attributeSummaryArray = new List<AttributeSummaryArray>();
      json['attribute_summary_array'].forEach((v) {
        attributeSummaryArray.add(new AttributeSummaryArray.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['sku'] = this.sku;
    data['image'] = this.image;
    data['price'] = this.price;
//    if (this.attributeSummary != null) {
//      data['attribute_summary'] = this.attributeSummary.toJson();
//    }
    data['stock_quantity'] = this.stockQuantity;
    data['stock_status'] = this.stockStatus;
    if (this.attributeSummaryArray != null) {
      data['attribute_summary_array'] =
          this.attributeSummaryArray.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'Product{title: $title, sku: $sku, image: $image, price: $price, stockQuantity: $stockQuantity, stockStatus: $stockStatus, attributeSummaryArray: $attributeSummaryArray}';
  }
}

class AttributeSummary {
  String paColor;

  AttributeSummary({this.paColor});

  AttributeSummary.fromJson(Map<String, dynamic> json) {
    paColor = json['pa_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pa_color'] = this.paColor;
    return data;
  }

  @override
  String toString() {
    return 'AttributeSummary{paColor: $paColor}';
  }
}

class AttributeSummaryArray {
  String key;
  String val;

  AttributeSummaryArray({this.key, this.val});

  AttributeSummaryArray.fromJson(Map<String, dynamic> json) {
    key = json['key']??" ";
    val = (json['val'] is Map)?" ":json['val'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['val'] = this.val;
    return data;
  }

  @override
  String toString() {
    return 'AttributeSummaryArray{key: $key, val: $val}';
  }
}
