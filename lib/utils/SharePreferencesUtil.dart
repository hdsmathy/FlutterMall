import 'package:shared_preferences/shared_preferences.dart';

class SharePreferencesUtil {
  static Future saveMsg(
    bool isLogin,
    String id,
    String user_login,
    String user_nicename,
    String user_email,
    String user_url,
    String user_registered,
    String user_activation_key,
    String user_status,
    String display_name,
    String user_phone,
    String user_invitation_code,
    String distribution_uid,
    String token,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLogin", isLogin);
    sharedPreferences.setString("id", id);
    sharedPreferences.setString("user_login", user_login);
    sharedPreferences.setString("user_nicename", user_nicename);
    sharedPreferences.setString("user_email", user_email);
    sharedPreferences.setString("user_url", user_url);
    sharedPreferences.setString("user_registered", user_registered);
    sharedPreferences.setString("user_activation_key", user_activation_key);
    sharedPreferences.setString("user_status", user_status);
    sharedPreferences.setString("display_name", display_name);
    sharedPreferences.setString("user_phone", user_phone);
    sharedPreferences.setString("user_invitation_code", user_invitation_code);
    sharedPreferences.setString("distribution_uid", distribution_uid);
    sharedPreferences.setString("token", token);
  }

  static Future<Map> getLoginMsg() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map map = new Map();
    map["isLogin"] = sharedPreferences.getBool("isLogin");
    map["id"] = sharedPreferences.getString("id");
    map["userPhone"] = sharedPreferences.getString("user_phone");
    map["username"] = sharedPreferences.getString("user_nicename");
    map["distributionUid"] = sharedPreferences.getString("distribution_uid");
    return map;
  }

  static Future<String> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("token");
  }

  ///保存运送方式
  static Future saveShippingMethod(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("shipping_method", value);
  }

  ///获取运送方式
  static Future<String> getShippingMethod() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("shipping_method");
  }

  ///保存购物车数量
  static Future saveCar(int value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt("car_size", value);
  }

  ///获取购物车数量
  static Future<int> getCarSize() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt("car_size");
  }
}
