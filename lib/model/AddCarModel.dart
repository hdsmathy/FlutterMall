class AddCarModel {
  String message;
  int code;
  Data data;

  AddCarModel({this.message, this.code, this.data});

  AddCarModel.fromJson(Map<String, dynamic> json) {
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
  String cartItemKey;

  Data({this.cartItemKey});

  Data.fromJson(Map<String, dynamic> json) {
    cartItemKey = json['cart_item_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_item_key'] = this.cartItemKey;
    return data;
  }
}
