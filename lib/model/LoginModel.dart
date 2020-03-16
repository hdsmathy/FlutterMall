class LoginModel {
  String message;
  int code;
  List<Data> data;

  LoginModel({this.message, this.code, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
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
  String iD;
  String userLogin;
  String userNicename;
  String userEmail;
  String userUrl;
  String userRegistered;
  String userActivationKey;
  String userStatus;
  String displayName;
  String userPhone;
  String userInvitationCode;
  String distributionUid;
  String isAge;
  int time;
  String token;

  Data(
      {this.iD,
        this.userLogin,
        this.userNicename,
        this.userEmail,
        this.userUrl,
        this.userRegistered,
        this.userActivationKey,
        this.userStatus,
        this.displayName,
        this.userPhone,
        this.userInvitationCode,
        this.distributionUid,
        this.isAge,
        this.time,
        this.token});

  Data.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    userLogin = json['user_login'];
    userNicename = json['user_nicename'];
    userEmail = json['user_email'];
    userUrl = json['user_url'];
    userRegistered = json['user_registered'];
    userActivationKey = json['user_activation_key'];
    userStatus = json['user_status'];
    displayName = json['display_name'];
    userPhone = json['user_phone'];
    userInvitationCode = json['user_invitation_code'];
    distributionUid = json['distribution_uid'];
    isAge = json['is_age'];
    time = json['time'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['user_login'] = this.userLogin;
    data['user_nicename'] = this.userNicename;
    data['user_email'] = this.userEmail;
    data['user_url'] = this.userUrl;
    data['user_registered'] = this.userRegistered;
    data['user_activation_key'] = this.userActivationKey;
    data['user_status'] = this.userStatus;
    data['display_name'] = this.displayName;
    data['user_phone'] = this.userPhone;
    data['user_invitation_code'] = this.userInvitationCode;
    data['distribution_uid'] = this.distributionUid;
    data['is_age'] = this.isAge;
    data['time'] = this.time;
    data['token'] = this.token;
    return data;
  }
}
