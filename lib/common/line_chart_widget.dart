import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/parameter_con.dart';

class LineChartWidget extends StatefulWidget {
  final Map<int, List<FlSpot>> lineChartData;
  const LineChartWidget({
    Key? key,
    required this.lineChartData,
  }) : super(key: key);
  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  final parameterCon = Get.put(ParameterCon());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
          //? 是否可以点击
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots
                    .map(
                      (e) => LineTooltipItem(
                        e.x.toString() + e.y.toString(),
                        TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                    .toList();
              },
            ),
          ),
          //? 网格线配置
          gridData: FlGridData(
            show: false,
          ),
          // axisTitleData: _buildFlAxisTitleData(),

          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 100.w,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(2),
                    style: TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(2),
                    style: TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(),
            topTitles: AxisTitles(),
          ),

          //? 边框
          borderData: FlBorderData(
              show: true,
              border: Border(
                left: BorderSide(
                  color: Get.theme.hintColor,
                ),
                bottom: BorderSide(
                  color: Get.theme.hintColor,
                ),
              )),

          ///坐标轴

          minX: 0,
          // maxX: 14,
          // maxY: 7,
          minY: 0,
          showingTooltipIndicators: [],
          //图表要展示的线的数组，数组的每一位代表一条线。
          lineBarsData: getLineBarsData()
          // [
          //   LineChartBarData(
          //     spots: [
          //       FlSpot(0, 1),
          //       FlSpot(1, 2),
          //       FlSpot(2, 3),
          //       FlSpot(3, 4),
          //       FlSpot(4, 5),
          //       FlSpot(5, 6),
          //       FlSpot(6, 2),
          //       FlSpot(7, 5),
          //       FlSpot(8, 4),
          //       FlSpot(9, 2),
          //       FlSpot(10, 4),
          //       FlSpot(11, 2),
          //     ],
          //     color: Colors.red,

          //     dotData: FlDotData(
          //       show: false,
          //     ),
          //     isStrokeCapRound: false,
          //     //? 是否显示线下区域
          //     belowBarData:
          //         BarAreaData(show: true, color: Colors.red.withAlpha(50)),

          //     ///是否是曲线
          //     isCurved: true,
          //   ),
          //   LineChartBarData(
          //     color: Colors.green,
          //     dotData: FlDotData(
          //       show: false,
          //     ),
          //     showingIndicators: [1, 1],
          //     spots: [
          //       FlSpot(2, 2),
          //       FlSpot(5, 5),
          //       FlSpot(5, 5),
          //       FlSpot(6, 5),
          //       FlSpot(7, 5),
          //       FlSpot(8, 5),
          //       FlSpot(9, 5),
          //     ],
          //     belowBarData:
          //         BarAreaData(show: true, color: Colors.green.withAlpha(50)),
          //   )
          // ],
          ),
      swapAnimationDuration: Duration(milliseconds: 150), // Optional
      swapAnimationCurve: Curves.linear, // Optional
    );
  }

  LineChartBarData lineChartBarData({
    required List<FlSpot> spots,
    required Color color,
  }) {
    return LineChartBarData(
      spots: spots,
      color: color,
      dotData: FlDotData(
        show: false,
      ),

      //? 是否显示线下区域
      belowBarData: BarAreaData(show: true, color: color.withAlpha(50)),

      ///是否是曲线
      isCurved: true,
    );
  }

  List<LineChartBarData> getLineBarsData() {
    List<LineChartBarData> ls = [];
    widget.lineChartData.forEach((key, value) {
      if (parameterCon.real_time_data_select.contains(key)) {
        ls.add(
          LineChartBarData(
            spots: value,
            color: parameterCon.real_time_data_color[key],

            dotData: FlDotData(
              show: false,
            ),
            isStrokeCapRound: false,
            //? 是否显示线下区域
            belowBarData: BarAreaData(
                show: true,
                color: parameterCon.real_time_data_color[key]!.withAlpha(50)),

            ///是否是曲线
            isCurved: false,
          ),
        );
      }
    });

    return ls;
  }
}
