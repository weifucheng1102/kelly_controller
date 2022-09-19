import 'package:flutter_screenutil/flutter_screenutil.dart';

///横屏
bool isLandScape() {
  return 1.sw > 1.sh;
}

///竖屏
bool isportiait() {
  return 1.sh > 1.sw;
}

///获取移动端左侧距离
double getMobileLeftMargin() {
  return isLandScape() ? 1.sw / 4 : 0;
}


///16进制转10进制
 int hexToInt(String hex) {
    int val = 0;
    int len = hex.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = hex.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("Invalid hexadecimal value");
      }
    }
    return val;
  }