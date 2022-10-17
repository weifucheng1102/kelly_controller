import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/config/config.dart';

import 'package:kelly_user_project/controller/menu_controller.dart';
import 'package:kelly_user_project/pc_page/connect/bluetooth.dart';

import 'serial.dart';

class Connection extends StatefulWidget {
  const Connection({Key? key}) : super(key: key);

  @override
  State<Connection> createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {
  final menuController = Get.put(MenuController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 320.w, vertical: 40.h),
      child: Obx(
        () =>
            menuController.bottomMenuIndex.value == 0 ? Serial() : Bluetooth(),
      ),
    );
  }
}
