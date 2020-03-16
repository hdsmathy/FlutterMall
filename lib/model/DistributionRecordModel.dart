class DistributionRecordModel {
  String msg;
  int code;
  Data data;

  DistributionRecordModel({this.msg, this.code, this.data});

  DistributionRecordModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<DataList> dataList;
  int currentPage;
  int total;
  int lastPage;

  Data({this.dataList, this.currentPage, this.total, this.lastPage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['dataList'] != null) {
      dataList = new List<DataList>();
      json['dataList'].forEach((v) {
        dataList.add(new DataList.fromJson(v));
      });
    }
    currentPage = json['current_page'];
    total = json['total'];
    lastPage = json['last_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dataList != null) {
      data['dataList'] = this.dataList.map((v) => v.toJson()).toList();
    }
    data['current_page'] = this.currentPage;
    data['total'] = this.total;
    data['last_page'] = this.lastPage;
    return data;
  }
}

class DataList {
  int userId;
  String orderPayMoney;
  String orderSn;
  String recordMoney;
  int type;
  int settlementStatus;
  int orderSettlementTime;
  int buyerId;
  String userName;

  DataList(
      {this.userId,
        this.orderPayMoney,
        this.orderSn,
        this.recordMoney,
        this.type,
        this.settlementStatus,
        this.orderSettlementTime,
        this.buyerId,
        this.userName});

  DataList.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    orderPayMoney = json['order_pay_money'];
    orderSn = json['order_sn'];
    recordMoney = json['record_money'];
    type = json['type'];
    settlementStatus = json['settlement_status'];
    orderSettlementTime = json['order_settlement_time'];
    buyerId = json['buyer_id'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['order_pay_money'] = this.orderPayMoney;
    data['order_sn'] = this.orderSn;
    data['record_money'] = this.recordMoney;
    data['type'] = this.type;
    data['settlement_status'] = this.settlementStatus;
    data['order_settlement_time'] = this.orderSettlementTime;
    data['buyer_id'] = this.buyerId;
    data['user_name'] = this.userName;
    return data;
  }
}
