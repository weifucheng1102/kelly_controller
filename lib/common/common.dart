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
