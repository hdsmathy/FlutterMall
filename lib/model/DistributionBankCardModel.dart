class DistributionBankCardModel {
  String msg;
  int code;
  List<Data> data;

  DistributionBankCardModel({this.msg, this.code, this.data});

  DistributionBankCardModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
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
    data['msg'] = this.msg;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int bankId;
  String bankName;
  String bankNumber;
  String bankUserName;
  String userPhone;
  int addTime;
  int userId;
  String areaCode;

  Data(
      {this.bankId,
        this.bankName,
        this.bankNumber,
        this.bankUserName,
        this.userPhone,
        this.addTime,
        this.userId,
        this.areaCode});

  Data.fromJson(Map<String, dynamic> json) {
    bankId = json['bank_id'];
    bankName = json['bank_name'];
    bankNumber = json['bank_number'];
    bankUserName = json['bank_user_name'];
    userPhone = json['user_phone'];
    addTime = json['add_time'];
    userId = json['user_id'];
    areaCode = json['area_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bank_id'] = this.bankId;
    data['bank_name'] = this.bankName;
    data['bank_number'] = this.bankNumber;
    data['bank_user_name'] = this.bankUserName;
    data['user_phone'] = this.userPhone;
    data['add_time'] = this.addTime;
    data['user_id'] = this.userId;
    data['area_code'] = this.areaCode;
    return data;
  }
}
