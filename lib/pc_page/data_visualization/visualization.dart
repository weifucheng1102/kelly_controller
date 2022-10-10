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

import '../../common/common.dart';
import '../../controller/connection_con.dart';

class Visualization extends StatefulWidget {
  const Visualization({Key? key}) : super(key: key);

  @override
  State<Visualization> createState() => _VisualizationState();
}

class _VisualizationState extends State<Visualization> {
  List<Color> colorList = [];
  List<List<FlSpot>> linechartData = [];

  Timer? timer;
  final connectionCon = Get.put(ConnectionCon());
  @override
  void initState() {
    bus.on('updateControl', (arg) {
      print(arg);
      Uint8List list = arg;

      ///随机颜色
      if (colorList.isEmpty) {
        colorList = List.generate(
          list.length,
          (index) => Color.fromRGBO(
            Random().nextInt(256),
            Random().nextInt(256),
            Random().nextInt(256),
            1,
          ),
        );
      }

      

      // dashValueChange(list.first, secondDashValue);

      // ///第5位 前进开关   第6位 后退开关
      // getGearData(list[4], list[5]);
    });
    super.initState();

    ///发送指令 每100ms 发送一次
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if (connectionCon.port != null) {
        ///发送指令
        connectionCon.port!.write(
            Uint8List.fromList(
                [hexToInt('63'), hexToInt('00'), hexToInt('63')]),
            timeout: 0);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    bus.off('updateControl');
    bus.off('control');
    if (timer != null) {
      timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Config.left_menu_margin),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            height: 50,
            width: 100,
            color: Colors.red,
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: LineChartWidget(
              colorList: colorList,
              lineChartData: [],
            ),
          ),
          FilterButton(
            voidCallback: () {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
