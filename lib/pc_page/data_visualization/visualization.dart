import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:extended_wrap/extended_wrap.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:kelly_user_project/common/custom_button.dart';
import 'package:kelly_user_project/common/custom_dialog.dart';
import 'package:kelly_user_project/common/filter_button.dart';
import 'package:kelly_user_project/common/get_box.dart';
import 'package:kelly_user_project/common/line_chart_widget.dart';
import 'package:kelly_user_project/config/config.dart';
import 'package:kelly_user_project/common/filter_view.dart';
import 'package:kelly_user_project/config/event.dart';
import 'package:kelly_user_project/controller/parameter_con.dart';
import 'package:kelly_user_project/models/parameter.dart';
import 'package:kelly_user_project/pc_page/data_visualization/real_time_data_filter.dart';

import '../../common/common.dart';
import '../../controller/connection_con.dart';

class Visualization extends StatefulWidget {
  const Visualization({Key? key}) : super(key: key);

  @override
  State<Visualization> createState() => _VisualizationState();
}

class _VisualizationState extends State<Visualization> {
  Map<int, List<FlSpot>> linechartData = {};

  Timer? timer;
  final connectionCon = Get.put(ConnectionCon());
  final parameterCon = Get.put(ParameterCon());

  @override
  void initState() {
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
  void dispose() {
    super.dispose();
    bus.off('updateRealParameter');
    if (timer != null) {
      timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: left_menu_margin()),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20.w,
            runSpacing: 20.w,
            children: wrapList(),
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: LineChartWidget(
              lineChartData: linechartData,
            ),
          ),
          FilterButton(
            voidCallback: () {
              CustomDialog.showCustomDialog(
                context,
                child: RealTimeDataFilter(
                  selectids: parameterCon.real_time_data_select,
                  voidCallback: () {
                    setState(() {});
                  },
                ),
              );
            },
          ),
        ],
      ),
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
                fontSize: 20.sp,
                color: Get.theme.hintColor,
              ),
            ),
            WidgetSpan(
              child: Container(
                margin: EdgeInsets.only(left: 5.w),
                width: 20.w,
                height: 20.w,
                color: parameterCon.real_time_data_color[parameter.motId],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
