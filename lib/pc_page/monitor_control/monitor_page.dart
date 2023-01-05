import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/controller/menu_controller.dart';
import 'package:kelly_user_project/pc_page/monitor_control/monitor_control.dart';
import 'package:kelly_user_project/pc_page/monitor_control/test_monitoring.dart';

class MonitorPage extends StatefulWidget {
  const MonitorPage({Key? key}) : super(key: key);

  @override
  State<MonitorPage> createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> {
  final menuController = Get.put(MenuController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => menuController.bottomMenuIndex.value == 2
          ? const TestMonitoring()
          : MonitorControl(index: menuController.bottomMenuIndex.value),
    );
  }
}
