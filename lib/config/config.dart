import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:kelly_user_project/common/common.dart';

class Config {
  ///档位
  static List<String> gearList = ['R', 'N', 'D'];

  ///油门
  static double acceleratorMax = 100;
  static double acceleratorMin = -100;
}

double left_menu_margin() => 320.w;

double buttonWidth() => 165.w;
double buttonHeight() => 64.h;

double mobileButtonWidth() => 127;
double mobileButtonHeight() => 35;
