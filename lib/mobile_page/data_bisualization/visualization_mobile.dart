import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
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
import 'package:kelly_user_project/config/event.dart';
import 'package:kelly_user_project/controller/menu_controller.dart';
import 'package:kelly_user_project/controller/parameter_con.dart';
import 'package:kelly_user_project/mobile_page/connect/serial_mobile.dart';
import 'package:kelly_user_project/mobile_page/data_bisualization/real_time_data_filter_mobile.dart';
import 'package:kelly_user_project/models/parameter.dart';

import '../../controller/connection_con.dart';

class VisualizationMobile extends StatefulWidget {
  const VisualizationMobile({Key? key}) : super(key: key);

  @override
  State<VisualizationMobile> createState() => _VisualizationMobileState();
}

class _VisualizationMobileState extends State<VisualizationMobile> {
  Map<int, List<FlSpot>> linechartData = {};
  Timer? timer;

  final menuController = Get.put(MenuController());
  final parameterCon = Get.put(ParameterCon());
  final connectionCon = Get.put(ConnectionCon());
  @override
  void dispose() {
    super.dispose();
    bus.off('updateRealParameter');
    if (timer != null) {
      timer!.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    menuController.bottomMenuIndex.value = 0;
    parameterCon.real_time_data_list.forEach((element) {
      linechartData.addAll({
        element.motId: [FlSpot(0, 0)]
      });
      setState(() {});
    });
    bus.on('updateRealParameter', (arg) {
      print(arg);

      ///修改id 为 257 的值
      updateFlspotDate(257, arg);
    });
    super.initState();

    ///发送指令 每1000ms 发送一次
    timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (connectionCon.port != null) {
        ///发送指令
        connectionCon.sendParameterInstruct(257);
      }
    });
  }

  ///更新数据
  updateFlspotDate(int id, int value) {
    if (linechartData.containsKey(id)) {
      List<FlSpot>? flspotList = linechartData[id];
      int length = flspotList!.length;
      flspotList.add(FlSpot(length.toDouble(), value.toDouble()));
      linechartData[id] = flspotList;
      print(linechartData);
      setState(() {});
    }
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
                    // tabbarWidget(),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: wrapList(),
                    ),
                    menuController.bottomMenuIndex.value == 0
                        ? isLandScape()
                            ? Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(20.w),
                                  child: LineChartWidget(
                                    lineChartData: linechartData,
                                  ),
                                ),
                              )
                            : Container(
                                height: 1.sw,
                                width: 1.sw,
                                padding: EdgeInsets.all(20.w),
                                child: LineChartWidget(
                                  lineChartData: linechartData,
                                ),
                              )
                        : Container(),
                  ],
                ),
              ),
              RealTimeDataFilterMobile(
                selectids: parameterCon.real_time_data_select,
                voidCallback: () {
                  setState(() {});
                },
              ),
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

  List<Widget> wrapList() {
    List<Widget> list = [];
    parameterCon.real_time_data_list.forEach((element) {
      if (parameterCon.real_time_data_select.contains(element.motId)) {
        list.add(wrapItem(element));
      }
    });
    return list;
  }

  Widget wrapItem(Parameter parameter) {
    return Container(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: parameter.parmName,
              style: TextStyle(
                fontSize: 12,
                color: Get.theme.hintColor,
              ),
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Container(
                margin: EdgeInsets.only(left: 5.w),
                width: 10,
                height: 10,
                color: parameterCon.real_time_data_color[parameter.motId],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
