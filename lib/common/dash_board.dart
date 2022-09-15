import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:kelly_user_project/common/get_box.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DashBoard extends StatefulWidget {
  ///最小刻度
  final double minnum;

  ///最大刻度
  final double maxnum;

  ///大刻度间隔
  final double interval;

  ///尺寸
  final double size;

  ///底部widget
  final Widget? bottomWidget;

  ///底部widget padding
  final double bottomPadding;

  final Widget? centerWidget;

  ///仪表指针转动的刻度
  final double endValue;

  const DashBoard({
    Key? key,
    required this.minnum,
    required this.maxnum,
    required this.interval,
    required this.size,
    required this.endValue,
    this.bottomWidget,
    this.bottomPadding = 0,
    this.centerWidget,
  }) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  RxDouble ratio = 1.0.obs;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ratio.value = 384 / widget.size;
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(20 / ratio.value),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/theme${box.read("theme")}/board_around.png'),
                          fit: BoxFit.fill),
                    ),
                    child: SfRadialGauge(
                      enableLoadingAnimation: true,
                      animationDuration: 1000,
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: widget.minnum,
                          maximum: widget.maxnum,
                          labelOffset: 15 / ratio.value,
                          startAngle: 135,
                          endAngle: 45,
                          showLastLabel: true,
                          //useRangeColorForAxis: true,
                          offsetUnit: GaugeSizeUnit.logicalPixel,
                          // onAxisTapped: (a) {
                          //   aaa = a;
                          //   setState(() {});
                          // },

                          ///大刻度间隔
                          interval: widget.interval,

                          ///大刻度之间小刻度数量(4条线)
                          minorTicksPerInterval: 3,

                          ///刻度数字
                          axisLabelStyle: GaugeTextStyle(
                              color: Get.theme.highlightColor,
                              fontSize: 12 / ratio.value),

                          ///圆圈
                          axisLineStyle: AxisLineStyle(
                              color: Get.theme.dividerColor,
                              thickness: 10 / ratio.value),

                          ///大刻度
                          majorTickStyle: MajorTickStyle(
                            color: Get.theme.highlightColor,
                            thickness: 1,
                            length: 7 / ratio.value,
                          ),

                          ///小刻度
                          minorTickStyle: MinorTickStyle(
                            color: Get.theme.hintColor,
                            thickness: 0.5,
                            length: 7 / ratio.value,
                          ),

                          ///圆圈进度
                          ranges: <GaugeRange>[
                            GaugeRange(
                              startValue: 0,
                              endValue: widget.endValue,
                              startWidth: 10 / ratio.value,
                              endWidth: 10 / ratio.value,
                              gradient: SweepGradient(
                                //center: Alignment.topLeft,
                                colors: [
                                  Get.theme.primaryColor,
                                  Get.theme.focusColor,
                                ],
                              ),
                            ),
                          ],

                          ///指针
                          pointers: <GaugePointer>[
                            NeedlePointer(
                              value: widget.endValue,
                              animationType: AnimationType.easeOutBack,
                              enableAnimation: false,

                              ///指针颜色
                              //needleColor: Colors.red,
                              needleLength: 0.7,
                              gradient: LinearGradient(
                                  colors: [
                                    Get.theme.focusColor,
                                    Get.theme.primaryColor,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 158 / ratio.value,
                    height: 158 / ratio.value,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/theme${box.read("theme")}/board_bg.png'),
                          fit: BoxFit.fill),
                    ),
                    child: widget.centerWidget ?? const SizedBox(),
                  ),
                ),
                widget.bottomWidget == null
                    ? const SizedBox()
                    : Positioned(
                        bottom: widget.bottomPadding,
                        left: 0,
                        right: 0,
                        child: widget.bottomWidget!,
                      )
              ],
            ),
          ),
          // const SizedBox(height: 20),
          // GestureDetector(
          //   onPanDown: (DragDownDetails dragDownDetails) async {
          //     _isGetPressure = true;
          //     while (_isGetPressure) {
          //       if (aaa.value < widget.maxnum) {
          //         aaa.value = NumUtil.add(aaa.value, widget.changerate);
          //       }
          //       await Future.delayed(const Duration(milliseconds: 10));
          //     }
          //   },
          //   onPanCancel: () async {
          //     _isGetPressure = false;
          //     while (!_isGetPressure) {
          //       aaa.value = NumUtil.subtract(aaa.value, widget.changerate);

          //       if (aaa.value <= widget.minnum) {
          //         break;
          //       }
          //       await Future.delayed(const Duration(milliseconds: 10));
          //     }
          //   },
          //   onPanEnd: (DragEndDetails dragEndDetails) async {
          //     _isGetPressure = false;
          //     while (!_isGetPressure) {
          //       aaa.value = NumUtil.subtract(aaa.value, widget.changerate);

          //       print(aaa.value);
          //       if (aaa.value <= widget.minnum) {
          //         break;
          //       }
          //       await Future.delayed(const Duration(milliseconds: 10));
          //     }
          //   },
          //   child: const Text(
          //     '转动',
          //     style: TextStyle(
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
