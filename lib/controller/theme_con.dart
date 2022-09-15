import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/get_box.dart';
import '../config/themes.dart';

class ThemeCon extends GetxController {
  RxInt selectTheme = 0.obs;

  ///更换主题
  updateTheme(ThemeData theme) {
    Get.changeTheme(theme);
    box.write('theme', Themes.themeList.indexOf(theme));
    Future.delayed(const Duration(seconds: 1), () {
      Get.forceAppUpdate();
    });
  }
}
