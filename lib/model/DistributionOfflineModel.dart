class DistributionOfflineModel {
  String msg;
  int code;
  Data data;

  DistributionOfflineModel({this.msg, this.code, this.data});

  DistributionOfflineModel.fromJson(Map<String, dynamic> json) {
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
  int firstCount;
  int secondCount;
  int thrCount;
  int currentPage;
  int total;
  int lastPage;

  Data(
      {this.dataList,
        this.firstCount,
        this.secondCount,
        this.thrCount,
        this.currentPage,
        this.total,
        this.lastPage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['dataList'] != null) {
      dataList = new List<DataList>();
      json['dataList'].forEach((v) {
        dataList.add(new DataList.fromJson(v));
      });
    }
    firstCount = json['first_count'];
    secondCount = json['second_count'];
    thrCount = json['thr_count'];
    currentPage = json['current_page'];
    total = json['total'];
    lastPage = json['last_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dataList != null) {
      data['dataList'] = this.dataList.map((v) => v.toJson()).toList();
    }
    data['first_count'] = this.firstCount;
    data['second_count'] = this.secondCount;
    data['thr_count'] = this.thrCount;
    data['current_page'] = this.currentPage;
    data['total'] = this.total;
    data['last_page'] = this.lastPage;
    return data;
  }
}

class DataList {
  String userName;
  int registerTime;
  int levelNum;

  DataList({this.userName, this.registerTime, this.levelNum});

  DataList.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    registerTime = json['register_time'];
    levelNum = json['level_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['register_time'] = this.registerTime;
    data['level_num'] = this.levelNum;
    return data;
  }
}
