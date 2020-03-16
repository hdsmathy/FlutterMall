class DistributionMemberModel {
  String msg;
  int code;
  Data data;

  DistributionMemberModel({this.msg, this.code, this.data});

  DistributionMemberModel.fromJson(Map<String, dynamic> json) {
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
  UserInfo userInfo;
  String settlementTotalMoney;
  int parentId;
  String parentUserName;
  CurrentLevel currentLevel;
  CurrentLevel upLevel;
  String isBuyReturn;
  String codeUrl;
  int isBuyReturnStatus;

  Data(
      {this.userInfo,
        this.settlementTotalMoney,
        this.parentId,
        this.parentUserName,
        this.currentLevel,
        this.upLevel,
        this.isBuyReturn,
        this.codeUrl,
        this.isBuyReturnStatus});

  Data.fromJson(Map<String, dynamic> json) {
    userInfo = json['user_info'] != null
        ? new UserInfo.fromJson(json['user_info'])
        : null;
    settlementTotalMoney = "${json['settlement_total_money']}";
    parentId = json['parent_id'];
    parentUserName = json['parent_user_name'];
    currentLevel = json['current_level'] != null
        ? new CurrentLevel.fromJson(json['current_level'])
        : null;
    upLevel = json['up_level'] != null
        ? new CurrentLevel.fromJson(json['up_level'])
        : null;
    isBuyReturn = json['isBuyReturn'];
    codeUrl = json['code_url'];
    isBuyReturnStatus = json['isBuyReturn_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userInfo != null) {
      data['user_info'] = this.userInfo.toJson();
    }
    data['settlement_total_money'] = this.settlementTotalMoney;
    data['parent_id'] = this.parentId;
    data['parent_user_name'] = this.parentUserName;
    if (this.currentLevel != null) {
      data['current_level'] = this.currentLevel.toJson();
    }
    if (this.upLevel != null) {
      data['up_level'] = this.upLevel.toJson();
    }
    data['isBuyReturn'] = this.isBuyReturn;
    data['code_url'] = this.codeUrl;
    data['isBuyReturn_status'] = this.isBuyReturnStatus;
    return data;
  }
}

class UserInfo {
  int userId;
  String userName;
  int levelId;
  String userPhone;
  String userEmail;
  int portId;
  int registerTime;
  int openUpgrade;
  String balance;
  String invitationCode;
  String contributionValue;
  String password;

  UserInfo(
      {this.userId,
        this.userName,
        this.levelId,
        this.userPhone,
        this.userEmail,
        this.portId,
        this.registerTime,
        this.openUpgrade,
        this.balance,
        this.invitationCode,
        this.contributionValue,
        this.password});

  UserInfo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    levelId = json['level_id'];
    userPhone = json['user_phone'];
    userEmail = json['user_email'];
    portId = json['port_id'];
    registerTime = json['register_time'];
    openUpgrade = json['open_upgrade'];
    balance = json['balance'];
    invitationCode = json['invitation_code'];
    contributionValue = json['contribution_value'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['level_id'] = this.levelId;
    data['user_phone'] = this.userPhone;
    data['user_email'] = this.userEmail;
    data['port_id'] = this.portId;
    data['register_time'] = this.registerTime;
    data['open_upgrade'] = this.openUpgrade;
    data['balance'] = this.balance;
    data['invitation_code'] = this.invitationCode;
    data['contribution_value'] = this.contributionValue;
    data['password'] = this.password;
    return data;
  }
}

class CurrentLevel {
  String levelName;
  LevelDemo levelDemo;

  CurrentLevel({this.levelName, this.levelDemo});

  CurrentLevel.fromJson(Map<String, dynamic> json) {
    levelName = json['level_name'];
    levelDemo = json['level_demo'] != null
        ? new LevelDemo.fromJson(json['level_demo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level_name'] = this.levelName;
    if (this.levelDemo != null) {
      data['level_demo'] = this.levelDemo.toJson();
    }
    return data;
  }
}

class LevelDemo {
  String singleStroke;
  int singleStrokeStatus;
  String cumulativeSales;
  int cumulativeSalesStatus;
  String formermarchSales;
  int formermarchSalesStatus;

  LevelDemo(
      {this.singleStroke,
        this.singleStrokeStatus,
        this.cumulativeSales,
        this.cumulativeSalesStatus,
        this.formermarchSales,
        this.formermarchSalesStatus});

  LevelDemo.fromJson(Map<String, dynamic> json) {
    singleStroke = json['single_stroke'];
    singleStrokeStatus = json['single_stroke_status'];
    cumulativeSales = json['cumulative_sales'];
    cumulativeSalesStatus = json['cumulative_sales_status'];
    formermarchSales = json['formermarch_sales'];
    formermarchSalesStatus = json['formermarch_sales_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['single_stroke'] = this.singleStroke;
    data['single_stroke_status'] = this.singleStrokeStatus;
    data['cumulative_sales'] = this.cumulativeSales;
    data['cumulative_sales_status'] = this.cumulativeSalesStatus;
    data['formermarch_sales'] = this.formermarchSales;
    data['formermarch_sales_status'] = this.formermarchSalesStatus;
    return data;
  }
}