import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/app_bar_mobile.dart';
import 'package:kelly_user_project/common/common.dart';
import 'package:kelly_user_project/common/top_tabbar_item_mobile.dart';
import 'package:kelly_user_project/controller/menu_controller.dart';
import 'package:kelly_user_project/mobile_page/connect/bluetooth_mobile.dart';
import 'package:kelly_user_project/mobile_page/connect/serial_mobile.dart';
import 'package:kelly_user_project/pc_page/connect/bluetooth.dart';

class ConnectMobile extends StatefulWidget {
  const ConnectMobile({Key? key}) : super(key: key);

  @override
  State<ConnectMobile> createState() => _ConnectMobileState();
}

class _ConnectMobileState extends State<ConnectMobile> {
  final menuController = Get.put(MenuController());
  @override
  void initState() {
    super.initState();
    menuController.bottomMenuIndex.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: isLandScape() ? const AppBarMobile(title: 'Connection') : null,
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              tabbarWidget(),
              Expanded(
                child: menuController.bottomMenuIndex.value == 0
                    ? BluetoothMobile()
                    : Container(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget tabbarWidget() {
    return Row(
      children: const [
        // Expanded(
        //   child: TopTabbarItemMobile('Serial', 0),
        // ),
        Expanded(
          child: TopTabbarItemMobile('Bluetooth', 0),
        ),
        Expanded(
          child: TopTabbarItemMobile('X', 1),
        ),
        Expanded(
          child: TopTabbarItemMobile('Y', 2),
        ),
      ],
    );
  }
}
