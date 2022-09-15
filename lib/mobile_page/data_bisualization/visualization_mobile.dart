import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kelly_user_project/common/app_bar_mobile.dart';
import 'package:kelly_user_project/common/common.dart';
import 'package:kelly_user_project/common/filter_button.dart';
import 'package:kelly_user_project/common/filter_button_mobile.dart';
import 'package:kelly_user_project/common/line_chart_widget.dart';
import 'package:kelly_user_project/common/top_tabbar_item_mobile.dart';
import 'package:kelly_user_project/controller/menu_controller.dart';
import 'package:kelly_user_project/mobile_page/connect/serial_mobile.dart';

class VisualizationMobile extends StatefulWidget {
  const VisualizationMobile({Key? key}) : super(key: key);

  @override
  State<VisualizationMobile> createState() => _VisualizationMobileState();
}

class _VisualizationMobileState extends State<VisualizationMobile> {
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
      appBar: isLandScape()
          ? const AppBarMobile(title: 'Data Visualization')
          : null,
      body: SafeArea(
        left: false,
        right: false,
        child: Obx(
          () => Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    tabbarWidget(),
                    menuController.bottomMenuIndex.value == 0
                        ? isLandScape()
                            ? Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: LineChartWidget(),
                                ),
                              )
                            : Container(
                                height: 1.sw,
                                width: 1.sw,
                                padding: EdgeInsets.all(20),
                                child: LineChartWidget(),
                              )
                        : Container(),
                  ],
                ),
              ),
              FilterButtonMobile(),
            ],
          ),
        ),
      ),
    );
  }

  Widget tabbarWidget() {
    return Row(
      children: const [
        Expanded(
          child: TopTabbarItemMobile('X', 0),
        ),
        Expanded(
          child: TopTabbarItemMobile('Y', 1),
        ),
        Expanded(
          child: TopTabbarItemMobile('Z', 2),
        ),
      ],
    );
  }
}
