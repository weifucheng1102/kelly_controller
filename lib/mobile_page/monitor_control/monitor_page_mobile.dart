import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/app_bar_mobile.dart';
import 'package:kelly_user_project/common/common.dart';
import 'package:kelly_user_project/common/top_tabbar_item_mobile.dart';
import 'package:kelly_user_project/controller/menu_controller.dart';
import 'package:kelly_user_project/mobile_page/monitor_control/monitor_control_mobile.dart';
import 'package:kelly_user_project/mobile_page/monitor_control/test_monitoring_mobile.dart';

class MonitorPageMobile extends StatefulWidget {
  const MonitorPageMobile({Key? key}) : super(key: key);

  @override
  State<MonitorPageMobile> createState() => _MonitorPageMobileState();
}

class _MonitorPageMobileState extends State<MonitorPageMobile> {
  @override
  final menuController = Get.put(MenuController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: isLandScape()
          ? const AppBarMobile(
              title: 'Monitor Control',
            )
          : null,
      body: SafeArea(
          left: false,
          right: false,
          child: Obx(
            () => Column(
              children: [
                tabbarWidget(),
                Expanded(
                  child: menuController.bottomMenuIndex.value == 3
                      ? const TestMonitoringMobile()
                      : const MonitorControlMobile(),
                )
              ],
            ),
          )),
    );
  }

  Widget tabbarWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        TopTabbarItemMobile('Primary', 0),
        TopTabbarItemMobile('Advanced', 1),
        TopTabbarItemMobile('Specialized', 2),
        TopTabbarItemMobile('Test Monitoring', 3),
      ],
    );
  }
}
