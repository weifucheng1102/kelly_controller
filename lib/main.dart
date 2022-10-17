import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kelly_user_project/common/get_box.dart';
import 'package:kelly_user_project/common/nav_key.dart';
import 'package:kelly_user_project/config/themes.dart';
import 'package:kelly_user_project/controller/parameter_con.dart';
import 'package:kelly_user_project/controller/theme_con.dart';
import 'package:kelly_user_project/mobile_page/main/index_mobile.dart';
import 'package:kelly_user_project/pc_page/main/main_screen.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  if (GetPlatform.isDesktop) {
    // 必须加上这一行。
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.normal,
        minimumSize: Size(1080, 640));

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final themeCon = Get.put(ThemeCon());
  final parameterCon = Get.put(ParameterCon());
  @override
  void initState() {
    super.initState();
    if (box.read('theme') == null) box.write('theme', 0);
    themeCon.updateTheme(Themes.themeList[box.read('theme')]);
    parameterCon.getPropertyFromJson();
    parameterCon.getParameterFromJson();
  }

  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isDesktop) {
      return ScreenUtilInit(
        designSize: const Size(1920, 1080),
        builder: (context, index) => GetMaterialApp(
          navigatorKey: NavKey.navKey,
          theme: Get.theme,
          themeMode: ThemeMode.light,
          home: const MainScreen(),
        ),
      );
    } else {
      return ScreenUtilInit(
        designSize: const Size(750, 1334),
        builder: (context, index) => GetMaterialApp(
          navigatorKey: NavKey.navKey,
          theme: Get.theme,
          themeMode: ThemeMode.light,
          home: IndexMobile(),
        ),
      );
    }
  }
}
