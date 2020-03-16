class Config {
  ///首页分类接口
  static const MAIN_CLASSIFY_URL = "wp-json/user/v1/getCategoriesList";

  ///首页banner和广告位接口
  static const MAIN_BANNER_ADS = "wp-json/user/v1/getIndexAd";

  ///获取首页最新商品列表和相关分类列表接口
  static const MAIN_NEW_PRODUCT_TITLE = "wp-json/user/v1/recommendCategory";

  //商品相关接口
  static const COMMODITY_DETAILS_URL = "/wc-api/v3/products/";

//  //商品列表
//  static const PRODUCTS_LIST = "/wc-api/v3/products/";
  ///注册接口
  static const REGISTER = "wp-json/user/v1/createNewCustomer";

  ///登陆接口
  static const LOGIN = "wp-json/user/v1/customerLogin";

  ///获取验证码接口
  static const SEND_CODE = "wp-json/send/v1/appSendMsmCode";

  ///发送邮件验证码接口
  static const SEND_EMAIL_CODE = "wp-json/user/v1/sendEmailCode";

  ///发送手机找回密码验证码接口
  static const SEND_FORGET_CODE = "wp-json/send/v1/sendForgetCode";

  ///修改密码接口
  static const RETRIEVE_PASSWORD = "wp-json/user/v1/RetrievePassword";

  ///找回密码检查验证码接口
  static const CHECK_CODE = "wp-json/user/v1/judgeCode";

  ///分销员基本信息接口
  static const DISTRIBUTION_USER = "Api/User/get_user_info";

  ///列出所有订单接口
  static const LIST_ALL_ORDERS = "wp-json/wc/v3/orders";

  ///列出所以产品接口
  static const LIST_ALL_PRODUCTS = "wc-api/v3/products";

  //购物车列表
  static const LIST_CAR_PRODUCTS = "wp-json/user/v1/cartList";

  //添加车列表
  static const ADD_TO_CAR_URL = "wp-json/user/v1/addCart";


  ///列出所有支付方式
  static const LIST_PAYMENT_WAYS = "wp-json/wc/v3/payment_gateways";



  //修改购物车数量
  static const UPDATE_TO_CAR_URL = "wp-json/user/v1/updateCart";
  //修改购物车数量
  static const DEL_TO_CAR_URL = "wp-json/user/v1/delCart";
  ///分销编辑银行卡
  static const DIS_EDIT_BANK_CARD = "Api/User/edit_bank";
  ///获取银卡列表信息
  static const DIS_GET_BANK_LIST = "Api/User/bank_list";
  ///添加银行卡
  static const DIS_ADD_BANK = "Api/User/add_bank";
  ///发送验证码
  static const DIS_SEND_SMS = "Api/User/send_sms";
  ///申请提现
  static const DIS_GET_CASH = "Api/User/get_cash";
  ///获取银行转账账号
  static const GET_BANK = "wp-json/user/v1/getBank";
  ///分销员下线列表接口
  static const MY_CHILDREN_USER_URL = "Api/User/my_children";
  ///获取分销商品列表接口
  static const DISTRIBUTION_GOODS_LIST_URL = "wp-json/user/v1/getProductListCommission";
  ///分销贡献值明细
  static const DISTRIBUTION_GOODS_CONTRIBUTION_LISTR_URL = "Api/User/contribution_list";
  ///分销员佣金明细
  static const DISTRIBUTION_RECORD_MONEY_LIST_URL = "Api/User/record_money_list";
  ///在线支付接口
  static const SEND_PAY = "wp-json/user/v1/sendPayNew";


}
