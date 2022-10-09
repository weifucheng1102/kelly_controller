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

class Visualization extends StatefulWidget {
  const Visualization({Key? key}) : super(key: key);

  @override
  State<Visualization> createState() => _VisualizationState();
}

class _VisualizationState extends State<Visualization> {
  @override
  void initState() {
    super.initState();
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
            child: LineChartWidget(),
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
