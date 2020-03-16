import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:olamall_app/net/api/query_string.dart';
import 'package:olamall_app/utils/LogUtil.dart';
import '../GlobalConfig.dart';

class WooCommerceConfig {
  String wooCommerceUrl = GlobalConfig.baseUrl;
  String clientKey = GlobalConfig.consumer_key;
  String clientSecret = GlobalConfig.consumer_secret;
  String requestPath = "wp-json/wc/v3/";
  String url = GlobalConfig.baseUrl;
  String consumerKey = GlobalConfig.consumer_key;
  String consumerSecret = GlobalConfig.consumer_secret;
  bool isHttps = !GlobalConfig.isDebug;

  _getOAuthURL(String request_method, String endpoint) {
    var consumerKey = this.clientKey;
    var consumerSecret = this.clientSecret;

    var token = "";
    var token_secret = "";
    var url = this.wooCommerceUrl + requestPath + endpoint;
    var containsQueryParams = url.contains("?");

    // If website is HTTPS based, no need for OAuth, just return the URL with CS and CK as query params
    if (this.isHttps == true) {
      return url +
          (containsQueryParams == true
              ? "&consumer_key=" +
                  this.consumerKey +
                  "&consumer_secret=" +
                  this.consumerSecret
              : "?consumer_key=" +
                  this.consumerKey +
                  "&consumer_secret=" +
                  this.consumerSecret);
    }

    var rand = new Random();
    var codeUnits = new List.generate(10, (index) {
      return rand.nextInt(26) + 97;
    });

    var nonce = new String.fromCharCodes(codeUnits);
    int timestamp = (new DateTime.now().millisecondsSinceEpoch / 1000).toInt();

    //print(timestamp);
    //print(nonce);

    var method = request_method;
    var path = url.split("?")[0];
    var parameters = "oauth_consumer_key=" +
        consumerKey +
        "&oauth_nonce=" +
        nonce +
        "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=" +
        timestamp.toString() +
        "&oauth_token=" +
        token +
        "&oauth_version=1.0&";

    if (containsQueryParams == true) {
      parameters = parameters + url.split("?")[1];
    } else {
      parameters = parameters.substring(0, parameters.length - 1);
    }

    Map<dynamic, dynamic> params = QueryString.parse(parameters);
    Map<dynamic, dynamic> treeMap = new SplayTreeMap<dynamic, dynamic>();
    treeMap.addAll(params);

    String parameterString = "";

    for (var key in treeMap.keys) {
      parameterString = parameterString +
          Uri.encodeQueryComponent(key) +
          "=" +
          treeMap[key] +
          "&";
    }

    parameterString = parameterString.substring(0, parameterString.length - 1);

    var baseString = method +
        "&" +
        Uri.encodeQueryComponent(
            containsQueryParams == true ? url.split("?")[0] : url) +
        "&" +
        Uri.encodeQueryComponent(parameterString);

    //print(baseString);

    var signingKey = consumerSecret + "&" + token;
    //print(signingKey);
    //print(UTF8.encode(signingKey));
    var hmacSha1 =
        new crypto.Hmac(crypto.sha1, utf8.encode(signingKey)); // HMAC-SHA1
    var signature = hmacSha1.convert(utf8.encode(baseString));

    //print(signature);

    var finalSignature = base64Encode(signature.bytes);
    //print(finalSignature);

    var requestUrl = "";

    if (containsQueryParams == true) {
      //print(url.split("?")[0] + "?" + parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature));
      requestUrl = url.split("?")[0] +
          "?" +
          parameterString +
          "&oauth_signature=" +
          Uri.encodeQueryComponent(finalSignature);
    } else {
      //print(url + "?" +  parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature));
      requestUrl = url +
          "?" +
          parameterString +
          "&oauth_signature=" +
          Uri.encodeQueryComponent(finalSignature);
    }
    print(requestUrl);
    return requestUrl;
  }

  //在 Dart 里，带下划线开头的变量是私有变量
  static WooCommerceConfig _instance;

  static WooCommerceConfig getInstance() {
    if (_instance == null) {
      _instance = WooCommerceConfig();
    }
    return _instance;
  }

  String _buildRequestUrl(String endPoint, [var queryAt]) {
    String requestUrl;
    if (queryAt == null) {
      requestUrl = '$wooCommerceUrl'
          '$requestPath$endPoint?consumer_key='
          '$clientKey&consumer_secret=$clientSecret';
    } else {
      requestUrl = '$wooCommerceUrl'
          '$requestPath$endPoint/$queryAt?consumer_key='
          '$clientKey&consumer_secret=$clientSecret';
    }

    return requestUrl;
  }

  String _buildDeleteRequestUrl(String endPoint, [var queryAt]) {
    String requestUrl;
    print(queryAt);
    if (queryAt == null) {
      requestUrl = '$wooCommerceUrl'
          '$requestPath$endPoint?force=true&consumer_key='
          '$clientKey&consumer_secret=$clientSecret';
    } else {
      requestUrl = '$wooCommerceUrl'
          '$requestPath$endPoint/$queryAt?force=true&consumer_key='
          '$clientKey&consumer_secret=$clientSecret';
    }

    print(requestUrl);
    return requestUrl;
  }

  Map<String, String> _buildRequestHeader() {
    var header = {
      "cache-control": "no-cache",
      "Content-Type": "application/json",
    };
    return header;
  }

  ///Used to make a get request to woocommerce
  ///with respect to specific endpoints to get from
  ///
  Future getDataAsync(
      {@required String endPoint,
      @required Function success,
      @required Function error}) async {
    var client = http.Client();
    var url = _getOAuthURL("GET", endPoint);
    var response = await client.get(
      url,
      headers: _buildRequestHeader(),
    );
    LogUtil.logI("WooCommerceConfig", "url:" + url);
    LogUtil.logI("WooCommerceConfig", "data:" + response.body.toString());
    if (response.statusCode == 200) {
      var body = response.body;

      if (body.startsWith("[") && body.endsWith("]")) {
        Map<String, dynamic> map = new HashMap();
        List list = json.decode(body);
        map["data"] = list;
        success(map);
      } else {
        Map<String, dynamic> dataMap = json.decode(body);
        if (dataMap == null || dataMap['state'] == 0) {
          LogUtil.logE("WooCommerceConfig", "错误");
          error();
        } else if (success != null) {
          success(dataMap);
        }
      }
    } else {
      LogUtil.logE("WooCommerceConfig", "服务器异常");
      error("服务器异常");
    }
  }

  ///Used to make a post request to woocommerce
  ///with respect to specific endpoints to post to
  ///with respect to payload[the data to add]
//  postDataAsync(
//      {@required String endPoint,
//      @required var payLoad,
//      @required Function success,
//      @required Function error}) async {
//    try {
//      var client = http.Client();
//      var response = await client.post(
//          Uri.encodeFull(_getOAuthURL("POST", endPoint)),
//          headers: _buildRequestHeader(),
//          body: jsonEncode(payLoad));
//      print(jsonDecode(response.body));
//      if (response.statusCode == 200) {
////          String dataStr = json.encode(response.body);
//        Map<String, dynamic> dataMap = json.decode(response.body);
//        if (dataMap == null || dataMap['state'] == 0) {
//          error();
//        } else if (success != null) {
//          success(dataMap);
//        }
//      } else {
//        error("服务器异常");
//      }
//    } catch (e) {
//      error(e);
//    }
//  }
  postDataAsync(
      {@required String endPoint,
      @required var queryAtId,
      @required var payLoad,
      @required Function success,
      @required Function error}) async {
    endPoint = endPoint + (queryAtId != null ? "/" + queryAtId : "");
    var url = this._getOAuthURL("POST", endPoint);
    var client = new http.Client();
    var request = new http.Request('POST', Uri.parse(url));
    request.headers[HttpHeaders.contentTypeHeader] =
        'application/json; charset=utf-8';
    request.headers[HttpHeaders.cacheControlHeader] = "no-cache";
//    request.body = json.encode(payLoad);
    request.body = json.encode(payLoad);
    LogUtil.logI("WooCommerceConfig", "url:" + url);
    var response = await client.send(request).then((res) {
      return res.stream.transform(utf8.decoder).join().then((String str) {
        return str;
      });
    });

    if (response != null) {
      Map<String, dynamic> dataMap = json.decode(response);
      if (dataMap == null || dataMap['state'] == 0) {
        error();
      } else if (success != null) {
        success(dataMap);
      }
    }
  }

  ///Used to make a get request to woocommerce
  ///with respect to specific endpoints to update
  ///with respect to payload[the data to update]
  ///with respect to queryAt[the path to update]
//  putDataAsync(
//      {@required String endPoint,
//      @required var queryAtId,
//      @required var payLoad,
//      @required Function success,
//      @required Function error}) async {
//    var client = http.Client();
//    String s = jsonEncode(payLoad);
//    try {
//      var response = await client.put(
//          Uri.encodeFull(_getOAuthURL("POST", endPoint + "/" + queryAtId)),
//          headers: _buildRequestHeader(),
//          body: s);
//      print(jsonDecode(response.body));
//      if (response.statusCode == 200) {
////          String dataStr = json.encode(response.body);
//        Map<String, dynamic> dataMap = json.decode(response.body);
//        if (dataMap == null || dataMap['state'] == 0) {
//          error();
//        } else if (success != null) {
//          success(dataMap);
//        }
//      } else {
//        error("服务器异常");
//      }
//    } catch (e) {
//      error(e);
//    }
//  }
  putDataAsync(
      {@required String endPoint,
      @required var queryAtId,
      @required var payLoad,
      @required Function success,
      @required Function error}) async {
    var url = this._getOAuthURL("PUT", endPoint + "/" + queryAtId);
    var client = new http.Client();
    var request = new http.Request('PUT', Uri.parse(url));
    request.headers[HttpHeaders.contentTypeHeader] =
        'application/json; charset=utf-8';
    request.headers[HttpHeaders.cacheControlHeader] = "no-cache";
    request.body = json.encode(payLoad);
    var response =
        await client.send(request).then((res) => res.stream.bytesToString());
    var dataResponse = await json.decode(response);
    print(dataResponse);
    if (dataResponse == null) {
      error();
    } else if (success != null) {
      success(dataResponse);
    }
  }

  ///Used to make a get request to woocommerce
  ///with respect to specific endpoints to delete from
  ///with respect to queryAt[the path to delete]
   deleteDataAsync(
      {@required String endPoint, @required var queryAtId,@required Function success,
        @required Function error}) async {
     var url = this._getOAuthURL("DELETE", endPoint);
     var client = new http.Client();
     var request = new http.Request('DELETE', Uri.parse(url));
     request.headers[HttpHeaders.contentTypeHeader] =
     'application/json; charset=utf-8';
     request.headers[HttpHeaders.cacheControlHeader] = "no-cache";
     var response =
     await client.send(request).then((res) => res.stream.bytesToString());
     var dataResponse = await json.decode(response);
     print(dataResponse);
     if (dataResponse == null) {
       error();
     } else if (success != null) {
       success(dataResponse);
     }
  }
}
