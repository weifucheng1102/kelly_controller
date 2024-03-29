import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:kelly_user_project/common/common.dart';
import 'package:kelly_user_project/common/get_box.dart';
import 'package:kelly_user_project/config/config.dart';
import 'package:kelly_user_project/config/event.dart';
import 'package:kelly_user_project/controller/connection_con.dart';

import 'package:kelly_user_project/controller/menu_controller.dart';
import 'package:kelly_user_project/controller/parameter_con.dart';
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
  final parameterController = Get.put(ParameterCon());
  final connectionCon = Get.put(ConnectionCon());
  double barHeight() => 100.h;

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
        left: 0,
        bottom: barHeight(),
        right: 0,
        top: 0,
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
        width: left_menu_margin(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/theme${box.read("theme")}/left_bg.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
        padding: EdgeInsets.only(top: barHeight(), left: 42.w),
        child: const LeftMenu(),
      ),
    );
  }

  Widget _topWidget() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: barHeight(),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/theme${box.read("theme")}/top_bg.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 20.h),
        child: Obx(
          () => Text(
            menuController.title[menuController.selectIndex.value],
            style: TextStyle(
              color: Get.theme.focusColor,
              fontSize: 29.sp,
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
      height: barHeight(),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/theme${box.read("theme")}/bottom_bg.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 20.h, left: 450.w, right: 450.w),
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
        return Padding(
          padding: EdgeInsets.only(top: barHeight()),
          child: Connection(),
        );

      case 2:
        return Padding(
          padding: EdgeInsets.only(top: barHeight()),
          child: ParameterPage(),
        );
      case 3:
        return MonitorPage();
      case 4:
        return Padding(
          padding: EdgeInsets.only(top: barHeight()),
          child: Visualization(),
        );
      case 5:
        return Padding(
          padding: EdgeInsets.only(top: barHeight()),
          child: Firmware(),
        );
      case 6:
        return Setting();
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
          //  bottomMenuItem('Serial', 0),
          // bottomMenuItem('Bluetooth', 1),
          // bottomMenuItem('X', 2),
          // bottomMenuItem('Y', 3),
        ];
      case 2:
        return [
          bottomMenuItem(
            'Read file',
            -1,
            indexTap: () async {
              ///读文件

              await parameterController.parameterReadFile();
            },
          ),
          bottomMenuItem(
            'Write file',
            -1,
            indexTap: () {
              parameterController.writeFile(context);
            },
          ),
          bottomMenuItem(
            'Modify',
            -1,
            indexTap: () {
              // List list = parameterController.all_parameter_value.values
              //     .toList()
              //     .sublist(0, 2);
              // List<int> intList = List.generate(
              //     list.length, (index) => int.parse(list[index].toString()));

              // intList.insertAll(0, [
              //   hexToInt('62'),
              //   hexToInt('02'),
              // ]);
              // int sum = 0;

              // intList.forEach((element) {
              //   sum = sum + element;
              // });
              // print(sum);
              // intList.add(sum);

              ///参数数据写入电机
              connectionCon.sendParameterSaveInstruct(257);
            },
          ),
        ];
      case 3:
        return [
          bottomMenuItem('Primary', 0),
          bottomMenuItem('Advanced', 1),
          bottomMenuItem('Test Monitoring', 2),
        ];
      case 4:
        return [
          // bottomMenuItem('X', 0),
          // bottomMenuItem('Y', 1),
          // bottomMenuItem('Z', 2),
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
              fontSize: 22.sp,
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
