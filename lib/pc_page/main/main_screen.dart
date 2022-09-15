import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:kelly_user_project/common/get_box.dart';
import 'package:kelly_user_project/config/config.dart';

import 'package:kelly_user_project/controller/menu_controller.dart';
import 'package:kelly_user_project/pc_page/connect/connection.dart';

import 'package:kelly_user_project/pc_page/data_visualization/visualization.dart';
import 'package:kelly_user_project/pc_page/firmware/firmware.dart';
import 'package:kelly_user_project/pc_page/main/left_menu.dart';
import 'package:kelly_user_project/pc_page/monitor_control/monitor_page.dart';

import 'package:kelly_user_project/pc_page/parameters/parameter_page.dart';
import 'package:kelly_user_project/pc_page/user_app_setting/setting.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final menuController = Get.put(MenuController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/theme${box.read("theme")}/main_bg.png',
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            children: [
              _mainWidget(),
              _leftWidget(),
              _topWidget(),
              _bottomWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainWidget() {
    return Obx(
      () => Positioned(
        top: 0,
        left: 0,
        bottom: 0,
        right: 0,
        child: _indexWidget(),
      ),
    );
  }

  Widget _leftWidget() {
    return Positioned(
      top: 0,
      left: 0,
      bottom: 0,
      child: Container(
        width: Config.left_menu_margin,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/theme${box.read("theme")}/left_bg.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
        padding: EdgeInsets.only(top: 100, left: 42),
        child: const LeftMenu(),
      ),
    );
  }

  Widget _topWidget() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 100,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/theme${box.read("theme")}/top_bg.png',
            ),
          ),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 20),
        child: Obx(
          () => Text(
            menuController.title[menuController.selectIndex.value],
            style: TextStyle(
              color: Get.theme.focusColor,
              fontSize: 29,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomWidget() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 100,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/theme${box.read("theme")}/bottom_bg.png',
            ),
          ),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 20, left: 450, right: 450),
        child: Obx(
          () => Row(
            children: bottomMenuList(),
          ),
        ),
      ),
    );
  }

  Widget _indexWidget() {
    switch (menuController.selectIndex.value) {
      case 0:
        return Container();
      case 1:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Connection(),
        );

      case 2:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 100),
          child: ParameterPage(),
        );
      case 3:
        return const Padding(
          padding: EdgeInsets.only(bottom: 100),
          child: MonitorPage(),
        );
      case 4:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Visualization(),
        );
      case 5:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Firmware(),
        );
      case 6:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Setting(),
        );
      default:
        return Container();
    }
  }

  List<Widget> bottomMenuList() {
    switch (menuController.selectIndex.value) {
      case 0:
        return [];
      case 1:
        return [
          bottomMenuItem('Serial', 0),
          bottomMenuItem('Bluetooth', 1),
          bottomMenuItem('X', 2),
          bottomMenuItem('Y', 3),
        ];
      case 2:
        return [
          bottomMenuItem(
            'Read file',
            -1,
            indexTap: () {
              print('Read file');
            },
          ),
          bottomMenuItem(
            'Write file',
            -1,
            indexTap: () {
              print('Write file');
            },
          ),
          bottomMenuItem(
            'Modify',
            -1,
            indexTap: () {
              print('Modify');
            },
          ),
        ];
      case 3:
        return [
          bottomMenuItem('Primary', 0),
          bottomMenuItem('Advanced', 1),
          bottomMenuItem('Specialized', 2),
          bottomMenuItem('Test Monitoring', 3),
        ];
      case 4:
        return [
          bottomMenuItem('X', 0),
          bottomMenuItem('Y', 1),
          bottomMenuItem('Z', 2),
        ];
      case 5:
        return [];
      case 6:
        return [];
      default:
        return [];
    }
  }

  Widget bottomMenuItem(
    String title,
    int index, {
    VoidCallback? indexTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (indexTap != null) {
            indexTap();
          }
          if (menuController.selectIndex.value != 2) {
            if (menuController.bottomMenuIndex.value != index) {
              menuController.bottomMenuIndex.value = index;
            }
          }
        },
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 22,
              color: menuController.bottomMenuIndex.value == index
                  ? Get.theme.focusColor
                  : Get.theme.hintColor,
              fontWeight: menuController.bottomMenuIndex.value == index
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
