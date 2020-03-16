class LogUtil {
  static bool isDug = true;

  static logD(String className, String msg) {
    if (isDug) print("${className} Debug ======== ${msg}");
  }

  static logI(String className, String msg) {
    if (isDug)print("${className} Info ======== ${msg}");
  }

  static logE(String className, String msg) {
    if (isDug) print("${className} Error ======== ${msg}");
  }
}
