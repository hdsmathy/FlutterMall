class DistributionContributionListModel {
  String msg;
  int code;
  Data data;

  DistributionContributionListModel({this.msg, this.code, this.data});

  DistributionContributionListModel.fromJson(Map<String, dynamic> json) {
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
  String totalContributionValue;
  int currentPage;
  int total;
  int lastPage;

  Data(
      {this.dataList,
        this.totalContributionValue,
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
    totalContributionValue = "${json['total_contribution_value']}";
    currentPage = json['current_page'];
    total = json['total'];
    lastPage = json['last_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dataList != null) {
      data['dataList'] = this.dataList.map((v) => v.toJson()).toList();
    }
    data['total_contribution_value'] = this.totalContributionValue;
    data['current_page'] = this.currentPage;
    data['total'] = this.total;
    data['last_page'] = this.lastPage;
    return data;
  }
}

class DataList {
  int sourceUserId;
  String sourceUserName;
  int addTime;
  String values;
  int type;

  DataList(
      {this.sourceUserId,
        this.sourceUserName,
        this.addTime,
        this.values,
        this.type});

  DataList.fromJson(Map<String, dynamic> json) {
    sourceUserId = json['source_user_id'];
    sourceUserName = json['source_user_name'];
    addTime = json['add_time'];
    values = json['values'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['source_user_id'] = this.sourceUserId;
    data['source_user_name'] = this.sourceUserName;
    data['add_time'] = this.addTime;
    data['values'] = this.values;
    data['type'] = this.type;
    return data;
  }
}
