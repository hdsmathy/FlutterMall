class OurBankModel {
  String message;
  int code;
  List<Data> data;

  OurBankModel({this.message, this.code, this.data});

  OurBankModel.fromJson(Map<String, dynamic> json) {
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
  String accountName;
  String accountNumber;
  String bankName;
  String sortCode;
  String iban;
  String bic;

  Data(
      {this.accountName,
        this.accountNumber,
        this.bankName,
        this.sortCode,
        this.iban,
        this.bic});

  Data.fromJson(Map<String, dynamic> json) {
    accountName = json['account_name'];
    accountNumber = json['account_number'];
    bankName = json['bank_name'];
    sortCode = json['sort_code'];
    iban = json['iban'];
    bic = json['bic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_name'] = this.accountName;
    data['account_number'] = this.accountNumber;
    data['bank_name'] = this.bankName;
    data['sort_code'] = this.sortCode;
    data['iban'] = this.iban;
    data['bic'] = this.bic;
    return data;
  }
}
